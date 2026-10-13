// Clean Architecture: core local database.
// Ports: AppDatabase.kt (buildhub_uae.db v11) + BuildHubDatabase.kt alias.
// 20 tables mirroring the reference entities, adapted to the ported
// Dart entity shapes. DAOs stay Map-based so core never imports features;
// entity <-> row mappers live beside the repositories that use them.
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'daos/business_dao.dart';
import 'daos/home_dao.dart';
import 'daos/sync_dao.dart';

class AppDatabase {
  static const dbName = 'buildhub_uae.db';
  static const dbVersion = 11;

  static final AppDatabase instance = AppDatabase._();
  AppDatabase._();

  Database? _db;

  Future<Database> get database async {
    final existing = _db;
    if (existing != null && existing.isOpen) return existing;
    final dir = await getDatabasesPath();
    _db = await openDatabase(join(dir, dbName),
        version: dbVersion, onCreate: (db, _) => createTables(db));
    return _db!;
  }

  /// In-memory handle for unit tests (sqflite_common_ffi).
  static Future<Database> openInMemory() => openDatabase(
      inMemoryDatabasePath,
      version: dbVersion,
      onCreate: (db, _) => createTables(db));

  Future<HomeDao> homeDao() async => HomeDao(await database);
  Future<SyncDao> syncDao() async => SyncDao(await database);
  Future<BusinessDao> businessDao() async =>
      BusinessDao(await database);

  static Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE projects(
        id TEXT PRIMARY KEY, nameAr TEXT, nameEn TEXT, code TEXT,
        clientAr TEXT, clientEn TEXT, locationAr TEXT, locationEn TEXT,
        budgetAed REAL, spentAed REAL, completionPercent INTEGER,
        daysRemaining INTEGER, cpi REAL, spi REAL)''');
    await db.execute('''
      CREATE TABLE alerts(
        id TEXT PRIMARY KEY, titleAr TEXT, titleEn TEXT,
        detailAr TEXT, detailEn TEXT, severity TEXT, category TEXT,
        dateStr TEXT, isResolved INTEGER)''');
    await db.execute('''
      CREATE TABLE submittals(
        id TEXT PRIMARY KEY, submittalNo TEXT, titleAr TEXT, titleEn TEXT,
        discipline TEXT, supplier TEXT, status TEXT, reviewCode TEXT)''');
    await db.execute('''
      CREATE TABLE permits(
        id TEXT PRIMARY KEY, authority TEXT, permitNo TEXT,
        titleAr TEXT, titleEn TEXT, statusAr TEXT, statusEn TEXT,
        daysToExpiry INTEGER, feeAed REAL)''');
    await db.execute('''
      CREATE TABLE safety_tickets(
        id TEXT PRIMARY KEY, ticketNo TEXT, titleAr TEXT, titleEn TEXT,
        location TEXT, severity TEXT, category TEXT, status TEXT,
        fineRiskAed REAL)''');
    await db.execute('''
      CREATE TABLE fidic_claims(
        id TEXT PRIMARY KEY, noticeNo TEXT, subClause TEXT,
        titleAr TEXT, titleEn TEXT, daysRemainingNotice INTEGER,
        claimExposureAed REAL)''');
    await db.execute('''
      CREATE TABLE marketplace(
        id TEXT PRIMARY KEY, titleAr TEXT, titleEn TEXT, category TEXT,
        priceAed REAL, supplierId TEXT, isVerifiedSupplier INTEGER)''');
    await db.execute('''
      CREATE TABLE orders(
        id TEXT PRIMARY KEY, poNumber TEXT, projectId TEXT,
        materialNameAr TEXT, materialNameEn TEXT, quantity REAL, unit TEXT,
        status TEXT, progressPercent INTEGER, supplierName TEXT,
        expectedDeliveryDate TEXT, subtotalAed REAL, vatAed REAL,
        grandTotalAed REAL, escrowLocked INTEGER)''');
    await db.execute('''
      CREATE TABLE posts(
        id TEXT PRIMARY KEY, author TEXT,
        bodyAr TEXT, bodyEn TEXT, likes INTEGER)''');
    await db.execute('''
      CREATE TABLE tenders(
        id TEXT PRIMARY KEY, titleAr TEXT, titleEn TEXT, authority TEXT,
        deadline TEXT, estValueAed REAL)''');
    await db.execute('''
      CREATE TABLE machine_listings(
        id TEXT PRIMARY KEY, type TEXT, titleAr TEXT, titleEn TEXT,
        priceAed REAL, supplierId TEXT, isUserSubmitted INTEGER)''');
    await db.execute('''
      CREATE TABLE daily_logs(
        id TEXT PRIMARY KEY, projectId TEXT, dateStr TEXT, timestamp TEXT,
        summaryAr TEXT, summaryEn TEXT, note TEXT, category TEXT,
        author TEXT, photoUri TEXT, weatherSnapshot TEXT,
        manpower INTEGER, equipmentCount INTEGER)''');
    await db.execute('''
      CREATE TABLE supplier_materials(
        id TEXT PRIMARY KEY, supplierId TEXT, materialNameAr TEXT,
        materialNameEn TEXT, unitPriceAed REAL, unit TEXT)''');
    await db.execute('''
      CREATE TABLE safety_passports(
        id TEXT PRIMARY KEY, category TEXT, nameAr TEXT, nameEn TEXT,
        idOrPlateNumber TEXT, qrPayload TEXT, status TEXT,
        nextInspectionDue TEXT, certificatesJson TEXT)''');
    await db.execute('''
      CREATE TABLE user_files(
        id TEXT PRIMARY KEY, ownerUid TEXT, fileName TEXT, storagePath TEXT,
        downloadUrl TEXT, sizeBytes INTEGER, visibility TEXT,
        fileType TEXT, mimeType TEXT, projectAssociated TEXT,
        description TEXT, uploaderEmail TEXT, uploadDateStr TEXT,
        isLocalOnly INTEGER)''');
    await db.execute('''
      CREATE TABLE daily_reports(
        id TEXT PRIMARY KEY, projectId TEXT, date TEXT, status TEXT,
        weatherJson TEXT, manpowerJson TEXT, activitiesJson TEXT,
        deliveriesJson TEXT, issuesJson TEXT, photosJson TEXT,
        instructionsJson TEXT, generatedBy TEXT, signedBy TEXT,
        signedAt TEXT, contentHash TEXT, syncState TEXT, updatedAt TEXT,
        version INTEGER)''');
    await db.execute('''
      CREATE TABLE records(
        id TEXT PRIMARY KEY, projectId TEXT, orgId TEXT, type TEXT,
        number TEXT, title TEXT, status TEXT, createdBy TEXT,
        createdAt TEXT, updatedAt TEXT, version INTEGER, contentHash TEXT,
        syncState TEXT, dueDate TEXT, comments TEXT)''');
    await db.execute('''
      CREATE TABLE snags(
        id TEXT PRIMARY KEY, projectId TEXT, title TEXT, status TEXT,
        severity TEXT, location TEXT, updatedAt TEXT, syncState TEXT,
        version INTEGER)''');
    await db.execute('''
      CREATE TABLE finance_claims(
        id TEXT PRIMARY KEY, noticeNo TEXT, subClause TEXT,
        titleAr TEXT, titleEn TEXT, daysRemainingNotice INTEGER,
        exposureAed REAL, status TEXT)''');
    await db.execute('''
      CREATE TABLE wallets(
        id TEXT PRIMARY KEY, holderName TEXT,
        balanceAed REAL, monthlyLimitAed REAL)''');
  }
}
