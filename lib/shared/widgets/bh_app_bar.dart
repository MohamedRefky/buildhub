// Shared UI: app top bar + add-project dialog.
// Ports: BhComponents.kt (BhTopAppBar, AddProjectDialog). Primitive
// callbacks keep shared/ decoupled from features. Labels resolve from JSON.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'offline_status.dart';

class BhTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String projectName;
  final VoidCallback onProjectSwitch;
  final bool sunlightMode;
  final VoidCallback onToggleSunlight;
  final VoidCallback onToggleLanguage;
  final VoidCallback onOfflineStatusTap;
  const BhTopAppBar({
    super.key,
    required this.projectName,
    required this.onProjectSwitch,
    required this.sunlightMode,
    required this.onToggleSunlight,
    required this.onToggleLanguage,
    required this.onOfflineStatusTap,
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return AppBar(
      title: InkWell(
        onTap: onProjectSwitch,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Orion B',
                  style: TextStyle(fontSize: 12)),
              Text(projectName,
                  style: Theme.of(context).textTheme.titleMedium),
            ]),
      ),
      actions: [
        OfflineStatusChip(onTap: onOfflineStatusTap),
        IconButton(
            icon: Icon(sunlightMode ? Icons.dark_mode : Icons.light_mode),
            tooltip: loc.t('acct.sunlight'),
            onPressed: onToggleSunlight),
        TextButton(
            onPressed: onToggleLanguage,
            child: Text(loc.t('common.lang_toggle'),
                style: const TextStyle(color: Colors.white))),
      ],
    );
  }
}

class AddProjectDialog extends StatefulWidget {
  final void Function(String nameAr, String nameEn, double budgetAed) onSave;
  const AddProjectDialog({super.key, required this.onSave});
  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final _arCtrl = TextEditingController();
  final _enCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController(text: '15000000');

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return AlertDialog(
      title: Text(loc.t('widgets.proj_add_title')),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
            controller: _arCtrl,
            decoration: InputDecoration(
                labelText: loc.t('widgets.proj_name_ar'))),
        TextField(
            controller: _enCtrl,
            decoration: InputDecoration(
                labelText: loc.t('widgets.proj_name_en'))),
        TextField(
            controller: _budgetCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: loc.t('widgets.proj_budget'))),
      ]),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.t('common.cancel'))),
        ElevatedButton(
            onPressed: () {
              widget.onSave(_arCtrl.text, _enCtrl.text,
                  double.tryParse(_budgetCtrl.text) ?? 0);
              Navigator.pop(context);
            },
            child: Text(loc.t('widgets.proj_save'))),
      ],
    );
  }
}
