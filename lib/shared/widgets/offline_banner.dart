// Shared UI: offline-mode banner (Room cache notice).
// Text resolves from JSON — no hardcoded literals.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';

class OfflineBanner extends StatelessWidget {
  final bool isOffline;
  final VoidCallback onTap;
  const OfflineBanner({super.key, required this.isOffline, required this.onTap});
  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();
    final loc = context.watch<AppLocalization>();
    return MaterialBanner(
      content: Text(loc.t('widgets.offline_cached')),
      actions: [
        TextButton(onPressed: onTap, child: Text(loc.t('common.details')))
      ],
    );
  }
}
