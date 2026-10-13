// Clean Architecture: SiteOps — Presentation.
// Covers: GeoAttendanceScreen, DailyReportAgentScreen, ActivityDataEntryScreen,
// SmartOfflineSyncScreen, WeatherBrainScreen, WorkerWelfareScreen,
// EsgSustainabilityScreen, GreenWalletAndEnergyCertificatesScreen,
// OrionGreenPassScreen, OrionRoadmapScreen, RiskHeatMapScreen,
// MarketIntelligenceScreen, PredictiveDelayScreen,
// HistoricalGanttBaselineScreen, AiBaselineSuiteScreen,
// ApprovalEngineScreen, ExceptionOverrideScreen,
// AutonomousAgentControlScreen, SmartOfflineSync, FirebaseCloudSync.
// Titles/bodies resolve from JSON keys — no hardcoded text.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/siteops/domain/entities/siteops_entities.dart';
import 'package:buildhub/features/planning/domain/entities/planning_entities.dart';

class _Op extends StatelessWidget {
  final String titleKey;
  final Widget? child;
  const _Op({required this.titleKey, this.child});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.t(titleKey))),
      body: child ?? Center(child: Text(loc.t('common.migrate_note'))),
    );
  }
}

class GeoAttendanceFullScreen extends StatelessWidget {
  const GeoAttendanceFullScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return _Op(
      titleKey: 'ops.geo',
      child: Center(child: Text(loc.t('ops.geo_body'))),
    );
  }
}

class DailyReportFullScreen extends StatelessWidget {
  const DailyReportFullScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(titleKey: 'ops.daily');
}

class ActivityEntryScreen extends StatelessWidget {
  const ActivityEntryScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(titleKey: 'ops.activity');
}

class OfflineSyncScreen extends StatelessWidget {
  const OfflineSyncScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return _Op(
      titleKey: 'ops.offline',
      child: Center(child: Text(loc.t('ops.offline_body'))),
    );
  }
}

class WeatherFullScreen extends StatelessWidget {
  const WeatherFullScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const w = WeatherSnapshot(tempC: 42, humidity: 68, windMs: 8.5);
    return _Op(titleKey: 'ops.weather',
      child: Center(child: Text('${w.tempC}°C • ${w.humidity}% • ${w.windMs} m/s')));
  }
}

class WelfareScreen extends StatelessWidget {
  const WelfareScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(titleKey: 'ops.welfare');
}

class EsgScreen extends StatelessWidget {
  const EsgScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(titleKey: 'ops.esg');
}

class GreenWalletScreen extends StatelessWidget {
  const GreenWalletScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(titleKey: 'ops.green_wallet');
}

class GreenPassScreen extends StatelessWidget {
  const GreenPassScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return _Op(
      titleKey: 'ops.green_pass',
      child: Center(child: Text(loc.t('ops.green_pass_body'))),
    );
  }
}

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return _Op(
      titleKey: 'ops.roadmap',
      child: Center(child: Text(loc.t('ops.roadmap_body'))),
    );
  }
}

class RiskHeatMapFullScreen extends StatelessWidget {
  final List<RiskItem> risks;
  const RiskHeatMapFullScreen({super.key, this.risks = const []});
  @override
  Widget build(BuildContext context) =>
      const _Op(titleKey: 'ops.risk');
}

class MarketIntelScreen extends StatelessWidget {
  const MarketIntelScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(titleKey: 'ops.intel');
}

class PredictiveDelayFullScreen extends StatelessWidget {
  const PredictiveDelayFullScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final count = CpmEngine.calculate(const []).length;
    return _Op(
      titleKey: 'ops.delay',
      child: Center(
          child: Text(
              loc.t('ops.delay_body').replaceFirst('{n}', '$count'))),
    );
  }
}

class GanttBaselineScreen extends StatelessWidget {
  const GanttBaselineScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return _Op(
      titleKey: 'ops.gantt',
      child: Center(child: Text(loc.t('ops.gantt_body'))),
    );
  }
}

class BaselineSuiteScreen extends StatelessWidget {
  const BaselineSuiteScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(titleKey: 'ops.baseline');
}

class ApprovalEngineFullScreen extends StatelessWidget {
  const ApprovalEngineFullScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(titleKey: 'ops.approval');
}

class ExceptionOverrideFullScreen extends StatelessWidget {
  const ExceptionOverrideFullScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Op(titleKey: 'ops.override');
}

class AutonomousAgentScreen extends StatelessWidget {
  const AutonomousAgentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return _Op(
      titleKey: 'ops.agent',
      child: Center(child: Text(loc.t('ops.agent_body'))),
    );
  }
}
