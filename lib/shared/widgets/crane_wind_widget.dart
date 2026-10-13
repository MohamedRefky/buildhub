// Shared UI: tower-crane wind safety indicator.
// Text resolves from JSON — no hardcoded literals.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';

class CraneWindWidget extends StatelessWidget {
  final double windMs;
  final bool allowed;
  const CraneWindWidget({super.key, required this.windMs, required this.allowed});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Card(
      child: ListTile(
        leading: Icon(Icons.air,
          color: allowed ? Colors.green : Colors.red),
        title: Text('$windMs m/s'),
        subtitle: Text(allowed
            ? loc.t('widgets.crane_allowed')
            : loc.t('widgets.crane_stop')),
      ),
    );
  }
}
