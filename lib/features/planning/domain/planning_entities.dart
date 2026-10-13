// Clean Architecture: Planning feature — Domain entities + CPM engine.
// Ports: AiBaselineModels.kt + data/engine/CpmDelayEngine.kt,
// HistoricalGanttBaselineScreen + PredictiveDelayScreen models.
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

/// Deterministic CPM forward/backward pass.
/// Port of CpmDelayEngine.calculateCpm (Kotlin object) — no LLM involved.
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
    // Forward pass (topological approximation by insertion order)
    for (final a in activities) {
      final n = nodes[a.id]!;
      var es = 0;
      for (final p in n.predecessors) {
        es = max(es, nodes[p]!.earlyFinish);
      }
      n.earlyStart = es;
      n.earlyFinish = es + n.durationDays;
    }
    final projectEnd = nodes.values.fold<int>(
        0, (m, n) => max(m, n.earlyFinish));
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
    return nodes;
  }

  static List<String> criticalPath(Map<String, CpmNode> nodes) =>
      nodes.values.where((n) => n.isCritical).map((n) => n.activityId).toList();
}
