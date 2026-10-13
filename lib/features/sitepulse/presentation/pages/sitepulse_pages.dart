// Clean Architecture: SitePulse — Presentation.
// Covers sitepulse/: SitePulseScreen, SitePulseOsViews, SitePulseMasterPlatformViews,
// SitePulseFieldQualityViews, SitePulseCommercialPlatformViews,
// SitePulseDecisionSupportScreen, CmMorningDashboardView, OrionAiSchemas.
// Tab titles resolve from JSON keys — no hardcoded text.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/sitepulse/data/repositories/sitepulse_repository.dart';
import 'package:buildhub/shared/widgets/sitepulse_add_dialog.dart';

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
        body: TabBarView(children: [
          const MorningDashboardView(),
          const SitePulseCommercialView(),
          const SitePulseFieldQualityView(),
          const SitePulseDecisionScreen(),
          const SitePulseMasterView(),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => UniversalSitePulseAddDialog(
              onSubmit: (category, values) => repo.addSnag(
                '${category.name}: ${values['sp.f_title'] ?? ''}',
                values['sp.f_zone'] ?? '',
              ),
            ),
          ),
          child: const Icon(Icons.add),
        ),
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

/// Port of SitePulseOsViews.kt: operations overview.
class SitePulseOsView extends StatelessWidget {
  const SitePulseOsView({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<SitePulseRepository>();
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(loc.t('sp.os_title'),
            style: Theme.of(context).textTheme.titleMedium),
        Text('${loc.t('sp.command')} • Tab ${repo.initialTab} • '
            '${loc.t('sp.subtab')} ${repo.initialSubTab}'),
        const MorningDashboardView(),
      ],
    );
  }
}

/// Port of SitePulseMasterPlatformViews.kt: master platform KPIs.
class SitePulseMasterView extends StatelessWidget {
  const SitePulseMasterView({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(loc.t('sp.master_title'),
            style: Theme.of(context).textTheme.titleMedium),
        Card(
            child: ListTile(
          leading: const Icon(Icons.summarize),
          title: Text(loc.t('sp.tab_reports')),
          subtitle: Text(loc.t('sp.morning_sub')),
        )),
      ],
    );
  }
}

/// Port of SitePulseFieldQualityViews.kt: snagging & QA list.
class SitePulseFieldQualityView extends StatelessWidget {
  const SitePulseFieldQualityView({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<SitePulseRepository>();
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(loc.t('sp.quality_title'),
            style: Theme.of(context).textTheme.titleMedium),
        if (repo.snags.isEmpty)
          Center(child: Text(loc.t('sp.quality_empty')))
        else
          ...repo.snags.map((s) => ListTile(
                leading: const Icon(Icons.bug_report),
                title: Text(s['title'] ?? ''),
                subtitle: Text(s['location'] ?? ''),
              )),
      ],
    );
  }
}

/// Port of SitePulseCommercialPlatformViews.kt: EV/AC/CPI/EAC analytics.
class SitePulseCommercialView extends StatelessWidget {
  const SitePulseCommercialView({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(loc.t('sp.comm_title'),
            style: Theme.of(context).textTheme.titleMedium),
        Card(
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(loc.t('sp.comm_ev_line')),
                      Text(loc.t('sp.comm_ac_line')),
                      Text(loc.t('sp.comm_cpi_line')),
                      Text(loc.t('sp.comm_eac_line')),
                    ]))),
        Card(
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(loc.t('sp.comm_variations')),
                      Text(loc.t('sp.comm_cash')),
                    ]))),
      ],
    );
  }
}

class _PetroSpec {
  final String code;
  final String titleAr;
  final String titleEn;
  const _PetroSpec(this.code, this.titleAr, this.titleEn);
}

/// Port of sitepulse/InfrastructurePetroleumSafetySpecsHubView (MainActivity tab 51):
/// searchable hub of DEWA / RTA / ADNOC / OSHA / DM / ADDC references.
class PetroleumSpecsScreen extends StatefulWidget {
  const PetroleumSpecsScreen({super.key});
  @override
  State<PetroleumSpecsScreen> createState() => _PetroleumSpecsScreenState();
}

class _PetroleumSpecsScreenState extends State<PetroleumSpecsScreen> {
  static const _specs = [
    _PetroSpec('DEWA-UTL-01',
        'مواصفات هيئة كهرباء ومياه دبي (DEWA) لشبكات الكابلات الأرضية',
        'DEWA 11kV & 33kV Underground Cable Laying & Substation Specifications'),
    _PetroSpec('RTA-GEO-02',
        'دليل هيئة الطرق والمواصلات (RTA) لتصميم ورصف الطرق والبنية التحتية',
        'RTA Geometric Design & Flexible Pavement Construction Code'),
    _PetroSpec('ADNOC-STD-03',
        'مواصفات شركة أدنوك (ADNOC) لخطوط الأنابيب والمناطق الخطرة والصناعية',
        'ADNOC Pipeline Construction, Welding & Hazardous Area Safety Standard'),
    _PetroSpec('OSHA-1926',
        'اشتراطات الحفريات وتدعيم الجوانب ومعدات الرفع الثقيلة (OSHA / UAE CoP)',
        'OSHA 1926 Subpart P & UAE Code of Practice for Trenching & Shoring'),
    _PetroSpec('DM-DRAIN-04',
        'كود بلدية دبي لتصريف مياه الأمطار وشباك الصرف الصحي ومحطات الرفع',
        'Dubai Municipality Stormwater Drainage & Foul Sewerage Technical Guidelines'),
    _PetroSpec('ADDC-MV-05',
        'لوائح دائرة الطاقة (ADDC / AADC) لتوزيع الكهرباء والمياه',
        'ADDC/AADC Electrical & Water Distribution Network Manual'),
  ];

  String _query = '';

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final q = _query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? _specs
        : _specs
            .where((s) =>
                s.code.toLowerCase().contains(q) ||
                s.titleAr.contains(_query.trim()) ||
                s.titleEn.toLowerCase().contains(q))
            .toList();
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('specs.hub_title'))),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loc.t('specs.hub_sub')),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: loc.t('specs.search_hint'),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ]),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final s = filtered[i];
              return Card(
                child: InkWell(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            '${loc.t('specs.opened')}: ${s.code}'))),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(label: Text(s.code)),
                                Chip(
                                    label:
                                        Text(loc.t('specs.verified'))),
                              ]),
                          const SizedBox(height: 4),
                          Text(loc.tr(s.titleAr, s.titleEn),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall),
                          Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(loc.t('specs.revision')),
                                TextButton.icon(
                                  onPressed: () =>
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  '${loc.t('specs.downloading')}: ${s.code}'))),
                                  icon: const Icon(Icons.download,
                                      size: 14),
                                  label:
                                      Text(loc.t('specs.download')),
                                ),
                              ]),
                        ]),
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
