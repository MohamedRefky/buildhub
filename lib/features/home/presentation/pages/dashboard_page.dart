// Port of ui/screens/DashboardScreen.kt (simplified)
// Static labels via loc.t() (JSON); entity data via loc.tr() (DB-driven).
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localization.dart';
import '../../data/repositories/buildhub_repository.dart';

class DashboardScreen extends StatelessWidget {
  final void Function(int tab) onNavigateToTab;
  const DashboardScreen({super.key, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<BuildHubRepository>();
    final p = repo.currentProject;
    final remaining = p.budgetAed - p.spentAed;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loc.tr(p.nameAr, p.nameEn),
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text('${p.code} • ${loc.tr(p.locationAr, p.locationEn)}'),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: p.completionPercent / 100),
                const SizedBox(height: 8),
                Text('${loc.t('dash.progress')}: ${p.completionPercent}% • ${loc.t('dash.remaining')}: ${p.daysRemaining} ${loc.t('dash.days')}'),
                const SizedBox(height: 8),
                Text('${loc.t('dash.budget')}: ${loc.formatAed(p.budgetAed)}'),
                Text('${loc.t('dash.spent')}: ${loc.formatAed(p.spentAed)}'),
                Text('${loc.t('dash.left')}: ${loc.formatAed(remaining)}'),
                Text('CPI ${p.cpi} • SPI ${p.spi}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(loc.t('dash.alerts'),
            style: Theme.of(context).textTheme.titleMedium),
        ...repo.alerts.where((a) => !a.isResolved).map((a) => Card(
          child: ListTile(
            title: Text(loc.tr(a.titleAr, a.titleEn)),
            subtitle: Text(loc.tr(a.detailAr, a.detailEn)),
            trailing: TextButton(
              onPressed: () => repo.resolveAlert(a.id),
              child: Text(loc.t('common.resolve')),
            ),
          ),
        )),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton(
                onPressed: () => onNavigateToTab(1),
                child: Text(loc.t('dash.services'))),
            ElevatedButton(
                onPressed: () => onNavigateToTab(9),
                child: Text(loc.t('dash.copilot'))),
            ElevatedButton(
                onPressed: () => onNavigateToTab(6),
                child: Text(loc.t('dash.safety'))),
          ],
        ),
      ],
    );
  }
}
