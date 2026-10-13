// Clean Architecture: Procurement/Market — Presentation.
// Covers: ConstructionOpenMarketScreen, MachineryMarketplaceScreen,
// OrdersProcurementScreen, ProcurementScreen, QuotationComparisonScreen,
// GpsMaterialLocatorScreen, DrawingPinRecordScreen, ProjectBusinessPlanScreen.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/procurement/data/procurement_repository.dart';

class _Shell extends StatelessWidget {
  final String ar; final String en; final Widget child;
  const _Shell({required this.ar, required this.en, required this.child});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(appBar: AppBar(title: Text(loc.tr(ar, en))), body: child);
  }
}

class OpenMarketScreen extends StatelessWidget {
  const OpenMarketScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<ProcurementRepository>();
    if (repo.marketplace.isEmpty) {
      return _Shell(ar: 'السوق المفتوح', en: 'Open Market',
        child: Center(child: Text(loc.tr('أضف عروض الموردين من Firestore', 'Add supplier listings from Firestore'))));
    }
    return _Shell(ar: 'السوق المفتوح', en: 'Open Market',
      child: ListView(children: repo.marketplace.map((m) =>
        ListTile(title: Text(loc.tr(m.titleAr, m.titleEn)),
          trailing: Text('${m.priceAed}'))).toList()));
  }
}

class MachineryMarketScreen extends StatelessWidget {
  const MachineryMarketScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      _Shell(ar: 'سوق المعدات الثقيلة', en: 'Machinery Market',
        child: const Center(child: Text('Dubizzle-style • wire Firestore')));
}

class QuotationComparisonScreen extends StatelessWidget {
  const QuotationComparisonScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<ProcurementRepository>();
    return _Shell(ar: 'مقارنة عروض الأسعار', en: 'Quotation Comparison',
      child: repo.quotations.isEmpty
        ? Center(child: Text(loc.tr('لا عروض بعد', 'No quotations yet')))
        : ListView(children: repo.quotations.map((q) =>
          ListTile(title: Text(q.supplierId),
            subtitle: Text('${q.totalAed} AED • ${q.deliveryDays}d'))).toList()));
  }
}

class GpsLocatorScreen extends StatelessWidget {
  const GpsLocatorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    // Port of GpsMaterialLocatorScreen: geolocator + nearest batch plant.
    return _Shell(ar: 'محدد المواد GPS', en: 'GPS Material Locator',
      child: Center(child: Text(loc.tr(
        'اطلب إذن الموقع ثم اعرض أقرب محطة خرسانة',
        'Request location permission, then show nearest batch plant'))));
  }
}
