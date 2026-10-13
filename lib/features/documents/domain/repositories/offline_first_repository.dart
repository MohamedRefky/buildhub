// Clean Architecture: Documents — Domain offline-first contract.
// Ports: OfflineFirstRepository.kt (interface) — local store is the source
// of truth, Firestore syncs pending records in the background.
import '../entities/sync_entities.dart';

abstract class IOfflineFirstRepository {
  List<DailyReportEntity> dailyReportsFor(String projectId);
  DailyReportEntity? dailyReportById(String id);
  Future<DailyReportEntity> saveDailyReport(DailyReportEntity report);
  Future<void> deleteDailyReport(String id);
  Future<int> syncDailyReports(String projectId);

  List<RecordEntity> recordsFor(String projectId);
  List<RecordEntity> recordsByType(String projectId, String type);
  RecordEntity? recordById(String id);
  Future<RecordEntity> saveRecord(RecordEntity record);
  Future<void> deleteRecord(String id);
  Future<int> syncRecords(String projectId);

  int totalPendingCount(String projectId);
  Future<(int, int)> syncAllPending(String projectId);
}
