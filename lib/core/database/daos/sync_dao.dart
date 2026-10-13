// Clean Architecture: core DAO for the offline-first pipeline.
// Ports: RecordDao.kt + DailyReportDao.kt + SnagDao.kt — pending/overdue
// observers, upserts and markSynced/markConflict/markFailed transitions.
import 'package:sqflite/sqflite.dart';

class SyncDao {
  final Database db;
  const SyncDao(this.db);

  Future<void> upsert(String table, Map<String, Object?> row) =>
      db.insert(table, row,
          conflictAlgorithm: ConflictAlgorithm.replace);

  Future<List<Map<String, Object?>>> all(String table) =>
      db.query(table);

  Future<Map<String, Object?>?> byId(String table, String id) async {
    final rows =
        await db.query(table, where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : rows.first;
  }

  Future<List<Map<String, Object?>>> forProject(
          String table, String projectId,
          {String orderBy = 'updatedAt'}) =>
      db.query(table,
          where: 'projectId = ?', whereArgs: [projectId], orderBy: orderBy);

  Future<List<Map<String, Object?>>> pending(String table) => db.query(
      table,
      where: 'syncState = ?',
      whereArgs: ['pending']);

  Future<int> pendingCount(String table, String projectId) async {
    final rows = await db.rawQuery(
        'SELECT COUNT(*) AS c FROM $table WHERE projectId = ? AND syncState = ?',
        [projectId, 'pending']);
    return (rows.first['c'] as num? ?? 0).toInt();
  }

  Future<List<Map<String, Object?>>> overdueRecords(
      String projectId, String nowIso) =>
      db.query('records',
          where:
              'projectId = ? AND dueDate < ? AND dueDate != ? AND status NOT IN (?,?,?)',
          whereArgs: [
            projectId, nowIso, '', 'ANSWERED', 'APPROVED', 'LOCKED'
          ]);

  Future<int> mark(
          String table, String id, String syncState) =>
      db.update(table, {'syncState': syncState},
          where: 'id = ?', whereArgs: [id]);

  Future<int> deleteById(String table, String id) =>
      db.delete(table, where: 'id = ?', whereArgs: [id]);
}
