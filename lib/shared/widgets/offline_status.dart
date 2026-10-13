// Shared UI: offline connectivity kit.
// Ports: OfflineStatusIndicator.kt — connectivity state, header chip,
// notice banner and cache-info dialog with isolated-site simulation.
// Labels resolve from JSON.
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';

enum ConnectivityUiState { onlineSynced, offlineRoomCached }

class OfflineScope extends ChangeNotifier {
  ConnectivityUiState state = ConnectivityUiState.onlineSynced;
  bool simulatedOffline = false;
  StreamSubscription<List<ConnectivityResult>>? _sub;

  bool get isOffline =>
      simulatedOffline || state == ConnectivityUiState.offlineRoomCached;

  /// Constructor stays channel-free so providers can be created in
  /// widget tests. Call [startMonitoring] after first frame (AppShell).
  OfflineScope();

  void startMonitoring() {
    if (_sub != null) return;
    try {
      _sub = Connectivity().onConnectivityChanged.listen(
        (results) {
          if (!simulatedOffline) {
            state = results.contains(ConnectivityResult.none)
                ? ConnectivityUiState.offlineRoomCached
                : ConnectivityUiState.onlineSynced;
            notifyListeners();
          }
        },
        onError: (_) {},
        cancelOnError: false,
      );
    } catch (_) {}
  }

  void setSimulatedOffline(bool value) {
    simulatedOffline = value;
    state = value
        ? ConnectivityUiState.offlineRoomCached
        : ConnectivityUiState.onlineSynced;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

class OfflineStatusChip extends StatelessWidget {
  final VoidCallback? onTap;
  const OfflineStatusChip({super.key, this.onTap});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final offline = context.watch<OfflineScope>().isOffline;
    return ActionChip(
      avatar: Icon(offline ? Icons.cloud_off : Icons.cloud_done, size: 14),
      label: Text(loc.t(offline
          ? 'widgets.off_chip_offline'
          : 'widgets.off_chip_synced')),
      onPressed: onTap ?? () {},
    );
  }
}

class OfflineNoticeBanner extends StatelessWidget {
  final VoidCallback? onViewCacheDetails;
  const OfflineNoticeBanner({super.key, this.onViewCacheDetails});
  @override
  Widget build(BuildContext context) {
    final offline = context.watch<OfflineScope>().isOffline;
    if (!offline) return const SizedBox.shrink();
    final loc = context.watch<AppLocalization>();
    return MaterialBanner(
      content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.t('widgets.off_title'),
                style: Theme.of(context).textTheme.titleSmall),
            Text(loc.t('widgets.off_body')),
          ]),
      actions: [
        TextButton(
            onPressed: onViewCacheDetails,
            child: Text(loc.t('common.details'))),
      ],
    );
  }
}

class OfflineCacheInfoDialog extends StatelessWidget {
  const OfflineCacheInfoDialog({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final scope = context.watch<OfflineScope>();
    final offline = scope.isOffline;
    return AlertDialog(
      title: Text(loc.t(offline
          ? 'widgets.off_dialog_offline'
          : 'widgets.off_dialog_online')),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(loc.t(offline
            ? 'widgets.off_current_off'
            : 'widgets.off_current_on')),
        const SizedBox(height: 6),
        Text(loc.t('widgets.off_desc')),
        SwitchListTile(
          title: Text(loc.t('widgets.off_simulate')),
          subtitle: Text(loc.t('widgets.off_simulate_desc')),
          value: scope.simulatedOffline,
          onChanged: scope.setSimulatedOffline,
        ),
      ]),
      actions: [
        TextButton(
            onPressed: () =>
                scope.setSimulatedOffline(!scope.simulatedOffline),
            child: Text(loc.t(scope.simulatedOffline
                ? 'widgets.off_go_online'
                : 'widgets.off_go_offline'))),
        ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.t('widgets.off_got_it'))),
      ],
    );
  }
}
