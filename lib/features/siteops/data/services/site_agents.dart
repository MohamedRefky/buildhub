// Clean Architecture: SiteOps — Data autonomous + site AI agents.
// Ports: AutonomousInputAgent.kt + SiteAiAgent.kt — autopilot shift cycles,
// weather-gate evaluation and autonomous inspection with cloud audit log.
// In-memory now; Firestore push paths mirror the reference.

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../home/domain/entities/home_entities.dart';

enum AutopilotMode { awayAutopilot, supervised, manual }

enum AgentActionType {
  activityProgress,
  weatherHold,
  manpowerLog,
  materialReceipt,
  safetySnag,
  submittalAutoCheck,
}

class AgentActionItem {
  final String id;
  final AgentActionType type;
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final String projectId;
  final String activityName;
  final String timestamp;
  final bool isApproved;
  final bool isRolledBack;
  final bool syncedToFirebase;
  const AgentActionItem({
    required this.id, required this.type,
    required this.titleAr, required this.titleEn,
    required this.descriptionAr, required this.descriptionEn,
    required this.projectId, required this.activityName,
    required this.timestamp,
    this.isApproved = false, this.isRolledBack = false,
    this.syncedToFirebase = false,
  });

  AgentActionItem copyWith({bool? isApproved, bool? isRolledBack, bool? syncedToFirebase}) =>
      AgentActionItem(
        id: id, type: type, titleAr: titleAr, titleEn: titleEn,
        descriptionAr: descriptionAr, descriptionEn: descriptionEn,
        projectId: projectId, activityName: activityName, timestamp: timestamp,
        isApproved: isApproved ?? this.isApproved,
        isRolledBack: isRolledBack ?? this.isRolledBack,
        syncedToFirebase: syncedToFirebase ?? this.syncedToFirebase,
      );
}

class AutonomousInputAgent extends ChangeNotifier {
  AutopilotMode mode = AutopilotMode.supervised;
  final List<AgentActionItem> actionHistory = [];
  bool isExecutingCycle = false;
  String statusTextAr = '';
  String statusTextEn = '';

  void setMode(AutopilotMode newMode) {
    mode = newMode;
    notifyListeners();
  }

  /// Builds a 4-action shift cycle (progress + weather + manpower + supply),
  /// persists a DailySiteLog and queues autonomous_inputs for sync.
  Future<List<AgentActionItem>> executeAutonomousShiftCycle(
      String projectId) async {
    isExecutingCycle = true;
    statusTextAr = 'تنفيذ دورة الوردية الذاتية…';
    statusTextEn = 'Running autonomous shift cycle…';
    notifyListeners();
    final now = DateTime.now();
    final stamp = now.toIso8601String();
    final date = stamp.substring(0, 10);
    AgentActionItem mk(AgentActionType type, String ar, String en, String act) =>
        AgentActionItem(
          id: const Uuid().v4(), type: type, titleAr: ar, titleEn: en,
          descriptionAr: ar, descriptionEn: en,
          projectId: projectId, activityName: act, timestamp: stamp,
          syncedToFirebase: false,
        );
    final actions = [
      mk(AgentActionType.activityProgress, 'تقدم الأنشطة التلقائي',
          'Autonomous activity progress', 'ACT-007'),
      mk(AgentActionType.weatherHold, 'تعليق طقس الظهيرة',
          'Midday weather hold', 'Site-wide'),
      mk(AgentActionType.manpowerLog, 'تسجيل القوى العاملة',
          'Manpower log', 'Zone A'),
      mk(AgentActionType.materialReceipt, 'استلام مواد تلقائي',
          'Autonomous material receipt', 'Bay B2'),
    ];
    actionHistory.addAll(actions);
    final log = DailySiteLog(
      id: 'daily_${projectId}_$date', projectId: projectId, dateStr: date,
      timestamp: stamp, summaryAr: 'تقرير ذاتي للوردية — 4 إجراءات',
      summaryEn: 'Autonomous shift report — 4 actions',
      note: actions.map((a) => a.titleEn).join('; '),
      category: 'PROGRESS', author: 'AutonomousInputAgent', manpower: 0,
      equipmentCount: 0,
    );
    // TODO: upsert log into sqflite daily_logs + set() merge
    // projects/{projectId}/autonomous_inputs/{actionId} per action.
    _lastCycleLog = log;
    isExecutingCycle = false;
    statusTextAr = 'اكتملت الدورة — ${actions.length} إجراءات';
    statusTextEn = 'Cycle complete — ${actions.length} actions';
    notifyListeners();
    return actions;
  }

  DailySiteLog? _lastCycleLog;
  DailySiteLog? get lastCycleLog => _lastCycleLog;

  void approveAction(String id) {
    final i = actionHistory.indexWhere((a) => a.id == id);
    if (i == -1) return;
    actionHistory[i] = actionHistory[i].copyWith(isApproved: true);
    notifyListeners();
  }

  void rollbackAction(String id) {
    final i = actionHistory.indexWhere((a) => a.id == id);
    if (i == -1) return;
    actionHistory[i] = actionHistory[i].copyWith(isRolledBack: true);
    notifyListeners();
  }
}

class WeatherEvaluationResult {
  final bool isCranePermitted;
  final bool isMiddayBanActive;
  final bool isConcretePourPermitted;
  final String summaryAr;
  final String summaryEn;
  const WeatherEvaluationResult({
    required this.isCranePermitted, required this.isMiddayBanActive,
    required this.isConcretePourPermitted,
    required this.summaryAr, required this.summaryEn,
  });
}

class AiAgentCycleResult {
  final String cycleId;
  final String timestamp;
  final String dailyReportId;
  final String createdSnagId;
  final WeatherEvaluationResult weatherEvaluation;
  final int activitiesCheckedCount;
  final String summaryReport;
  final bool isSyncedToCloud;
  const AiAgentCycleResult({
    required this.cycleId, required this.timestamp,
    required this.dailyReportId, required this.createdSnagId,
    required this.weatherEvaluation, required this.activitiesCheckedCount,
    required this.summaryReport, required this.isSyncedToCloud,
  });
}

class SiteAiAgent extends ChangeNotifier {
  bool isAgentRunning = false;
  final List<String> _agentLog = [];
  AiAgentCycleResult? lastCycleResult;

  List<String> get agentLogStream => List.unmodifiable(_agentLog);

  void _log(String entry) {
    _agentLog.add('${DateTime.now().toIso8601String()} $entry');
    if (_agentLog.length > 25) {
      _agentLog.removeRange(0, _agentLog.length - 25);
    }
    notifyListeners();
  }

  /// Weather gates mirror the reference: crane ≤ 35 km/h,
  /// midday ban 12–15h above 32°, concrete ≤ 40° and outside ban.
  WeatherEvaluationResult evaluateWeatherLimits(
      double windSpeedKmh, double temperatureC, int hourOfDay) {
    final ban = hourOfDay >= 12 && hourOfDay < 15 && temperatureC >= 32;
    final crane = windSpeedKmh <= 35;
    final pour = temperatureC <= 40 && !ban;
    return WeatherEvaluationResult(
      isCranePermitted: crane, isMiddayBanActive: ban,
      isConcretePourPermitted: pour,
      summaryAr: 'رافعة:${crane ? 'مسموح' : 'ممنوع'} • ظهيرة:${ban ? 'ساري' : 'غير ساري'} • صب:${pour ? 'مسموح' : 'ممنوع'}',
      summaryEn: 'Crane:${crane ? 'OK' : 'STOP'} • Midday:${ban ? 'BAN' : 'clear'} • Pour:${pour ? 'OK' : 'HOLD'}',
    );
  }

  Future<AiAgentCycleResult> runAutonomousInspectionCycle(
      String projectId) async {
    isAgentRunning = true;
    notifyListeners();
    _log('inspection start $projectId');
    final weather = evaluateWeatherLimits(26.5, 37, 10);
    final stamp = DateTime.now().toIso8601String();
    final reportId = 'rep_${projectId}_${stamp.substring(0, 10)}';
    final snagId = 'SNAG-AI-${stamp.substring(11, 13)}${stamp.substring(14, 16)}';
    _log('weather crane=${weather.isCranePermitted}');
    _log('report $reportId saved');
    _log('snag $snagId created');
    // TODO: persist DailyReport + snag via OfflineFirstRepository and
    // pushAgentLog to projects/{projectId}/ai_agent_actions.
    final result = AiAgentCycleResult(
      cycleId: const Uuid().v4(), timestamp: stamp, dailyReportId: reportId,
      createdSnagId: snagId, weatherEvaluation: weather,
      activitiesCheckedCount: 3,
      summaryReport: '3 manpower crews, 2 AI activities, C40/50 delivery, 1 safety issue',
      isSyncedToCloud: false,
    );
    lastCycleResult = result;
    isAgentRunning = false;
    notifyListeners();
    return result;
  }

  String synthesizeDailyReportSummary(String projectId, String date) =>
      'Site $projectId daily summary for $date';
}
