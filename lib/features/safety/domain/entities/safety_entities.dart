// Clean Architecture: Safety feature — Domain entities.
// Ports: SafetyPassport.kt (+ Models.kt SafetyTicket/HeatStress parts).
enum PassportCategory { labor, staff, machine }
enum ComplianceStatus { verifiedValid, expiringSoon, suspendedOrExpired }
enum CertificateStatus { activeValid, expiringSoon, expired }

class SafetyCertificate {
  final String id;
  final String titleAr;
  final String titleEn;
  final String certNumber;
  final String expiryDate;
  final CertificateStatus status;
  const SafetyCertificate({
    required this.id, required this.titleAr, required this.titleEn,
    required this.certNumber, required this.expiryDate,
    this.status = CertificateStatus.activeValid,
  });
}

class SafetyPassport {
  final String id;
  final PassportCategory category;
  final String nameAr;
  final String nameEn;
  final String idOrPlateNumber;
  final String qrPayload;
  final ComplianceStatus status;
  final String nextInspectionDue;
  final List<SafetyCertificate> certificates;
  const SafetyPassport({
    required this.id, required this.category,
    required this.nameAr, required this.nameEn,
    required this.idOrPlateNumber, required this.qrPayload,
    this.status = ComplianceStatus.verifiedValid,
    this.nextInspectionDue = '',
    this.certificates = const [],
  });
}

class CraneWindReading {
  final double windSpeedMs;
  final bool craneOperationAllowed;
  final String adviceAr;
  final String adviceEn;
  const CraneWindReading({
    required this.windSpeedMs, required this.craneOperationAllowed,
    this.adviceAr = '', this.adviceEn = '',
  });
}
