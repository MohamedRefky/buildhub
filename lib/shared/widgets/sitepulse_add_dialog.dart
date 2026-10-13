// Shared UI: universal SitePulse field-entry dialog.
// Ports: SitePulseUniversalAddDialog.kt — 12 categories with per-category
// dynamic forms. Callers receive (category, values); the 12 typed
// callbacks stay available for precise wiring. Labels resolve from JSON.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';

enum SitePulseAddCategory {
  blocker,
  workfront,
  action,
  inspection,
  rfi,
  commitment,
  manpower,
  equipment,
  production,
  snag,
  variation,
  dailyWeather,
}

String _categoryKey(SitePulseAddCategory c) => switch (c) {
      SitePulseAddCategory.blocker => 'sp.add_blocker',
      SitePulseAddCategory.workfront => 'sp.add_workfront',
      SitePulseAddCategory.action => 'sp.add_action',
      SitePulseAddCategory.inspection => 'sp.add_inspection',
      SitePulseAddCategory.rfi => 'sp.add_rfi',
      SitePulseAddCategory.commitment => 'sp.add_commitment',
      SitePulseAddCategory.manpower => 'sp.add_manpower',
      SitePulseAddCategory.equipment => 'sp.add_equipment',
      SitePulseAddCategory.production => 'sp.add_production',
      SitePulseAddCategory.snag => 'sp.add_snag',
      SitePulseAddCategory.variation => 'sp.add_variation',
      SitePulseAddCategory.dailyWeather => 'sp.add_weather',
    };

/// Field specs per category: (labelKey, hintKey, isRequired).
List<(String, String, bool)> _fieldsFor(SitePulseAddCategory c) {
  const title = ('sp.f_title', 'sp.h_title', true);
  const zone = ('sp.f_zone', 'sp.h_zone', false);
  const owner = ('sp.f_owner', 'sp.h_owner', false);
  const priority = ('sp.f_priority', 'sp.h_priority', false);
  const deadline = ('sp.f_deadline', 'sp.h_deadline', false);
  const desc = ('sp.f_desc', 'sp.h_desc', false);
  const qty = ('sp.f_qty', 'sp.h_qty', false);
  const unit = ('sp.f_unit', 'sp.h_unit', false);
  const status = ('sp.f_status', 'sp.h_status', false);
  const assignee = ('sp.f_assignee', 'sp.h_assignee', false);
  return switch (c) {
    SitePulseAddCategory.blocker => [title, zone, desc, owner, priority, deadline],
    SitePulseAddCategory.workfront => [title, zone, desc, owner, status],
    SitePulseAddCategory.action => [title, desc, assignee, deadline, priority],
    SitePulseAddCategory.inspection => [title, zone, owner, status, deadline],
    SitePulseAddCategory.rfi => [title, desc, owner, priority],
    SitePulseAddCategory.commitment => [title, desc, owner, deadline],
    SitePulseAddCategory.manpower => [title, qty, zone, owner],
    SitePulseAddCategory.equipment => [title, qty, zone, status],
    SitePulseAddCategory.production => [title, qty, unit, zone],
    SitePulseAddCategory.snag => [title, zone, desc, priority],
    SitePulseAddCategory.variation => [title, qty, desc, owner],
    SitePulseAddCategory.dailyWeather => [desc, zone, status],
  };
}

class UniversalSitePulseAddDialog extends StatefulWidget {
  final SitePulseAddCategory initialCategory;
  final String currentDateString;
  final void Function(SitePulseAddCategory category, Map<String, String> values)
      onSubmit;
  final void Function(Map<String, String> values)? onAddBlocker;
  final void Function(Map<String, String> values)? onAddWorkfront;
  final void Function(Map<String, String> values)? onAddActionItem;
  final void Function(Map<String, String> values)? onAddInspection;
  final void Function(Map<String, String> values)? onAddRfi;
  final void Function(Map<String, String> values)? onAddCommitment;
  final void Function(Map<String, String> values)? onAddManpower;
  final void Function(Map<String, String> values)? onAddEquipment;
  final void Function(Map<String, String> values)? onAddProduction;
  final void Function(Map<String, String> values)? onAddSitePhoto;
  final void Function(Map<String, String> values)? onAddVariation;
  const UniversalSitePulseAddDialog({
    super.key,
    this.initialCategory = SitePulseAddCategory.blocker,
    this.currentDateString = '',
    required this.onSubmit,
    this.onAddBlocker,
    this.onAddWorkfront,
    this.onAddActionItem,
    this.onAddInspection,
    this.onAddRfi,
    this.onAddCommitment,
    this.onAddManpower,
    this.onAddEquipment,
    this.onAddProduction,
    this.onAddSitePhoto,
    this.onAddVariation,
  });
  @override
  State<UniversalSitePulseAddDialog> createState() =>
      _UniversalSitePulseAddDialogState();
}

class _UniversalSitePulseAddDialogState
    extends State<UniversalSitePulseAddDialog> {
  late SitePulseAddCategory _category;
  final Map<String, TextEditingController> _ctrls = {};

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
  }

  @override
  void dispose() {
    for (final c in _ctrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _ctrl(String key) =>
      _ctrls.putIfAbsent(key, () => TextEditingController());

  void _submit() {
    final values = {
      for (final (label, _, _) in _fieldsFor(_category))
        label: _ctrl(label).text.trim(),
    };
    widget.onSubmit(_category, values);
    switch (_category) {
      case SitePulseAddCategory.blocker:
        widget.onAddBlocker?.call(values);
      case SitePulseAddCategory.workfront:
        widget.onAddWorkfront?.call(values);
      case SitePulseAddCategory.action:
        widget.onAddActionItem?.call(values);
      case SitePulseAddCategory.inspection:
        widget.onAddInspection?.call(values);
      case SitePulseAddCategory.rfi:
        widget.onAddRfi?.call(values);
      case SitePulseAddCategory.commitment:
        widget.onAddCommitment?.call(values);
      case SitePulseAddCategory.manpower:
        widget.onAddManpower?.call(values);
      case SitePulseAddCategory.equipment:
        widget.onAddEquipment?.call(values);
      case SitePulseAddCategory.production:
        widget.onAddProduction?.call(values);
      case SitePulseAddCategory.snag:
        widget.onAddSitePhoto?.call(values);
      case SitePulseAddCategory.variation:
        widget.onAddVariation?.call(values);
      case SitePulseAddCategory.dailyWeather:
        break;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final fields = _fieldsFor(_category);
    final titleCtrl = _ctrl('sp.f_title');
    final validTitle = _category == SitePulseAddCategory.dailyWeather ||
        titleCtrl.text.trim().isNotEmpty;
    return AlertDialog(
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(loc.t('sp.add_title')),
        Text(
            '${loc.t('sp.add_sub')} • ${widget.currentDateString.isEmpty ? DateTime.now().toIso8601String().substring(0, 10) : widget.currentDateString}',
            style: Theme.of(context).textTheme.labelSmall),
      ]),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: SitePulseAddCategory.values
                      .map((c) => Padding(
                          padding:
                              const EdgeInsetsDirectional.only(end: 6),
                          child: ChoiceChip(
                              label: Text(loc.t(_categoryKey(c))),
                              selected: _category == c,
                              onSelected: (_) => setState(
                                  () => _category = c))))
                      .toList()),
            ),
            const SizedBox(height: 8),
            Text(loc.t('${_categoryKey(_category)}_form'),
                style: Theme.of(context).textTheme.titleSmall),
            ...fields.map((f) => TextField(
                  controller: _ctrl(f.$1),
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText:
                        '${loc.t(f.$1)}${f.$3 ? ' *' : ''}',
                    hintText: loc.t(f.$2),
                  ),
                )),
            if (!validTitle)
              Text(loc.t('sp.add_title_required'),
                  style: const TextStyle(color: Colors.red)),
          ]),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.t('common.cancel'))),
        ElevatedButton(
            onPressed: validTitle ? _submit : null,
            child: Text(loc.t('sp.add_submit'))),
      ],
    );
  }
}
