// Clean Architecture: SiteOps — Presentation.
// Covers: GeoAttendanceScreen, DailyReportAgentScreen, ActivityDataEntryScreen,
// SmartOfflineSyncScreen, WeatherBrainScreen, WorkerWelfareScreen,
// EsgSustainabilityScreen, GreenWalletAndEnergyCertificatesScreen,
// OrionGreenPassScreen, OrionRoadmapScreen, RiskHeatMapScreen,
// MarketIntelligenceScreen, PredictiveDelayScreen,
// HistoricalGanttBaselineScreen, AiBaselineSuiteScreen,
// ApprovalEngineScreen, ExceptionOverrideScreen,
// AutonomousAgentControlScreen, SmartOfflineSync, FirebaseCloudSync.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/siteops/domain/entities/siteops_entities.dart';
import 'package:buildhub/features/planning/domain/planning_entities.dart';

class _Op extends StatelessWidget {
  final String ar; final String en; final Widget? child;
  const _Op({required this.ar, required this.en, this.child});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.tr(ar, en))),
      body: child ?? Center(child: Text(loc.tr(
        'يُنقل من النسخة Kotlin تدريجياً', 'Migrate incrementally from Kotlin'))),
    );
  }
}

class GeoAttendanceFullScreen extends StatelessWidget {
  const GeoAttendanceFullScreen({super.key});
  @override
  Widget build(BuildContext context) => _Op(
    ar: 'الحضور الجغرافي', en: 'Geo Attendance',
    child: const Center(child: Text('geolocator • geofence check')),
  );
}

class DailyReportFullScreen extends StatelessWidget {
  const DailyReportFullScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(ar: 'التقرير اليومي الذكي', en: 'Daily Report Agent');
}

class ActivityEntryScreen extends StatelessWidget {
  const ActivityEntryScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(ar: 'إدخال الأنشطة', en: 'Activity Entry');
}

class OfflineSyncScreen extends StatelessWidget {
  const OfflineSyncScreen({super.key});
  @override
  Widget build(BuildContext context) => const _Op(
    ar: 'المزامنة دون اتصال', en: 'Offline Sync',
    child: Center(child: Text('OfflineSyncManager • SyncWorker • sqflite queue')),
  );
}

class WeatherFullScreen extends StatelessWidget {
  const WeatherFullScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const w = WeatherSnapshot(tempC: 42, humidity: 68, windMs: 8.5);
    return _Op(ar: 'عقل الطقس', en: 'Weather Brain',
      child: Center(child: Text('${w.tempC}°C • ${w.humidity}% • ${w.windMs} m/s')));
  }
}

class WelfareScreen extends StatelessWidget {
  const WelfareScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(ar: 'رعاية العمال', en: 'Worker Welfare');
}

class EsgScreen extends StatelessWidget {
  const EsgScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(ar: 'الاستدامة ESG', en: 'ESG Sustainability');
}

class GreenWalletScreen extends StatelessWidget {
  const GreenWalletScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(ar: 'المحفظة الخضراء وشهادات الطاقة', en: 'Green Wallet');
}

class GreenPassScreen extends StatelessWidget {
  const GreenPassScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(ar: 'التصريح الأخضر', en: 'Green Pass',
        child: Center(child: Text('OrionGreenPassRepository')));
}

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(ar: 'خارطة الطريق ١٤ مرحلة', en: 'Roadmap 14 Phases',
        child: Center(child: Text('OrionRoadmapRepository • 14 gated phases')));
}

class RiskHeatMapFullScreen extends StatelessWidget {
  final List<RiskItem> risks;
  const RiskHeatMapFullScreen({super.key, this.risks = const []});
  @override
  Widget build(BuildContext context) =>
      const _Op(ar: 'خريطة المخاطر', en: 'Risk Heat Map');
}

class MarketIntelScreen extends StatelessWidget {
  const MarketIntelScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(ar: 'ذكاء السوق', en: 'Market Intelligence');
}

class PredictiveDelayFullScreen extends StatelessWidget {
  const PredictiveDelayFullScreen({super.key});
  @override
  Widget build(BuildContext context) => _Op(
    ar: 'توقع التأخير CPM', en: 'Predictive Delay',
    child: Center(child: Text(
      'CpmEngine: ${CpmEngine.calculate(const []).length} nodes • deterministic, never LLM')),
  );
}

class GanttBaselineScreen extends StatelessWidget {
  const GanttBaselineScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(ar: 'البيزلاين والجانت', en: 'Gantt Baseline',
        child: Center(child: Text('AiBaselineGeneratorService + WBS')));
}

class BaselineSuiteScreen extends StatelessWidget {
  const BaselineSuiteScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(ar: 'حزمة البيزلاين', en: 'Baseline Suite');
}

class ApprovalEngineFullScreen extends StatelessWidget {
  const ApprovalEngineFullScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(ar: 'محرك الاعتمادات', en: 'Approval Engine');
}

class ExceptionOverrideFullScreen extends StatelessWidget {
  const ExceptionOverrideFullScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(ar: 'التجاوزات الاستثنائية', en: 'Exception Override');
}

class AutonomousAgentScreen extends StatelessWidget {
  const AutonomousAgentScreen({super.key});
  @override
  Widget build(BuildContext context) => const _Op(
    ar: 'الوكيل المستقل', en: 'Autonomous Agent',
    child: Center(child: Text('AutonomousInputAgent • SiteAiAgent')),
  );
}
