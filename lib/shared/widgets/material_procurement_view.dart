// Shared UI: material procurement board.
// Ports: MaterialProcurementView.kt — KPI row + search + status tabs +
// order cards + detail dialog (milestone updates) + add dialog.
// Operates on MaterialOrderEntity; labels resolve from JSON.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/procurement/domain/entities/procurement_entities.dart';

String _statusKey(OrderStatus s) => switch (s) {
      OrderStatus.draft => 'widgets.po_draft',
      OrderStatus.submitted => 'ven.status_submitted',
      OrderStatus.approved => 'widgets.po_approved',
      OrderStatus.inTransit => 'widgets.po_transit',
      OrderStatus.outForDelivery => 'widgets.po_at_bay',
      OrderStatus.delivered => 'widgets.po_delivered',
      OrderStatus.delayed => 'widgets.po_delayed',
      OrderStatus.cancelled => 'widgets.po_cancelled',
    };

class MaterialProcurementView extends StatefulWidget {
  final List<MaterialOrderEntity> orders;
  final void Function(MaterialOrderEntity order) onAddOrder;
  final void Function(String orderId, OrderStatus status, int progress)
      onUpdateStatus;
  final void Function(String orderId) onDeleteOrder;
  const MaterialProcurementView({
    super.key,
    required this.orders,
    required this.onAddOrder,
    required this.onUpdateStatus,
    required this.onDeleteOrder,
  });
  @override
  State<MaterialProcurementView> createState() =>
      _MaterialProcurementViewState();
}

class _MaterialProcurementViewState extends State<MaterialProcurementView> {
  String _query = '';
  int _tab = 0;

  bool _tabMatch(MaterialOrderEntity o) => switch (_tab) {
        1 => o.status == OrderStatus.inTransit ||
            o.status == OrderStatus.outForDelivery,
        2 => o.status == OrderStatus.delayed,
        3 => o.status == OrderStatus.delivered,
        _ => true,
      };

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final q = _query.trim().toLowerCase();
    final filtered = widget.orders.where((o) {
      if (!_tabMatch(o)) return false;
      if (q.isEmpty) return true;
      return o.id.toLowerCase().contains(q) ||
          o.materialNameAr.contains(_query.trim()) ||
          o.materialNameEn.toLowerCase().contains(q) ||
          o.supplierName.toLowerCase().contains(q);
    }).toList();
    final inTransit = widget.orders
        .where((o) =>
            o.status == OrderStatus.inTransit ||
            o.status == OrderStatus.outForDelivery)
        .length;
    final delayed = widget.orders
        .where((o) => o.status == OrderStatus.delayed)
        .length;
    final tabs = [
      loc.t('widgets.po_tab_all'),
      loc.t('widgets.po_tab_transit'),
      loc.t('widgets.po_tab_delayed'),
      loc.t('widgets.po_tab_delivered'),
    ];
    return Column(children: [
      Row(children: [
        Expanded(child: _PoKpi(
            title: loc.t('widgets.po_kpi_total'),
            value: '${widget.orders.length}',
            sub: loc.t('widgets.po_kpi_total_sub'))),
        Expanded(child: _PoKpi(
            title: loc.t('widgets.po_kpi_transit'),
            value: '$inTransit',
            sub: loc.t('widgets.po_kpi_transit_sub'))),
        Expanded(child: _PoKpi(
            title: loc.t('widgets.po_kpi_delayed'),
            value: '$delayed',
            sub: loc.t(delayed > 0
                ? 'widgets.po_kpi_delayed_bad'
                : 'widgets.po_kpi_delayed_ok'))),
      ]),
      const SizedBox(height: 8),
      TextField(
        onChanged: (v) => setState(() => _query = v),
        decoration: InputDecoration(
          hintText: loc.t('widgets.po_search'),
          prefixIcon: const Icon(Icons.search),
        ),
      ),
      const SizedBox(height: 8),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: List.generate(
                tabs.length,
                (i) => Padding(
                    padding: const EdgeInsetsDirectional.only(end: 6),
                    child: ChoiceChip(
                        label: Text(tabs[i]),
                        selected: _tab == i,
                        onSelected: (_) =>
                            setState(() => _tab = i))))),
      ),
      const SizedBox(height: 8),
      if (filtered.isEmpty)
        Padding(
            padding: const EdgeInsets.all(16),
            child: Text(loc.t('widgets.po_empty')))
      else
        ...filtered.map((o) => _OrderCard(
              order: o,
              onVerify: () => widget.onUpdateStatus(
                  o.id, OrderStatus.delivered, 100),
              onDetails: () => _showDetail(context, loc, o),
            )),
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: FloatingActionButton(
          onPressed: () => _showAdd(context, loc),
          child: const Icon(Icons.add),
        ),
      ),
    ]);
  }

  Future<void> _showDetail(
      BuildContext context, AppLocalization loc, MaterialOrderEntity o) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.tr(o.materialNameAr, o.materialNameEn)),
        content: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(loc.t('widgets.po_supplier_title')),
                Text('${loc.t('widgets.po_supplier_code')} ${o.supplierName}'),
                Text(
                    '${loc.t('widgets.po_ordered')} ${o.expectedDeliveryDate}'),
                Text('${loc.t('widgets.po_bay')} Bay'),
                Text(
                    '${loc.t('widgets.po_qty')} ${o.quantity} ${o.unit}'),
                const SizedBox(height: 8),
                Text(loc.t('widgets.po_update_milestone')),
                Wrap(spacing: 6, children: [
                  ElevatedButton(
                      onPressed: () {
                        widget.onUpdateStatus(
                            o.id, OrderStatus.inTransit, 50);
                        Navigator.pop(context);
                      },
                      child: Text(loc.t('widgets.po_mil_transit'))),
                  ElevatedButton(
                      onPressed: () {
                        widget.onUpdateStatus(
                            o.id, OrderStatus.outForDelivery, 80);
                        Navigator.pop(context);
                      },
                      child: Text(loc.t('widgets.po_mil_bay'))),
                  ElevatedButton(
                      onPressed: () {
                        widget.onUpdateStatus(
                            o.id, OrderStatus.delivered, 100);
                        Navigator.pop(context);
                      },
                      child: Text(loc.t('widgets.po_mil_delivered'))),
                ]),
              ]),
        ),
        actions: [
          TextButton(
              onPressed: () {
                widget.onDeleteOrder(o.id);
                Navigator.pop(context);
              },
              child: Text(loc.t('widgets.po_delete'))),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(loc.t('widgets.po_close'))),
        ],
      ),
    );
  }

  Future<void> _showAdd(BuildContext context, AppLocalization loc) async {
    final nameCtrl = TextEditingController();
    final supplierCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final valueCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.t('widgets.po_add_title')),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                    labelText: loc.t('widgets.po_f_material'))),
            TextField(
                controller: supplierCtrl,
                decoration: InputDecoration(
                    labelText: loc.t('widgets.po_f_supplier'))),
            TextField(
                controller: qtyCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: loc.t('widgets.po_f_qty'))),
            TextField(
                controller: valueCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: loc.t('widgets.po_f_value'))),
          ]),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(loc.t('common.cancel'))),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(loc.t('widgets.po_f_save'))),
        ],
      ),
    );
    if (ok == true && nameCtrl.text.trim().isNotEmpty) {
      final qty = double.tryParse(qtyCtrl.text) ?? 0;
      final value = double.tryParse(valueCtrl.text) ?? 0;
      widget.onAddOrder(MaterialOrderEntity(
        id: const Uuid().v4(),
        poNumber: 'PO-${DateTime.now().millisecondsSinceEpoch % 100000}',
        projectId: '',
        materialNameAr: nameCtrl.text.trim(),
        materialNameEn: nameCtrl.text.trim(),
        quantity: qty,
        supplierName: supplierCtrl.text.trim(),
        subtotalAed: value,
        vatAed: value * 0.05,
        grandTotalAed: value * 1.05,
      ));
    }
  }
}

class _OrderCard extends StatelessWidget {
  final MaterialOrderEntity order;
  final VoidCallback onVerify;
  final VoidCallback onDetails;
  const _OrderCard(
      {required this.order, required this.onVerify, required this.onDetails});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(order.poNumber.isEmpty ? order.id : order.poNumber,
                    style: Theme.of(context).textTheme.labelSmall),
                const Spacer(),
                Chip(label: Text(loc.t(_statusKey(order.status)))),
              ]),
              Text(loc.tr(order.materialNameAr, order.materialNameEn),
                  style: Theme.of(context).textTheme.titleSmall),
              Text(
                  '${order.quantity} ${order.unit} • ${order.supplierName}'),
              LinearProgressIndicator(
                  value: (order.progressPercent / 100).clamp(0.0, 1.0)),
              Text('${order.progressPercent}%'),
              Row(children: [
                ElevatedButton(
                    onPressed: onVerify,
                    child: Text(loc.t('widgets.po_verify'))),
                const SizedBox(width: 8),
                TextButton(
                    onPressed: onDetails,
                    child: Text(loc.t('widgets.po_details'))),
              ]),
            ]),
      ),
    );
  }
}

class _PoKpi extends StatelessWidget {
  final String title;
  final String value;
  final String sub;
  const _PoKpi(
      {required this.title, required this.value, required this.sub});
  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.labelSmall),
                Text(value,
                    style: Theme.of(context).textTheme.titleLarge),
                Text(sub,
                    style: Theme.of(context).textTheme.labelSmall),
              ]),
        ),
      );
}
