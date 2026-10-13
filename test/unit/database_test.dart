// Database layer tests via sqflite_common_ffi (in-memory).
// Covers schema creation, converters, sync DAO transitions and mappers.
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:buildhub/core/database/app_database.dart';
import 'package:buildhub/core/database/converters.dart';
import 'package:buildhub/core/database/daos/business_dao.dart';
import 'package:buildhub/core/database/daos/home_dao.dart';
import 'package:buildhub/core/database/daos/sync_dao.dart';
import 'package:buildhub/features/documents/data/mappers/sync_mappers.dart';
import 'package:buildhub/features/documents/domain/entities/sync_entities.dart';

void main() {
  late Database db;
  late HomeDao home;
  late SyncDao sync;
  late BusinessDao business;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await AppDatabase.openInMemory();
    home = HomeDao(db);
    sync = SyncDao(db);
    business = BusinessDao(db);
  });

  tearDown(() async => db.close());

  test('all 20 tables exist', () async {
    final rows = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name");
    final names = rows.map((r) => r['name'] as String).toSet();
    for (final t in [
      'projects', 'alerts', 'submittals', 'permits', 'safety_tickets',
      'fidic_claims', 'marketplace', 'orders', 'posts', 'tenders',
      'machine_listings', 'daily_logs', 'supplier_materials',
      'safety_passports', 'user_files', 'daily_reports', 'records',
      'snags', 'finance_claims', 'wallets',
    ]) {
      expect(names, contains(t));
    }
  });

  test('converters round-trip enums and numbers', () {
    expect(DbConverters.e(SyncState.pending), 'pending');
    expect(
        DbConverters.enums('synced', SyncState.values, SyncState.pending),
        SyncState.synced);
    expect(
        DbConverters.enums('nope', SyncState.values, SyncState.pending),
        SyncState.pending);
    expect(DbConverters.i(true), 1);
    expect(DbConverters.b(1), isTrue);
    expect(DbConverters.d(3.5), 3.5);
    expect(DbConverters.d(null), 0);
    expect(DbConverters.n(null), 0);
  });

  test('home dao project + alert resolve flow', () async {
    await home.upsert('projects', {
      'id': 'p1', 'nameAr': 'م', 'nameEn': 'P', 'code': 'C',
      'clientAr': '', 'clientEn': '', 'locationAr': '', 'locationEn': '',
      'budgetAed': 10.0, 'spentAed': 1.0, 'completionPercent': 5,
      'daysRemaining': 9, 'cpi': 1.0, 'spi': 1.0,
    });
    expect((await home.projects()).length, 1);
    await home.upsert('alerts', {
      'id': 'a1', 'titleAr': 'ت', 'titleEn': 'T', 'detailAr': '',
      'detailEn': '', 'severity': 'critical', 'category': 'permits',
      'dateStr': '2026-01-01', 'isResolved': 0,
    });
    expect((await home.alerts()).length, 1);
    await home.resolveAlert('a1');
    expect((await home.byId('alerts', 'a1'))?['isResolved'], 1);
  });

  test('sync dao pending/mark/overdue cycle', () async {
    await sync.upsert('records', {
      'id': 'r1', 'projectId': 'p1', 'orgId': 'o', 'type': 'RFI',
      'number': 'RFI-1', 'title': 'Q', 'status': 'SUBMITTED',
      'createdBy': 'u', 'createdAt': 't', 'updatedAt': 't', 'version': 2,
      'contentHash': null, 'syncState': 'pending',
      'dueDate': '2000-01-01', 'comments': '',
    });
    expect(await sync.pendingCount('records', 'p1'), 1);
    final overdue =
        await sync.overdueRecords('p1', '2026-01-01T00:00:00');
    expect(overdue.length, 1);
    await sync.mark('records', 'r1', 'synced');
    expect(await sync.pendingCount('records', 'p1'), 0);
  });

  test('mappers preserve sync entities', () {
    const record = RecordEntity(
        id: 'r1', projectId: 'p1', orgId: 'o', type: 'VO', number: 'VO-1',
        title: 'V', status: 'DRAFT', createdBy: 'u',
        createdAt: 't', updatedAt: 't', version: 3,
        syncState: SyncState.conflict, dueDate: 'd', comments: 'c');
    final back = SyncMappers.recordFromRow(
        SyncMappers.recordToRow(record));
    expect(back.version, 3);
    expect(back.syncState, SyncState.conflict);
    expect(back.type, 'VO');

    const report = DailyReportEntity(
        id: 'd1', projectId: 'p1', date: '2026-01-01',
        generatedBy: 'agent', status: ReportStatus.signed,
        syncState: SyncState.synced, version: 2);
    final backReport = SyncMappers.reportFromRow(
        SyncMappers.reportToRow(report));
    expect(backReport.status, ReportStatus.signed);
    expect(backReport.version, 2);

    const snag = SnagEntity(
        id: 's1', projectId: 'p1', title: 'S', status: 'OPEN',
        severity: SnagSeverity.critical, syncState: SyncState.failed);
    final backSnag =
        SyncMappers.snagFromRow(SyncMappers.snagToRow(snag));
    expect(backSnag.severity, SnagSeverity.critical);
    expect(backSnag.syncState, SyncState.failed);
  });

  test('business dao user files accounting', () async {
    await business.upsert('user_files', {
      'id': 'f1', 'ownerUid': 'u1', 'fileName': 'a.pdf',
      'storagePath': 'p', 'downloadUrl': '', 'sizeBytes': 100,
      'visibility': 'project', 'fileType': 'PDF', 'mimeType': '',
      'projectAssociated': '', 'description': '', 'uploaderEmail': '',
      'uploadDateStr': '', 'isLocalOnly': 1,
    });
    expect(await business.filesCount('u1'), 1);
    expect(await business.storageUsedBytes('u1'), 100);
    await business.clearUserFiles('u1');
    expect(await business.filesCount('u1'), 0);
  });
}
