// Clean Architecture: core DAO for business tables.
// Ports: UserFileDao.kt + SafetyPassportDao.kt + MaterialOrderDao.kt +
// MachineListingDao.kt + SupplierMaterialDao.kt + finance/wallet stores.
import 'package:sqflite/sqflite.dart';

class BusinessDao {
  final Database db;
  const BusinessDao(this.db);

  Future<void> upsert(String table, Map<String, Object?> row) =>
      db.insert(table, row,
          conflictAlgorithm: ConflictAlgorithm.replace);

  Future<void> upsertAll(
      String table, List<Map<String, Object?>> rows) async {
    final batch = db.batch();
    for (final r in rows) {
      batch.insert(table, r,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<int> deleteById(String table, String id) =>
      db.delete(table, where: 'id = ?', whereArgs: [id]);

  // -- User files ------------------------------------------------------------
  Future<List<Map<String, Object?>>> userFiles(String userId) =>
      db.query('user_files',
          where: 'ownerUid = ?', whereArgs: [userId]);
  Future<int> filesCount(String userId) async {
    final rows = await db.rawQuery(
        'SELECT COUNT(*) AS c FROM user_files WHERE ownerUid = ?',
        [userId]);
    return (rows.first['c'] as num? ?? 0).toInt();
  }

  Future<int> storageUsedBytes(String userId) async {
    final rows = await db.rawQuery(
        'SELECT SUM(sizeBytes) AS s FROM user_files WHERE ownerUid = ?',
        [userId]);
    return (rows.first['s'] as num? ?? 0).toInt();
  }

  Future<int> clearUserFiles(String userId) => db
      .delete('user_files', where: 'ownerUid = ?', whereArgs: [userId]);

  // -- Safety passports ------------------------------------------------------
  Future<List<Map<String, Object?>>> passports() =>
      _all('safety_passports');
  Future<List<Map<String, Object?>>> passportsByCategory(
          String category) =>
      db.query('safety_passports',
          where: 'category = ?', whereArgs: [category]);

  // -- Machines & supplier materials -----------------------------------------
  Future<List<Map<String, Object?>>> machineListings() =>
      db.query('machine_listings', orderBy: 'isUserSubmitted, id');
  Future<List<Map<String, Object?>>> machineListingsByType(String type) =>
      db.query('machine_listings',
          where: 'type = ?', whereArgs: [type]);
  Future<List<Map<String, Object?>>> supplierMaterials() =>
      _all('supplier_materials');
  Future<List<Map<String, Object?>>> searchMaterials(String query) =>
      db.query('supplier_materials',
          where:
              'category LIKE ? OR materialNameAr LIKE ? OR materialNameEn LIKE ?',
          whereArgs: ['%$query%', '%$query%', '%$query%']);

  // -- Finance ---------------------------------------------------------------
  Future<List<Map<String, Object?>>> financeClaims() =>
      _all('finance_claims');
  Future<List<Map<String, Object?>>> wallets() => _all('wallets');

  Future<List<Map<String, Object?>>> _all(String table) =>
      db.query(table);
}
