// Clean Architecture: SitePulse — Presentation.
// Covers sitepulse/: SitePulseScreen, SitePulseOsViews, SitePulseMasterPlatformViews,
// SitePulseFieldQualityViews, SitePulseCommercialPlatformViews,
// SitePulseDecisionSupportScreen, CmMorningDashboardView, OrionAiSchemas.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/sitepulse/data/sitepulse_repository.dart';

class SitePulseScreen extends StatelessWidget {
  const SitePulseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<SitePulseRepository>();
    final tabs = [
      loc.tr('القيادة الصباحية', 'Morning Command'),
      loc.tr('التجارية', 'Commercial'),
      loc.tr('الموقع والجودة', 'Site & Quality'),
      loc.tr('القرارات', 'Decisions'),
      loc.tr('التقارير AI', 'AI Reports'),
    ];
    return DefaultTabController(
      length: tabs.length,
      initialIndex: repo.initialTab.clamp(0, tabs.length - 1).toInt(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.tr('مركز قيادة الموقع', 'SitePulse Command')),
          bottom: TabBar(isScrollable: true,
            tabs: tabs.map((t) => Tab(text: t)).toList()),
        ),
        body: TabBarView(children: tabs.map((t) =>
          Center(child: Text('$t • subTab ${repo.initialSubTab}'))).toList()),
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
      appBar: AppBar(title: Text(loc.tr('دعم القرار', 'Decision Support'))),
      body: const Center(child: Text('SitePulseDecisionModels')),
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
        title: Text(loc.tr('لوحة الصباح', 'Morning Dashboard')),
        subtitle: Text(loc.tr('ملخص CM اليومي', 'Daily CM summary')),
      ),
    );
  }
}
