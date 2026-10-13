// Clean Architecture: core DAO for the home aggregate.
// Ports: BuildHubDaos.kt (Project/Alert/Submittal/Permit/SafetyTicket/
// FidicClaim/Marketplace/Order/Post/Tender/DailySiteLog DAOs) + AppDao.kt
// merged (no duplication in the port). Map-based rows; ordering mirrors
// the reference queries.
import 'package:sqflite/sqflite.dart';

class HomeDao {
  final Database db;
  const HomeDao(this.db);

  Future<List<Map<String, Object?>>> _all(String table,
      {String? orderBy}) =>
      db.query(table, orderBy: orderBy);

  Future<void> upsert(String table, Map<String, Object?> row) =>
      db.insert(table, row,
          conflictAlgorithm: ConflictAlgorithm.replace);

  Future<void> upsertAll(String table, List<Map<String, Object?>> rows) async {
    final batch = db.batch();
    for (final r in rows) {
      batch.insert(table, r,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<Map<String, Object?>?> byId(String table, String id) async {
    final rows =
        await db.query(table, where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : rows.first;
  }

  Future<int> deleteById(String table, String id) =>
      db.delete(table, where: 'id = ?', whereArgs: [id]);

  // -- Reference query shapes ------------------------------------------------
  Future<List<Map<String, Object?>>> projects() =>
      _all('projects');
  Future<List<Map<String, Object?>>> alerts() =>
      db.query('alerts', orderBy: 'isResolved, id');
  Future<int> resolveAlert(String id) => db.update(
      'alerts', {'isResolved': 1},
      where: 'id = ?', whereArgs: [id]);
  Future<List<Map<String, Object?>>> submittals() =>
      _all('submittals');
  Future<List<Map<String, Object?>>> permits() =>
      db.query('permits', orderBy: 'daysToExpiry');
  Future<List<Map<String, Object?>>> tickets() =>
      _all('safety_tickets');
  Future<List<Map<String, Object?>>> claims() =>
      db.query('fidic_claims', orderBy: 'daysRemainingNotice');
  Future<List<Map<String, Object?>>> marketplaceItems() =>
      _all('marketplace');
  Future<List<Map<String, Object?>>> orders() =>
      _all('orders');
  Future<List<Map<String, Object?>>> posts() => _all('posts');
  Future<List<Map<String, Object?>>> tenders() =>
      db.query('tenders', orderBy: 'deadline');
  Future<List<Map<String, Object?>>> logsForProject(String projectId) =>
      db.query('daily_logs',
          where: 'projectId = ?', whereArgs: [projectId]);
  Future<List<Map<String, Object?>>> allLogs() => _all('daily_logs');
}
