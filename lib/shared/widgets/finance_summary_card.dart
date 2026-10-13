// Shared UI: project budget burn-rate summary card.
// Callers pass data + formatter; the widget holds no locale strings.
import 'package:flutter/material.dart';

class FinanceSummaryCard extends StatelessWidget {
  final double budget;
  final double spent;
  final String Function(double) fmt;
  const FinanceSummaryCard({super.key, required this.budget, required this.spent, required this.fmt});
  @override
  Widget build(BuildContext context) {
    final pct = budget == 0 ? 0.0 : (spent / budget).clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          LinearProgressIndicator(value: pct),
          const SizedBox(height: 8),
          Text('${fmt(spent)} / ${fmt(budget)}'),
        ]),
      ),
    );
  }
}
