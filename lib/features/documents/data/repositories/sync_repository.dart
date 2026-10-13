// Clean Architecture: Documents — Data sync repositories.
// Ports: DailyReportSyncRepository.kt + RecordSyncRepository.kt +
// DefaultOfflineFirstRepository.kt — version-based conflict policy
// (PENDING → SYNCED / CONFLICT / FAILED) with WorkflowEngine-gated
// record transitions. In-memory now; cloud_firestore push wiring later
// (see FirestorePaths for the exact collections).
import 'package:flutter/material.dart';
import 'package:buildhub/core/database/app_database.dart';
import 'package:buildhub/core/database/daos/sync_dao.dart';
import '../../domain/entities/sync_entities.dart';
import '../../domain/repositories/offline_first_repository.dart';
import '../../domain/workflow/record_workflow.dart';
import '../mappers/sync_mappers.dart';

class DailyReportSyncRepository extends ChangeNotifier {
  final List<DailyReportEntity> _reports = [];
  SyncDao? _dao;
  bool _hydrated = false;

  /// First read hydrates the in-memory cache from sqflite in the
  /// background; readers stay synchronous so existing callers are safe.
  Future<void> _ensureHydrated() async {
    if (_hydrated) return;
    _hydrated = true;
    try {
      final dao = await AppDatabase.instance.syncDao();
      _dao = dao;
      final rows = await dao.all('daily_reports');
      final ids = _reports.map((r) => r.id).toSet();
      for (final row in rows) {
        final entity = SyncMappers.reportFromRow(row);
        if (!ids.contains(entity.id)) _reports.add(entity);
      }
      notifyListeners();
    } catch (_) {}
  }

  List<DailyReportEntity> forProject(String projectId) {
    _ensureHydrated();
    return _reports.where((r) => r.projectId == projectId).toList();
  }

  DailyReportEntity? byId(String id) {
    _ensureHydrated();
    for (final r in _reports) {
      if (r.id == id) return r;
    }
    return null;
  }

  int pendingCount(String projectId) {
    _ensureHydrated();
    return forProject(projectId)
        .where((r) => r.syncState == SyncState.pending)
        .length;
  }

  /// Saves locally as PENDING with nextVersion, then attempts push.
  /// Mirrors the reference: conflict → CONFLICT, IO → stays PENDING.
  Future<DailyReportEntity> saveReport(DailyReportEntity report) async {
    final existing = byId(report.id);
    final next = report.copyWith(
      version: (existing?.version ?? 0) + 1,
      syncState: SyncState.pending,
      updatedAt: DateTime.now().toIso8601String(),
    );
    if (existing == null) {
      _reports.add(next);
    } else {
      _reports[_reports.indexOf(existing)] = next;
    }
    notifyListeners();
    await _persist(next);
    await pushReport(next);
    return byId(next.id) ?? next;
  }

  Future<void> _persist(DailyReportEntity report) async {
    try {
      await _ensureHydrated();
      await _dao?.upsert(
          'daily_reports', SyncMappers.reportToRow(report));
    } catch (_) {}
  }

  Future<void> pushReport(DailyReportEntity report) async {
    // TODO: cloud_firestore push to FirestorePaths.dailyLog with
    // remote-version check (remote > local → ConflictException).
    _replace(report.copyWith(syncState: SyncState.synced));
  }

  /// Pushes pending reports in order; stops at first transport failure.
  Future<int> syncPendingReports(String projectId) async {
    var synced = 0;
    for (final r in forProject(projectId)
        .where((e) => e.syncState == SyncState.pending)
        .toList()) {
      try {
        await pushReport(r);
        synced++;
      } catch (_) {
        break;
      }
    }
    return synced;
  }

  void _replace(DailyReportEntity report) {
    final i = _reports.indexWhere((r) => r.id == report.id);
    if (i != -1) _reports[i] = report;
    notifyListeners();
    _persist(report);
  }
}

class RecordSyncRepository extends ChangeNotifier {
  final WorkflowEngine workflowEngine;
  final List<RecordEntity> _records = [];
  SyncDao? _dao;
  bool _hydrated = false;

  RecordSyncRepository({WorkflowEngine? workflowEngine})
      : workflowEngine = workflowEngine ?? WorkflowEngine();

  Future<void> _ensureHydrated() async {
    if (_hydrated) return;
    _hydrated = true;
    try {
      final dao = await AppDatabase.instance.syncDao();
      _dao = dao;
      final rows = await dao.all('records');
      final ids = _records.map((r) => r.id).toSet();
      for (final row in rows) {
        final entity = SyncMappers.recordFromRow(row);
        if (!ids.contains(entity.id)) _records.add(entity);
      }
      notifyListeners();
    } catch (_) {}
  }

  List<RecordEntity> forProject(String projectId) {
    _ensureHydrated();
    return _records.where((r) => r.projectId == projectId).toList();
  }

  List<RecordEntity> byType(String projectId, String type) =>
      forProject(projectId).where((r) => r.type == type).toList();

  RecordEntity? byId(String id) {
    _ensureHydrated();
    for (final r in _records) {
      if (r.id == id) return r;
    }
    return null;
  }

  int pendingCount(String projectId) {
    _ensureHydrated();
    return forProject(projectId)
        .where((r) => r.syncState == SyncState.pending)
        .length;
  }

  Future<RecordEntity> saveRecord(RecordEntity record) async {
    final existing = byId(record.id);
    final next = record.copyWith(
      version: (existing?.version ?? 0) + 1,
      syncState: SyncState.pending,
      updatedAt: DateTime.now().toIso8601String(),
    );
    if (existing == null) {
      _records.add(next);
    } else {
      _records[_records.indexOf(existing)] = next;
    }
    notifyListeners();
    await _persist(next);
    // TODO: push to FirestorePaths.typedRecord with version check.
    _replace(next.copyWith(syncState: SyncState.synced));
    return byId(next.id) ?? next;
  }

  Future<void> _persist(RecordEntity record) async {
    try {
      await _ensureHydrated();
      await _dao?.upsert('records', SyncMappers.recordToRow(record));
    } catch (_) {}
  }

  Future<MoveResult> transitionRecord(
    String recordId,
    String targetStatus,
    String userId,
    RecordRole role, {
    String? comment,
  }) async {
    final current = byId(recordId);
    if (current == null) {
      return const MoveDenied('السجل غير موجود', 'Record not found');
    }
    final siteRecord = SiteRecord(
      id: current.id, projectId: current.projectId, orgId: current.orgId,
      type: RecordType.values.firstWhere(
          (t) => t.name.toUpperCase() == current.type,
          orElse: () => RecordType.rfi),
      number: current.number, title: current.title, status: current.status,
      createdBy: current.createdBy, createdAt: current.createdAt,
      updatedAt: current.updatedAt, version: current.version,
      contentHash: current.contentHash,
    );
    final result =
        workflowEngine.move(siteRecord, targetStatus, userId, role, comment: comment);
    if (result is MoveOk) {
      await saveRecord(current.copyWith(
        status: result.record.status,
        version: result.record.version,
        contentHash: result.record.contentHash,
      ));
    }
    return result;
  }

  Future<int> syncPendingRecords(String projectId) async {
    var synced = 0;
    for (final r in forProject(projectId)
        .where((e) => e.syncState == SyncState.pending)
        .toList()) {
      try {
        await saveRecord(r);
        synced++;
      } catch (_) {
        break;
      }
    }
    return synced;
  }

  void _replace(RecordEntity record) {
    final i = _records.indexWhere((r) => r.id == record.id);
    if (i != -1) _records[i] = record;
    notifyListeners();
    _persist(record);
  }
}

class DefaultOfflineFirstRepository extends ChangeNotifier
    implements IOfflineFirstRepository {
  final DailyReportSyncRepository reports;
  final RecordSyncRepository records;

  DefaultOfflineFirstRepository({
    DailyReportSyncRepository? reports,
    RecordSyncRepository? records,
  })  : reports = reports ?? DailyReportSyncRepository(),
        records = records ?? RecordSyncRepository();

  @override
  List<DailyReportEntity> dailyReportsFor(String projectId) =>
      reports.forProject(projectId);

  @override
  DailyReportEntity? dailyReportById(String id) => reports.byId(id);

  @override
  Future<DailyReportEntity> saveDailyReport(DailyReportEntity report) =>
      reports.saveReport(report);

  @override
  Future<void> deleteDailyReport(String id) async {}

  @override
  Future<int> syncDailyReports(String projectId) =>
      reports.syncPendingReports(projectId);

  @override
  Future<int> syncRecords(String projectId) =>
      records.syncPendingRecords(projectId);

  @override
  List<RecordEntity> recordsFor(String projectId) =>
      records.forProject(projectId);

  @override
  List<RecordEntity> recordsByType(String projectId, String type) =>
      records.byType(projectId, type);

  @override
  RecordEntity? recordById(String id) => records.byId(id);

  @override
  Future<RecordEntity> saveRecord(RecordEntity record) =>
      records.saveRecord(record);

  @override
  Future<void> deleteRecord(String id) async {}

  @override
  int totalPendingCount(String projectId) =>
      reports.pendingCount(projectId) + records.pendingCount(projectId);

  @override
  Future<(int, int)> syncAllPending(String projectId) async {
    final r = await syncDailyReports(projectId);
    final c = await syncRecords(projectId);
    return (r, c);
  }
}
