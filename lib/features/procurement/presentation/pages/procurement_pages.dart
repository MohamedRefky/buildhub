// Clean Architecture: Procurement/Market — Presentation.
// Covers: ConstructionOpenMarketScreen, MachineryMarketplaceScreen,
// OrdersProcurementScreen, ProcurementScreen, QuotationComparisonScreen,
// GpsMaterialLocatorScreen, DrawingPinRecordScreen, ProjectBusinessPlanScreen.
// Titles/bodies resolve from JSON keys — no hardcoded text.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/procurement/data/repositories/procurement_repository.dart';
import 'package:buildhub/shared/widgets/material_procurement_view.dart';

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

/// Port of OrdersProcurementScreen.kt (MainActivity tab 3): two modes —
/// materials timeline and POs & Escrow with delivery-QR dialog.
class OrdersProcurementScreen extends StatefulWidget {
  const OrdersProcurementScreen({super.key});
  @override
  State<OrdersProcurementScreen> createState() =>
      _OrdersProcurementScreenState();
}

class _OrdersProcurementScreenState extends State<OrdersProcurementScreen> {
  int _mode = 0;
  int _poFilter = 0;
  String? _qrOrderId;

  bool _poMatch(String statusName) => switch (_poFilter) {
        1 => statusName == 'submitted' || statusName == 'approved',
        2 => statusName == 'inTransit' || statusName == 'outForDelivery',
        3 => statusName == 'delivered',
        _ => true,
      };

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<ProcurementRepository>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('screen.orders'))),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: SegmentedButton<int>(
            segments: [
              ButtonSegment(
                  value: 0, label: Text(loc.t('ord.mode_materials'))),
              ButtonSegment(
                  value: 1, label: Text(loc.t('ord.mode_pos'))),
            ],
            selected: {_mode},
            onSelectionChanged: (s) => setState(() => _mode = s.first),
          ),
        ),
        Expanded(
          child: _mode == 0
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: MaterialProcurementView(
                    orders: repo.orders,
                    onAddOrder: repo.addOrder,
                    onUpdateStatus: (id, status, progress) =>
                        repo.updateOrderProgress(id, progress),
                    onDeleteOrder: repo.deleteOrder,
                  ),
                )
              : _poList(context, loc, repo),
        ),
      ]),
    );
  }

  Widget _poList(BuildContext context, AppLocalization loc,
      ProcurementRepository repo) {
    final filters = [
      loc.t('ord.f_all'),
      loc.t('ord.f_awaiting'),
      loc.t('ord.f_transit'),
      loc.t('ord.f_done'),
    ];
    final orders = repo.orders
        .where((o) => _poMatch(o.status.name))
        .toList();
    return Column(children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
            children: List.generate(
                filters.length,
                (i) => Padding(
                    padding:
                        const EdgeInsetsDirectional.only(end: 6),
                    child: ChoiceChip(
                        label: Text(filters[i]),
                        selected: _poFilter == i,
                        onSelected: (_) =>
                            setState(() => _poFilter = i))))),
      ),
      Expanded(
        child: orders.isEmpty
            ? Center(child: Text(loc.t('ord.empty_pos')))
            : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (_, i) {
                  final o = orders[i];
                  return Card(
                    child: ListTile(
                      title: Text(
                          '${o.poNumber.isEmpty ? o.id : o.poNumber} • ${loc.tr(o.materialNameAr, o.materialNameEn)}'),
                      subtitle: Text(
                          '${o.supplierName} • ${loc.t('ord.escrow')}: ${loc.formatAed(o.grandTotalAed)}'),
                      trailing: ElevatedButton(
                        onPressed: () =>
                            setState(() => _qrOrderId = o.id),
                        child: Text(loc.t('ord.delivery_qr')),
                      ),
                    ),
                  );
                },
              ),
      ),
      if (_qrOrderId != null)
        AlertDialog(
          title: Text(loc.t('ord.qr_title')),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.qr_code_2, size: 120),
            Text(loc.t('ord.qr_body')),
            Text(_qrOrderId!),
          ]),
          actions: [
            TextButton(
                onPressed: () =>
                    setState(() => _qrOrderId = null),
                child: Text(loc.t('common.cancel'))),
          ],
        ),
    ]);
  }
}
