// Port of AllServicesScreen.kt + serviceId routing table from MainActivity.kt (504-703)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localization.dart';

class ServiceDef {
  final String id;
  final String titleAr;
  final String titleEn;
  final IconData icon;
  final int targetTab;
  const ServiceDef(this.id, this.titleAr, this.titleEn, this.icon, this.targetTab);
}

// Subset covering all major hubs; generic fallback route handles the rest.
const allServices = [
  ServiceDef('open_market', 'السوق المفتوح', 'Open Market', Icons.store, 13),
  ServiceDef('green_wallet', 'المحفظة الخضراء', 'Green Wallet', Icons.eco, 53),
  ServiceDef('live_gps', 'تتبع GPS', 'GPS Tracking', Icons.location_on, 14),
  ServiceDef('concrete_qc', 'جودة الخرسانة', 'Concrete QC', Icons.science, 50),
  ServiceDef('rent_equipment', 'تأجير المعدات', 'Equipment Rental', Icons.construction, 15),
  ServiceDef('baseline_generator', 'مولد البيزلاين', 'Baseline Generator', Icons.timeline, 57),
  ServiceDef('approved_vendors', 'الموردون المعتمدون', 'Approved Vendors', Icons.verified, 58),
  ServiceDef('submittal_tracker', 'الاعتمادات', 'Submittals', Icons.assignment, 5),
  ServiceDef('crane_wind', 'سلامة الرافعات', 'Crane Safety', Icons.air, 6),
  ServiceDef('safety_shield', 'السلامة HSE', 'HSE Safety', Icons.health_and_safety, 6),
  ServiceDef('cash_flow', 'التدفق النقدي', 'Cash Flow', Icons.account_balance, 7),
  ServiceDef('financial_ai', 'الذكاء المالي', 'Financial AI', Icons.analytics, 40),
  ServiceDef('predictive_delay', 'توقع التأخير', 'Delay Prediction', Icons.warning, 19),
  ServiceDef('market_intelligence', 'ذكاء السوق', 'Market Intel', Icons.insights, 20),
  ServiceDef('gcc_tenders', 'مناقصات الخليج', 'GCC Tenders', Icons.gavel, 16),
  ServiceDef('risk_heatmap', 'خريطة المخاطر', 'Risk Map', Icons.grid_on, 48),
  ServiceDef('sitepulse', 'مركز القيادة', 'Command Center', Icons.dashboard, 50),
  ServiceDef('procurement_planning', 'التخطيط للتوريد', 'Procurement Plan', Icons.shopping_cart, 5),
  ServiceDef('engineering_library', 'المكتبة الهندسية', 'Eng. Library', Icons.library_books, 23),
  ServiceDef('training_courses', 'الدورات', 'Courses', Icons.school, 24),
  ServiceDef('cost_to_complete', 'التكلفة للإنجاز', 'Cost to Complete', Icons.calculate, 25),
  ServiceDef('weather_brain', 'طقس الموقع', 'Weather Brain', Icons.wb_sunny, 35),
  ServiceDef('worker_welfare', 'رعاية العمال', 'Worker Welfare', Icons.people, 38),
  ServiceDef('site_camera', 'كاميرا الموقع', 'Site Camera', Icons.camera_alt, 46),
  ServiceDef('buildnet', 'شبكة BuildNet', 'BuildNet', Icons.group, 2),
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
                Text(loc.tr(s.titleAr, s.titleEn),
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
