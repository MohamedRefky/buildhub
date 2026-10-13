// Clean Architecture: shared UI widgets.
// Ports ui/components/: BhComponents, StatusCard, OfflineStatusIndicator,
// TowerCraneWindWidget, ProjectFinanceSummaryCard, ProjectProgressLineChart,
// DailySiteLogCard, BudgetBurnRateDashboard, SafetyQrCodeView,
// MaterialProcurementView, ProcurementRequestDialog, ActiveVoiceRecordingSection.
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const StatusCard({super.key, required this.title, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Card(
    color: color.withValues(alpha: 0.12),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.labelSmall),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ]),
    ),
  );
}

class OfflineBanner extends StatelessWidget {
  final bool isOffline;
  final VoidCallback onTap;
  const OfflineBanner({super.key, required this.isOffline, required this.onTap});
  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();
    return MaterialBanner(
      content: const Text('Offline — showing cached Room data'),
      actions: [TextButton(onPressed: onTap, child: const Text('Details'))],
    );
  }
}

class CraneWindWidget extends StatelessWidget {
  final double windMs;
  final bool allowed;
  const CraneWindWidget({super.key, required this.windMs, required this.allowed});
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(Icons.air,
        color: allowed ? Colors.green : Colors.red),
      title: Text('$windMs m/s'),
      subtitle: Text(allowed ? 'Crane operation allowed' : 'STOP crane ops'),
    ),
  );
}

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

class SafetyQrView extends StatelessWidget {
  final String payload;
  const SafetyQrView({super.key, required this.payload});
  @override
  Widget build(BuildContext context) =>
      QrImageView(data: payload, size: 160);
}
