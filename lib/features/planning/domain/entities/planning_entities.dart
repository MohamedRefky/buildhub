// Clean Architecture: Planning feature — Domain entities + CPM engine.
// Ports: AiBaselineModels.kt + data/engine/CpmDelayEngine.kt,
// HistoricalGanttBaselineScreen + PredictiveDelayScreen models,
// AiBaselineRepository lifecycle models.
// Deterministic forward/backward pass — never LLM-generated.
import 'dart:math' show max;

enum ActivityDiscipline { general, civil, structural, mep, finishing, testing }
enum DependencyType { fs, ss, ff, sf }
enum BaselineStatus { draftAi, underReview, approvedLocked, revision }

class BaselineActivity {
  final String id;
  final String wbsCode;
  final String nameAr;
  final String nameEn;
  final ActivityDiscipline discipline;
  final String predecessorId;
  final DependencyType dependencyType;
  final int durationDays;
  final String plannedStart;
  final String plannedFinish;
  final double budgetAed;
  final int actualProgressPercent;
  final String actualFinish;
  final String forecastFinish;
  const BaselineActivity({
    required this.id, required this.wbsCode,
    required this.nameAr, required this.nameEn,
    required this.discipline, this.predecessorId = '',
    this.dependencyType = DependencyType.fs,
    required this.durationDays, required this.plannedStart,
    required this.plannedFinish, this.budgetAed = 0,
    this.actualProgressPercent = 0, this.actualFinish = '',
    this.forecastFinish = '',
  });
}

class CpmNode {
  final String activityId;
  final int durationDays;
  int earlyStart = 0;
  int earlyFinish = 0;
  int lateStart = 0;
  int lateFinish = 0;
  int totalFloat = 0;
  int freeFloat = 0;
  bool isCritical = false;
  final List<String> predecessors = [];
  final List<String> successors = [];
  CpmNode(this.activityId, this.durationDays);
}

class DelayAnalysis {
  final String activityId;
  final int varianceDays;
  final int completionImpactDays;
  final bool isCritical;
  const DelayAnalysis({
    required this.activityId, required this.varianceDays,
    required this.completionImpactDays, required this.isCritical,
  });
}

class DelayAnalysisResult {
  final String activityId;
  final String activityName;
  final int plannedDurationDays;
  final String plannedFinish;
  final String actualOrForecastFinish;
  final int varianceDays;
  final int totalFloatDays;
  final int projectCompletionImpactDays;
  final bool isCriticalPath;
  final bool newCriticalPathCreated;
  final String statusSummary;
  const DelayAnalysisResult({
    required this.activityId, required this.activityName,
    required this.plannedDurationDays, required this.plannedFinish,
    required this.actualOrForecastFinish, required this.varianceDays,
    required this.totalFloatDays, required this.projectCompletionImpactDays,
    required this.isCriticalPath, required this.newCriticalPathCreated,
    required this.statusSummary,
  });
}

class ProjectScheduleAudit {
  final int totalActivities;
  final int criticalActivitiesCount;
  final int originalDurationDays;
  final int currentForecastDurationDays;
  final int overallProjectDelayDays;
  final List<String> criticalPathSequence;
  final List<DelayAnalysisResult> activityAnalyses;
  const ProjectScheduleAudit({
    required this.totalActivities, required this.criticalActivitiesCount,
    required this.originalDurationDays, required this.currentForecastDurationDays,
    required this.overallProjectDelayDays, required this.criticalPathSequence,
    required this.activityAnalyses,
  });
}

class CpmActivityDelayResult {
  final int criticalPathImpactDays;
  final bool isCriticalPath;
  final bool completionDateShifted;
  final int remainingTotalFloatDays;
  const CpmActivityDelayResult({
    required this.criticalPathImpactDays, required this.isCriticalPath,
    required this.completionDateShifted, required this.remainingTotalFloatDays,
  });
}

class BaselineGenerationInput {
  final String projectName;
  final String scopeOfWork;
  final String plannedStartDate;
  final String requiredCompletionDate;
  const BaselineGenerationInput({
    required this.projectName, required this.scopeOfWork,
    required this.plannedStartDate, required this.requiredCompletionDate,
  });
}

class BaselineRevisionRecord {
  final String revId;
  final String whatChangedAr;
  final String whatChangedEn;
  final String reason;
  final String requestedBy;
  final String approvedBy;
  final int timeImpactDays;
  final double costImpactAed;
  const BaselineRevisionRecord({
    required this.revId, required this.whatChangedAr,
    required this.whatChangedEn, required this.reason,
    required this.requestedBy, required this.approvedBy,
    this.timeImpactDays = 0, this.costImpactAed = 0,
  });
}

class AiProjectMonitoringInsight {
  final int healthScore;
  final String topRiskAr;
  final String topRiskEn;
  const AiProjectMonitoringInsight({
    required this.healthScore,
    required this.topRiskAr, required this.topRiskEn,
  });
}

class ThreeWeekLookAheadTask {
  final String taskId;
  final String activityNameAr;
  final String activityNameEn;
  final String subcontractor;
  final String plannedWeek;
  final String commitmentStatus;
  const ThreeWeekLookAheadTask({
    required this.taskId, required this.activityNameAr,
    required this.activityNameEn, required this.subcontractor,
    required this.plannedWeek, this.commitmentStatus = 'COMMITTED',
  });
}

/// Deterministic CPM forward/backward pass.
/// Port of CpmDelayEngine (Kotlin object) — no LLM involved.
class CpmEngine {
  static Map<String, CpmNode> calculate(List<BaselineActivity> activities) {
    final nodes = <String, CpmNode>{};
    for (final a in activities) {
      nodes[a.id] = CpmNode(a.id, max(1, a.durationDays));
    }
    for (final a in activities) {
      if (a.predecessorId.isNotEmpty && nodes.containsKey(a.predecessorId)) {
        nodes[a.id]!.predecessors.add(a.predecessorId);
        nodes[a.predecessorId]!.successors.add(a.id);
      }
    }
    // Forward pass — iterate to convergence like the reference
    // (maxIterations = size * 2 + 10).
    final maxIterations = nodes.length * 2 + 10;
    for (var iter = 0; iter < maxIterations; iter++) {
      var changed = false;
      for (final a in activities) {
        final n = nodes[a.id]!;
        var es = 0;
        for (final p in n.predecessors) {
          es = max(es, nodes[p]!.earlyFinish);
        }
        final ef = es + n.durationDays;
        if (n.earlyStart != es || n.earlyFinish != ef) {
          n.earlyStart = es;
          n.earlyFinish = ef;
          changed = true;
        }
      }
      if (!changed) break;
    }
    final projectEnd = nodes.values.fold<int>(
        0, (m, n) => m > n.earlyFinish ? m : n.earlyFinish);
    // Backward pass
    for (final a in activities.reversed) {
      final n = nodes[a.id]!;
      if (n.successors.isEmpty) {
        n.lateFinish = projectEnd;
      } else {
        var lf = projectEnd;
        for (final s in n.successors) {
          lf = lf < nodes[s]!.lateStart ? lf : nodes[s]!.lateStart;
        }
        n.lateFinish = lf;
      }
      n.lateStart = n.lateFinish - n.durationDays;
      n.totalFloat = n.lateStart - n.earlyStart;
      n.isCritical = n.totalFloat <= 0;
    }
    // Free float = min(earlyStart of successors) - earlyFinish.
    for (final n in nodes.values) {
      if (n.successors.isEmpty) {
        n.freeFloat = n.totalFloat;
      } else {
        var minEs = projectEnd;
        for (final s in n.successors) {
          minEs = minEs < nodes[s]!.earlyStart ? minEs : nodes[s]!.earlyStart;
        }
        n.freeFloat = minEs - n.earlyFinish;
      }
    }
    return nodes;
  }

  static List<String> criticalPath(Map<String, CpmNode> nodes) =>
      nodes.values.where((n) => n.isCritical).map((n) => n.activityId).toList();

  /// Impact rule (mirrors reference): if variance > totalFloat then
  /// impact = variance - max(0, float), else 0.
  static CpmActivityDelayResult calculateActivityDelay(
    BaselineActivity activity,
    int actualDelayDays,
    int totalFloatDays,
  ) {
    final int safeFloat = totalFloatDays > 0 ? totalFloatDays : 0;
    final int remainingRaw = totalFloatDays - actualDelayDays;
    final int remaining = remainingRaw > 0 ? remainingRaw : 0;
    final int impact = actualDelayDays > totalFloatDays
        ? actualDelayDays - safeFloat
        : 0;
    return CpmActivityDelayResult(
      criticalPathImpactDays: impact,
      isCriticalPath: impact > 0,
      completionDateShifted: impact > 0,
      remainingTotalFloatDays: remaining,
    );
  }

  static int _daysBetween(String from, String to) {
    final f = DateTime.tryParse(from);
    final t = DateTime.tryParse(to);
    if (f == null || t == null) return 0;
    return t.difference(f).inDays;
  }

  static ProjectScheduleAudit analyzeScheduleDelays(
      List<BaselineActivity> activities) {
    final nodes = calculate(activities);
    final analyses = <DelayAnalysisResult>[];
    for (final a in activities) {
      final n = nodes[a.id]!;
      final effectiveFinish = a.actualFinish.isNotEmpty
          ? a.actualFinish
          : (a.forecastFinish.isNotEmpty ? a.forecastFinish : a.plannedFinish);
      final variance = _daysBetween(a.plannedFinish, effectiveFinish);
      final wasCritical = n.isCritical;
      final int safeNodeFloat = n.totalFloat > 0 ? n.totalFloat : 0;
      final int impact = variance > n.totalFloat
          ? variance - safeNodeFloat
          : 0;
      final becameCritical = !wasCritical && impact > 0 && variance > n.totalFloat;
      final String summary;
      if (variance <= 0) {
        summary = 'ON_TRACK';
      } else if (impact == 0) {
        summary = 'DELAY_ABSORBED_BY_FLOAT';
      } else if (becameCritical) {
        summary = 'CRITICAL_PATH_BREACH';
      } else {
        summary = 'CRITICAL_PATH_SLIP';
      }
      analyses.add(DelayAnalysisResult(
        activityId: a.id, activityName: a.nameEn,
        plannedDurationDays: a.durationDays, plannedFinish: a.plannedFinish,
        actualOrForecastFinish: effectiveFinish, varianceDays: variance,
        totalFloatDays: n.totalFloat, projectCompletionImpactDays: impact,
        isCriticalPath: wasCritical || becameCritical,
        newCriticalPathCreated: becameCritical, statusSummary: summary,
      ));
    }
    final overall = analyses.fold<int>(
        0, (m, r) => m > r.projectCompletionImpactDays ? m : r.projectCompletionImpactDays);
    final original = nodes.values.fold<int>(
        0, (m, n) => m > n.earlyFinish ? m : n.earlyFinish);
    return ProjectScheduleAudit(
      totalActivities: activities.length,
      criticalActivitiesCount:
          analyses.where((r) => r.isCriticalPath).length,
      originalDurationDays: original,
      currentForecastDurationDays: original + overall,
      overallProjectDelayDays: overall,
      criticalPathSequence: criticalPath(nodes),
      activityAnalyses: analyses,
    );
  }
}
