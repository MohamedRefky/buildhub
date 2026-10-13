// Clean Architecture: Finance feature — Domain entities.
// Ports: Models.kt (FidicClaim), EnterpriseMasterArchitectureModels (finance parts),
// ConstructionSpecification (cost refs).
enum ClaimStatus { draft, notified, underReview, awarded, rejected }

class FinanceClaimEntity {
  final String id;
  final String noticeNo;
  final String subClause;
  final String titleAr;
  final String titleEn;
  final int daysRemainingNotice;
  final double exposureAed;
  final ClaimStatus status;
  const FinanceClaimEntity({
    required this.id, required this.noticeNo, required this.subClause,
    required this.titleAr, required this.titleEn,
    required this.daysRemainingNotice, required this.exposureAed,
    this.status = ClaimStatus.notified,
  });
}

class CostToCompleteEntity {
  final String projectId;
  final double budgetAed;
  final double spentAed;
  final double forecastAed;
  final double varianceAed;
  const CostToCompleteEntity({
    required this.projectId, required this.budgetAed,
    required this.spentAed, required this.forecastAed,
    required this.varianceAed,
  });
}

class PettyCashWalletEntity {
  final String id;
  final String holderName;
  final double balanceAed;
  final double monthlyLimitAed;
  const PettyCashWalletEntity({
    required this.id, required this.holderName,
    required this.balanceAed, required this.monthlyLimitAed,
  });
}

class BusinessPlanEntity {
  final String projectId;
  final double irrPercent;
  final double npvAed;
  final int paybackMonths;
  const BusinessPlanEntity({
    required this.projectId, required this.irrPercent,
    required this.npvAed, required this.paybackMonths,
  });
}

class ExecutiveAnalyticsSummary {
  final double plannedValueAed;
  final double earnedValueAed;
  final double actualCostAed;
  final double spi;
  final double cpi;
  final String safetyLeadingIndicators;
  const ExecutiveAnalyticsSummary({
    required this.plannedValueAed, required this.earnedValueAed,
    required this.actualCostAed, required this.spi, required this.cpi,
    this.safetyLeadingIndicators = '',
  });
}
