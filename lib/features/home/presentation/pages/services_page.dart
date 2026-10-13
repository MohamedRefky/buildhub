// Port of AllServicesScreen.kt + serviceId routing table from MainActivity.kt (504-703)
// Service titles resolve from JSON keys (svc.*) — add new services in JSON only.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localization.dart';

class ServiceDef {
  final String id;
  final String titleKey;
  final IconData icon;
  final int targetTab;
  const ServiceDef(this.id, this.titleKey, this.icon, this.targetTab);
}

// Subset covering all major hubs; generic fallback route handles the rest.
const allServices = [
  ServiceDef('open_market', 'svc.open_market', Icons.store, 13),
  ServiceDef('green_wallet', 'svc.green_wallet', Icons.eco, 53),
  ServiceDef('live_gps', 'svc.live_gps', Icons.location_on, 14),
  ServiceDef('concrete_qc', 'svc.concrete_qc', Icons.science, 50),
  ServiceDef('rent_equipment', 'svc.rent_equipment', Icons.construction, 15),
  ServiceDef('baseline_generator', 'svc.baseline_generator', Icons.timeline, 57),
  ServiceDef('approved_vendors', 'svc.approved_vendors', Icons.verified, 58),
  ServiceDef('submittal_tracker', 'svc.submittal_tracker', Icons.assignment, 5),
  ServiceDef('crane_wind', 'svc.crane_wind', Icons.air, 6),
  ServiceDef('safety_shield', 'svc.safety_shield', Icons.health_and_safety, 6),
  ServiceDef('cash_flow', 'svc.cash_flow', Icons.account_balance, 7),
  ServiceDef('financial_ai', 'svc.financial_ai', Icons.analytics, 40),
  ServiceDef('predictive_delay', 'svc.predictive_delay', Icons.warning, 19),
  ServiceDef('market_intelligence', 'svc.market_intelligence', Icons.insights, 20),
  ServiceDef('gcc_tenders', 'svc.gcc_tenders', Icons.gavel, 16),
  ServiceDef('risk_heatmap', 'svc.risk_heatmap', Icons.grid_on, 48),
  ServiceDef('sitepulse', 'svc.sitepulse', Icons.dashboard, 50),
  ServiceDef('procurement_planning', 'svc.procurement_planning', Icons.shopping_cart, 5),
  ServiceDef('engineering_library', 'svc.engineering_library', Icons.library_books, 23),
  ServiceDef('training_courses', 'svc.training_courses', Icons.school, 24),
  ServiceDef('cost_to_complete', 'svc.cost_to_complete', Icons.calculate, 25),
  ServiceDef('weather_brain', 'svc.weather_brain', Icons.wb_sunny, 35),
  ServiceDef('worker_welfare', 'svc.worker_welfare', Icons.people, 38),
  ServiceDef('site_camera', 'svc.site_camera', Icons.camera_alt, 46),
  ServiceDef('buildnet', 'svc.buildnet', Icons.group, 2),
];

class AllServicesScreen extends StatelessWidget {
  final void Function(int tab) onSelect;
  const AllServicesScreen({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.9,
      ),
      itemCount: allServices.length,
      itemBuilder: (_, i) {
        final s = allServices[i];
        return Card(
          child: InkWell(
            onTap: () => onSelect(s.targetTab),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(s.icon, size: 28),
                const SizedBox(height: 8),
                Text(loc.t(s.titleKey),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
        );
      },
    );
  }
}
