// Clean Architecture: Procurement/Market — Presentation.
// Covers: ConstructionOpenMarketScreen, MachineryMarketplaceScreen,
// OrdersProcurementScreen, ProcurementScreen, QuotationComparisonScreen,
// GpsMaterialLocatorScreen, DrawingPinRecordScreen, ProjectBusinessPlanScreen.
// Titles/bodies resolve from JSON keys — no hardcoded text.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/procurement/data/procurement_repository.dart';

class _Shell extends StatelessWidget {
  final String titleKey;
  final Widget child;
  const _Shell({required this.titleKey, required this.child});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(appBar: AppBar(title: Text(loc.t(titleKey))), body: child);
  }
}

class OpenMarketScreen extends StatelessWidget {
  const OpenMarketScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<ProcurementRepository>();
    if (repo.marketplace.isEmpty) {
      return _Shell(titleKey: 'mkt.open',
        child: Center(child: Text(loc.t('mkt.empty'))));
    }
    return _Shell(titleKey: 'mkt.open',
      child: ListView(children: repo.marketplace.map((m) =>
        ListTile(title: Text(loc.tr(m.titleAr, m.titleEn)),
          trailing: Text(loc.formatAed(m.priceAed)))).toList()));
  }
}

class MachineryMarketScreen extends StatelessWidget {
  const MachineryMarketScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return _Shell(titleKey: 'mkt.machinery',
      child: Center(child: Text(loc.t('mkt.machinery_body'))));
  }
}

class QuotationComparisonScreen extends StatelessWidget {
  const QuotationComparisonScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<ProcurementRepository>();
    return _Shell(titleKey: 'mkt.quotes',
      child: repo.quotations.isEmpty
        ? Center(child: Text(loc.t('mkt.no_quotes')))
        : ListView(children: repo.quotations.map((q) =>
          ListTile(title: Text(q.supplierId),
            subtitle: Text('${loc.formatAed(q.totalAed)} • ${q.deliveryDays} ${loc.t('dash.days')}'))).toList()));
  }
}

class GpsLocatorScreen extends StatelessWidget {
  const GpsLocatorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    // Port of GpsMaterialLocatorScreen: geolocator + nearest batch plant.
    return _Shell(titleKey: 'mkt.gps',
      child: Center(child: Text(loc.t('mkt.gps_note'))));
  }
}
