// Shared UI: project finance summary card.
// Ports: ProjectFinanceSummaryCard.kt — header + CPI badge + 3 KPIs +
// utilization bar + expandable 4-category cost breakdown.
// Data-only inputs (no feature imports); labels resolve from JSON.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';

class FinanceCategoryDatum {
  final String titleKey;
  final IconData icon;
  final double budgetRatio;
  final double spentRatio;
  final Color color;
  const FinanceCategoryDatum({
    required this.titleKey,
    required this.icon,
    required this.budgetRatio,
    required this.spentRatio,
    required this.color,
  });
}

const defaultFinanceCategories = [
  FinanceCategoryDatum(titleKey: 'widgets.fin_cat_structural',
      icon: Icons.foundation, budgetRatio: 0.40, spentRatio: 0.38,
      color: Colors.cyan),
  FinanceCategoryDatum(titleKey: 'widgets.fin_cat_mep',
      icon: Icons.electrical_services, budgetRatio: 0.25, spentRatio: 0.22,
      color: Colors.blue),
  FinanceCategoryDatum(titleKey: 'widgets.fin_cat_finishing',
      icon: Icons.format_paint, budgetRatio: 0.20, spentRatio: 0.16,
      color: Colors.amber),
  FinanceCategoryDatum(titleKey: 'widgets.fin_cat_supervision',
      icon: Icons.manage_accounts, budgetRatio: 0.15, spentRatio: 0.14,
      color: Colors.green),
];

/// Full finance card (reference parity). The legacy budget/spent/fmt
/// constructor is preserved for existing callers.
class FinanceSummaryCard extends StatelessWidget {
  final double budget;
  final double spent;
  final String Function(double) fmt;
  final double cpi;
  final List<FinanceCategoryDatum> categories;
  const FinanceSummaryCard({
    super.key,
    required this.budget,
    required this.spent,
    required this.fmt,
    this.cpi = 1.0,
    this.categories = defaultFinanceCategories,
  });
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final pct = budget == 0 ? 0.0 : (spent / budget).clamp(0.0, 1.0);
    final underBudget = cpi >= 1.0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Text(loc.t('widgets.fin_title'),
                    style: Theme.of(context).textTheme.titleMedium)),
            Chip(
                label: Text(loc.t(underBudget
                    ? 'widgets.fin_within'
                    : 'widgets.fin_overrun'))),
          ]),
          Text(loc.t('widgets.fin_sub'),
              style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _Kpi(
                title: loc.t('widgets.fin_budget'),
                value: fmt(budget),
                sub: loc.t('widgets.fin_contract_base'))),
            Expanded(child: _Kpi(
                title: loc.t('widgets.fin_spent'),
                value: fmt(spent),
                sub:
                    '${(pct * 100).toInt()}% ${loc.t('widgets.fin_utilized')}')),
            Expanded(child: _Kpi(
                title: loc.t('widgets.fin_remaining'),
                value: fmt(budget - spent),
                sub: loc.t('widgets.fin_escrow'))),
          ]),
          const SizedBox(height: 8),
          Text('${loc.t('widgets.fin_utilization')} '
              '(${(pct * 100).toInt()}% ${loc.t('widgets.fin_remaining')})'),
          LinearProgressIndicator(value: pct),
          const SizedBox(height: 8),
          ExpansionTile(
            title: Text(loc.t('widgets.fin_breakdown')),
            children: categories
                .map((c) => ListTile(
                      leading: Icon(c.icon, color: c.color),
                      title: Text(loc.t(c.titleKey)),
                      subtitle: Text(
                          '${loc.t('widgets.fin_alloc')}: ${(c.budgetRatio * 100).toInt()}% • '
                          '${(c.spentRatio * 100).toInt()}% ${loc.t('widgets.fin_spent')}'),
                      trailing: Text('${(c.spentRatio * 100).toInt()}%'),
                    ))
                .toList(),
          ),
        ]),
      ),
    );
  }
}

class _Kpi extends StatelessWidget {
  final String title;
  final String value;
  final String sub;
  const _Kpi({required this.title, required this.value, required this.sub});
  @override
  Widget build(BuildContext context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.labelSmall),
            Text(value, style: Theme.of(context).textTheme.titleMedium),
            Text(sub, style: Theme.of(context).textTheme.labelSmall),
          ]);
}
