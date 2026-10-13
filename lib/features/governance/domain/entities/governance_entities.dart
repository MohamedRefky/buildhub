// Clean Architecture: Governance feature — Domain entities.
// Ports: ApprovalEngineModels.kt, ExceptionOverrideModels.kt,
// OrionRoadmapModels.kt, OrionGreenPassModels.kt, EnterpriseDailyReportModel.kt
enum ApprovalStatus { pending, approved, rejected, escalated }
enum ExceptionSeverity { low, medium, high, critical }
enum RoadmapPhaseStatus { notStarted, inProgress, gated, completed }

class ApprovalRequest {
  final String id;
  final String titleAr;
  final String titleEn;
  final String requester;
  final ApprovalStatus status;
  final int level;
  const ApprovalRequest({
    required this.id, required this.titleAr, required this.titleEn,
    required this.requester, this.status = ApprovalStatus.pending,
    this.level = 1,
  });
}

class ExceptionOverride {
  final String id;
  final String reasonAr;
  final String reasonEn;
  final ExceptionSeverity severity;
  final String approvedBy;
  final String expiry;
  const ExceptionOverride({
    required this.id, required this.reasonAr, required this.reasonEn,
    required this.severity, this.approvedBy = '', this.expiry = '',
  });
}

class RoadmapPhase {
  final int index;
  final String titleAr;
  final String titleEn;
  final RoadmapPhaseStatus status;
  const RoadmapPhase({
    required this.index, required this.titleAr, required this.titleEn,
    this.status = RoadmapPhaseStatus.notStarted,
  });
}

class GreenPass {
  final String id;
  final String holderName;
  final double score;
  final bool passed;
  const GreenPass({
    required this.id, required this.holderName,
    required this.score, required this.passed,
  });
}

class EnterpriseDailyReport {
  final String id;
  final String projectId;
  final String date;
  final String summaryAr;
  final String summaryEn;
  const EnterpriseDailyReport({
    required this.id, required this.projectId, required this.date,
    required this.summaryAr, required this.summaryEn,
  });
}
