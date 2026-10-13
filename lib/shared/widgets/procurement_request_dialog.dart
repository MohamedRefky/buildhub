// Shared UI: advanced procurement request dialog.
// Ports: ProcurementRequestDialog.kt — category/supplier/bay dropdowns,
// live delivery-date validation with lead-time helpers, escrow note and
// Firestore-synced submit. Labels resolve from JSON.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';

class ProcurementRequestData {
  final String category;
  final String description;
  final double quantity;
  final String unit;
  final double totalValueAed;
  final String supplier;
  final String bay;
  final String deliveryDate;
  const ProcurementRequestData({
    required this.category, required this.description,
    required this.quantity, required this.unit,
    required this.totalValueAed, required this.supplier,
    required this.bay, required this.deliveryDate,
  });
}

const _categories = [
  ('RMC', 'خرسانة جاهزة', 'Ready-mix concrete', 'م³', 7),
  ('STEEL', 'حديد تسليح', 'Rebar steel', 'طن', 14),
  ('MEP', 'كهروميكانيكا', 'MEP systems', 'مجموعة', 21),
  ('FACADE', 'واجهات', 'Facade', 'م²', 30),
  ('FINISH', 'تشطيبات', 'Finishing', 'بند', 10),
];

const _suppliers = [
  'Emirates Steel Arkan',
  'Readymix Gulf',
  'Ducab Cables',
  'RAK Ceramics',
  'United Facades',
];

const _bays = ['A1', 'B2', 'C1', 'D1'];

class ProcurementRequestDialog extends StatefulWidget {
  final String targetProjectId;
  final String targetProjectName;
  final void Function(ProcurementRequestData data) onSaveOrder;
  const ProcurementRequestDialog({
    super.key,
    this.targetProjectId = 'proj-01',
    this.targetProjectName = '',
    required this.onSaveOrder,
  });
  @override
  State<ProcurementRequestDialog> createState() =>
      _ProcurementRequestDialogState();
}

class _ProcurementRequestDialogState
    extends State<ProcurementRequestDialog> {
  int _category = 0;
  int _supplier = 0;
  int _bay = 0;
  final _descCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  bool _busy = false;

  int get _leadDays => _categories[_category].$5;
  String get _unit => _categories[_category].$4;

  String _minDateStr() {
    final d = DateTime.now().add(Duration(days: _leadDays));
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  /// Mirrors DeliveryDateValidator: red (too early) / amber (tight) / green.
  (bool, bool, int) _validate(String input) {
    final picked = DateTime.tryParse(input.trim());
    if (picked == null) return (false, false, 0);
    final days =
        picked.difference(DateTime.now()).inDays;
    if (days < _leadDays) return (false, false, days);
    if (days < _leadDays + 7) return (true, true, days);
    return (true, false, days);
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final (valid, warning, _) = _validate(_dateCtrl.text);
    final hasDate = _dateCtrl.text.trim().isNotEmpty;
    final validationColor = !hasDate
        ? Colors.grey
        : (!valid ? Colors.red : (warning ? Colors.amber : Colors.green));
    return AlertDialog(
      title: Text(loc.t('widgets.pr_title')),
      content: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.t('widgets.pr_sub'),
                  style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: _category,
                decoration: InputDecoration(
                    labelText: loc.t('widgets.pr_category')),
                items: [
                  for (var i = 0; i < _categories.length; i++)
                    DropdownMenuItem(
                        value: i,
                        child: Text(loc.tr(_categories[i].$2,
                            _categories[i].$3))),
                ],
                onChanged: (v) => setState(() => _category = v ?? 0),
              ),
              TextField(
                  controller: _descCtrl,
                  decoration: InputDecoration(
                      labelText: loc.t('widgets.pr_desc'))),
              Row(children: [
                Expanded(
                    child: TextField(
                        controller: _qtyCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: loc.t('widgets.pr_qty')))),
                const SizedBox(width: 8),
                Expanded(child: Text('${loc.t('widgets.pr_unit')}: $_unit')),
              ]),
              TextField(
                  controller: _valueCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: loc.t('widgets.pr_value'))),
              DropdownButtonFormField<int>(
                initialValue: _supplier,
                decoration: InputDecoration(
                    labelText: loc.t('widgets.pr_supplier')),
                items: [
                  for (var i = 0; i < _suppliers.length; i++)
                    DropdownMenuItem(
                        value: i, child: Text(_suppliers[i])),
                ],
                onChanged: (v) => setState(() => _supplier = v ?? 0),
              ),
              DropdownButtonFormField<int>(
                initialValue: _bay,
                decoration: InputDecoration(
                    labelText: loc.t('widgets.pr_bay')),
                items: [
                  for (var i = 0; i < _bays.length; i++)
                    DropdownMenuItem(
                        value: i, child: Text(_bays[i])),
                ],
                onChanged: (v) => setState(() => _bay = v ?? 0),
              ),
              const SizedBox(height: 8),
              Text(loc.t('widgets.pr_date_title')),
              TextField(
                  controller: _dateCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'YYYY-MM-DD',
                    labelText: loc.t('widgets.pr_date'),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: validationColor)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: validationColor)),
                  )),
              Text(
                  '${loc.t('widgets.pr_earliest')} ${_minDateStr()} ($_leadDays ${loc.t('dash.days')})',
                  style: Theme.of(context).textTheme.labelSmall),
              if (hasDate)
                Text(
                  valid
                      ? (warning
                          ? loc.t('widgets.pr_warn')
                          : loc.t('widgets.pr_ok'))
                      : loc.t('widgets.pr_invalid'),
                  style: TextStyle(color: validationColor),
                ),
              Row(children: [
                TextButton(
                    onPressed: () => setState(() =>
                        _dateCtrl.text = _minDateStr()),
                    child: Text(
                        '+${loc.t('widgets.pr_min_lead')} ($_leadDays${loc.t('dash.days')})')),
                TextButton(
                    onPressed: () {
                      final d = DateTime.now()
                          .add(Duration(days: _leadDays + 7));
                      setState(() => _dateCtrl.text =
                          '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}');
                    },
                    child: const Text('+7d')),
              ]),
              Text('🔒 ${loc.t('widgets.pr_escrow_note')}',
                  style: Theme.of(context).textTheme.labelSmall),
            ]),
      ),
      actions: [
        TextButton(
            onPressed: _busy ? null : () => Navigator.pop(context),
            child: Text(loc.t('common.cancel'))),
        ElevatedButton(
            onPressed: _busy || !valid
                ? null
                : () async {
                    setState(() => _busy = true);
                    widget.onSaveOrder(ProcurementRequestData(
                      category: _categories[_category].$1,
                      description: _descCtrl.text.trim(),
                      quantity:
                          double.tryParse(_qtyCtrl.text) ?? 0,
                      unit: _unit,
                      totalValueAed:
                          double.tryParse(_valueCtrl.text) ?? 0,
                      supplier: _suppliers[_supplier],
                      bay: _bays[_bay],
                      deliveryDate: _dateCtrl.text.trim(),
                    ));
                    if (mounted) Navigator.pop(context);
                  },
            child: _busy
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : Text(loc.t('widgets.pr_submit'))),
      ],
    );
  }
}
