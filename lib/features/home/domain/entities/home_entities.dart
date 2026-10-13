// Port of data/models/Models.kt (Room @Entity -> plain Dart models).
// Firestore-ready via toJson/fromJson.

enum AlertSeverity { critical, caution, info }
enum AlertCategory { permits, safetyHse, financeVat, submittal, escrow }
enum SubmittalStatus { approved, approvedComments, underReview, rejected }
enum SubmittalDiscipline { structural, architectural, mep, infrastructure }
enum PermitAuthority { dubaiMunicipality, rta, dewa, civilDefense, abuDhabiDmt }
enum SafetySeverity { high, medium, low }
enum SafetyCategory { workingAtHeight, ppeCompliance, excavationShoring, electricalSafety, heatStress }
enum TicketStatus { open, inProgress, resolved }

class Project {
  final String id;
  final String nameAr;
  final String nameEn;
  final String code;
  final String clientAr;
  final String clientEn;
  final String locationAr;
  final String locationEn;
  final double budgetAed;
  final double spentAed;
  final int completionPercent;
  final int daysRemaining;
  final double cpi;
  final double spi;

  const Project({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.code,
    required this.clientAr,
    required this.clientEn,
    required this.locationAr,
    required this.locationEn,
    required this.budgetAed,
    required this.spentAed,
    required this.completionPercent,
    required this.daysRemaining,
    required this.cpi,
    required this.spi,
  });

  static Project demo() => const Project(
    id: 'proj-01',
    nameAr: 'برج الوصل - الحزمة الإنشائية ٣',
    nameEn: 'Al Wasl Tower - Package 3',
    code: 'DXB-WTC-03',
    clientAr: 'مجموعة وصل للعقارات',
    clientEn: 'Wasl Properties Group',
    locationAr: 'شارع الشيخ زايد، دبي',
    locationEn: 'Sheikh Zayed Road, Dubai',
    budgetAed: 485000000,
    spentAed: 330200000,
    completionPercent: 68,
    daysRemaining: 245,
    cpi: 1.04,
    spi: 0.98,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'nameAr': nameAr, 'nameEn': nameEn, 'code': code,
    'budgetAed': budgetAed, 'spentAed': spentAed,
    'completionPercent': completionPercent, 'daysRemaining': daysRemaining,
    'cpi': cpi, 'spi': spi,
  };
}

class AlertItem {
  final String id;
  final String titleAr;
  final String titleEn;
  final String detailAr;
  final String detailEn;
  final AlertSeverity severity;
  final AlertCategory category;
  final String dateStr;
  final bool isResolved;
  const AlertItem({
    required this.id, required this.titleAr, required this.titleEn,
    required this.detailAr, required this.detailEn,
    required this.severity, required this.category,
    required this.dateStr, this.isResolved = false,
  });
}

class MaterialSubmittal {
  final String id;
  final String submittalNo;
  final String titleAr;
  final String titleEn;
  final SubmittalDiscipline discipline;
  final String supplier;
  final SubmittalStatus status;
  final String reviewCode;
  const MaterialSubmittal({
    required this.id, required this.submittalNo,
    required this.titleAr, required this.titleEn,
    required this.discipline, required this.supplier,
    required this.status, required this.reviewCode,
  });
}

class PermitItem {
  final String id;
  final PermitAuthority authority;
  final String permitNo;
  final String titleAr;
  final String titleEn;
  final String statusAr;
  final String statusEn;
  final int daysToExpiry;
  final double feeAed;
  const PermitItem({
    required this.id, required this.authority, required this.permitNo,
    required this.titleAr, required this.titleEn,
    required this.statusAr, required this.statusEn,
    required this.daysToExpiry, required this.feeAed,
  });
}

class SafetyTicket {
  final String id;
  final String ticketNo;
  final String titleAr;
  final String titleEn;
  final String location;
  final SafetySeverity severity;
  final SafetyCategory category;
  final TicketStatus status;
  final double fineRiskAed;
  const SafetyTicket({
    required this.id, required this.ticketNo,
    required this.titleAr, required this.titleEn,
    required this.location, required this.severity,
    required this.category, required this.status,
    required this.fineRiskAed,
  });
}

class HeatStressReading {
  final int ambientTempC;
  final double wbgtTempC;
  final int humidityPercent;
  final bool middayBreakEnforced;
  const HeatStressReading({
    this.ambientTempC = 42,
    this.wbgtTempC = 31.8,
    this.humidityPercent = 68,
    this.middayBreakEnforced = true,
  });
}

class FidicClaim {
  final String id;
  final String noticeNo;
  final String subClause;
  final String titleAr;
  final String titleEn;
  final int daysRemainingNotice;
  final double claimExposureAed;
  const FidicClaim({
    required this.id, required this.noticeNo, required this.subClause,
    required this.titleAr, required this.titleEn,
    required this.daysRemainingNotice, required this.claimExposureAed,
  });
}

class DailySiteLog {
  final String id;
  final String dateStr;
  final String summaryAr;
  final String summaryEn;
  final int manpower;
  final int equipmentCount;
  const DailySiteLog({
    required this.id, required this.dateStr,
    required this.summaryAr, required this.summaryEn,
    required this.manpower, required this.equipmentCount,
  });
}
