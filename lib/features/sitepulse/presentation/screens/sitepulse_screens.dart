// Clean Architecture: SitePulse — Presentation.
// Covers sitepulse/: SitePulseScreen, SitePulseOsViews, SitePulseMasterPlatformViews,
// SitePulseFieldQualityViews, SitePulseCommercialPlatformViews,
// SitePulseDecisionSupportScreen, CmMorningDashboardView, OrionAiSchemas.
// Tab titles resolve from JSON keys — no hardcoded text.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/sitepulse/data/sitepulse_repository.dart';

class SitePulseScreen extends StatelessWidget {
  const SitePulseScreen({super.key});

  static const tabKeys = [
    'sp.tab_morning',
    'sp.tab_commercial',
    'sp.tab_quality',
    'sp.tab_decisions',
    'sp.tab_reports',
  ];

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<SitePulseRepository>();
    final tabs = tabKeys.map(loc.t).toList();
    return DefaultTabController(
      length: tabs.length,
      initialIndex: repo.initialTab.clamp(0, tabs.length - 1).toInt(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.t('sp.command')),
          bottom: TabBar(isScrollable: true,
            tabs: tabs.map((t) => Tab(text: t)).toList()),
        ),
        body: TabBarView(children: tabs.map((t) =>
          Center(child: Text('$t • ${loc.t('sp.subtab')} ${repo.initialSubTab}'))).toList()),
      ),
    );
  }
}

class SitePulseDecisionScreen extends StatelessWidget {
  const SitePulseDecisionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('sp.decision'))),
      body: Center(child: Text(loc.t('sp.decision_body'))),
    );
  }
}

class MorningDashboardView extends StatelessWidget {
  const MorningDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Card(
      child: ListTile(
        leading: const Icon(Icons.wb_sunny),
        title: Text(loc.t('sp.morning')),
        subtitle: Text(loc.t('sp.morning_sub')),
      ),
    );
  }
}
