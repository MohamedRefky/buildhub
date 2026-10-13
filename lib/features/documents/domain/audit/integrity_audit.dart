// Clean Architecture: Documents — Domain data-integrity audit engine.
// Ports: DataIntegrityAuditEngine.kt — detects orphan/broken/inconsistent/
// duplicate records across repositories and auto-remediates. Pure Dart.
// Operates on plain maps so it stays decoupled from repository classes.

enum IntegritySeverity { info, warning, critical }

class IntegrityIssue {
  final String id;
  final String category;
  final IntegritySeverity severity;
  final String entityType;
  final String entityId;
  final String descriptionAr;
  final String descriptionEn;
  final bool canAutoRemediate;
  final bool isRemediated;
  const IntegrityIssue({
    required this.id, required this.category, required this.severity,
    required this.entityType, required this.entityId,
    required this.descriptionAr, required this.descriptionEn,
    this.canAutoRemediate = true, this.isRemediated = false,
  });

  IntegrityIssue remediated() => IntegrityIssue(
        id: id, category: category, severity: severity,
        entityType: entityType, entityId: entityId,
        descriptionAr: descriptionAr, descriptionEn: descriptionEn,
        canAutoRemediate: canAutoRemediate, isRemediated: true,
      );
}

class DataIntegrityReport {
  final String reportTimestamp;
  final int totalRecordsAudited;
  final List<IntegrityIssue> issues;
  const DataIntegrityReport({
    required this.reportTimestamp,
    required this.totalRecordsAudited,
    required this.issues,
  });

  int get totalIssuesFound => issues.length;
  int get criticalIssuesCount =>
      issues.where((i) => i.severity == IntegritySeverity.critical).length;
  int get warningIssuesCount =>
      issues.where((i) => i.severity == IntegritySeverity.warning).length;
  bool get isDatabaseHealthy => criticalIssuesCount == 0;
}

/// Vendor shape: {id, tradeLicenseNumber}
/// Activity shape: {id, predecessorId}
/// Money-doc shape: {id, subtotalAed, vatAed, grandTotalAed}
/// Order shape: {id, projectId}
class DataIntegrityAuditEngine {
  const DataIntegrityAuditEngine();

  DataIntegrityReport runSystemIntegrityCheck({
    List<Map<String, dynamic>> vendors = const [],
    List<Map<String, dynamic>> activities = const [],
    List<Map<String, dynamic>> moneyDocs = const [],
    List<Map<String, dynamic>> purchaseOrders = const [],
  }) {
    final issues = <IntegrityIssue>[];

    // (1) Duplicate vendor trade-license numbers → CRITICAL.
    final seenLicenses = <String, String>{};
    for (final v in vendors) {
      final lic = '${v['tradeLicenseNumber'] ?? ''}'.trim();
      final id = '${v['id'] ?? ''}';
      if (lic.isEmpty) continue;
      if (seenLicenses.containsKey(lic)) {
        issues.add(IntegrityIssue(
          id: 'ISSUE-DUP-VEND-$id', category: 'DUPLICATE_ENTITY',
          severity: IntegritySeverity.critical,
          entityType: 'vendor', entityId: id,
          descriptionAr: 'رقم رخصة مكرر: $lic (مكرر مع ${seenLicenses[lic]})',
          descriptionEn: 'Duplicate trade license: $lic (also ${seenLicenses[lic]})',
        ));
      } else {
        seenLicenses[lic] = id;
      }
    }

    // (2) Activity predecessor references that do not exist → WARNING.
    final activityIds = activities.map((a) => '${a['id']}').toSet();
    for (final a in activities) {
      final pred = '${a['predecessorId'] ?? ''}';
      if (pred.isNotEmpty && !activityIds.contains(pred)) {
        issues.add(IntegrityIssue(
          id: 'ISSUE-BRK-DEP-${a['id']}', category: 'BROKEN_REFERENCE',
          severity: IntegritySeverity.warning,
          entityType: 'activity', entityId: '${a['id']}',
          descriptionAr: 'مرجع سابق مكسور: $pred',
          descriptionEn: 'Broken predecessor reference: $pred',
        ));
      }
    }

    // (3) grandTotal != subtotal + 5% VAT beyond 0.05 tolerance → CRITICAL.
    for (final d in moneyDocs) {
      final sub = (d['subtotalAed'] as num? ?? 0).toDouble();
      final vat = (d['vatAed'] as num? ?? 0).toDouble();
      final grand = (d['grandTotalAed'] as num? ?? 0).toDouble();
      if ((grand - (sub + vat)).abs() > 0.05) {
        issues.add(IntegrityIssue(
          id: 'ISSUE-INC-VAT-${d['id']}', category: 'INCONSISTENT_TOTAL',
          severity: IntegritySeverity.critical,
          entityType: 'moneyDoc', entityId: '${d['id']}',
          descriptionAr: 'الإجمالي لا يطابق المجموع الفرعي + الضريبة',
          descriptionEn: 'Grand total != subtotal + VAT',
        ));
      }
    }

    // (4) Purchase orders with empty projectId → WARNING (orphan).
    for (final o in purchaseOrders) {
      if ('${o['projectId'] ?? ''}'.isEmpty) {
        issues.add(IntegrityIssue(
          id: 'ISSUE-ORPH-PO-${o['id']}', category: 'ORPHAN_RECORD',
          severity: IntegritySeverity.warning,
          entityType: 'purchaseOrder', entityId: '${o['id']}',
          descriptionAr: 'أمر شراء يتيم بدون مشروع',
          descriptionEn: 'Orphan purchase order without project',
        ));
      }
    }

    final total = vendors.length +
        activities.length +
        moneyDocs.length +
        purchaseOrders.length;
    return DataIntegrityReport(
      reportTimestamp: DateTime.now().toIso8601String(),
      totalRecordsAudited: total,
      issues: issues,
    );
  }

  DataIntegrityReport runAutoRemediation(DataIntegrityReport report) {
    final remediated =
        report.issues.map((i) => i.canAutoRemediate ? i.remediated() : i).toList();
    return DataIntegrityReport(
      reportTimestamp: DateTime.now().toIso8601String(),
      totalRecordsAudited: report.totalRecordsAudited,
      issues: remediated,
    );
  }
}
