// Port of ui/screens/DashboardScreen.kt (simplified)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localization.dart';
import '../../data/repository/buildhub_repository.dart';

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
                Text('${loc.tr('الإنجاز', 'Progress')}: ${p.completionPercent}% • ${loc.tr('المتبقي', 'Remaining')}: ${p.daysRemaining} ${loc.tr('يوم', 'days')}'),
                const SizedBox(height: 8),
                Text('${loc.tr('الميزانية', 'Budget')}: ${loc.formatAed(p.budgetAed)}'),
                Text('${loc.tr('المصروف', 'Spent')}: ${loc.formatAed(p.spentAed)}'),
                Text('${loc.tr('المتبقي', 'Left')}: ${loc.formatAed(remaining)}'),
                Text('CPI ${p.cpi} • SPI ${p.spi}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(loc.tr('التنبيهات', 'Alerts'),
            style: Theme.of(context).textTheme.titleMedium),
        ...repo.alerts.where((a) => !a.isResolved).map((a) => Card(
          child: ListTile(
            title: Text(loc.tr(a.titleAr, a.titleEn)),
            subtitle: Text(loc.tr(a.detailAr, a.detailEn)),
            trailing: TextButton(
              onPressed: () => repo.resolveAlert(a.id),
              child: Text(loc.tr('حل', 'Resolve')),
            ),
          ),
        )),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton(
                onPressed: () => onNavigateToTab(1),
                child: Text(loc.tr('الخدمات', 'Services'))),
            ElevatedButton(
                onPressed: () => onNavigateToTab(9),
                child: Text(loc.tr('المساعد الذكي', 'Copilot'))),
            ElevatedButton(
                onPressed: () => onNavigateToTab(6),
                child: Text(loc.tr('السلامة', 'Safety'))),
          ],
        ),
      ],
    );
  }
}
