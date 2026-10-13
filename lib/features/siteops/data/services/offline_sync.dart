// Clean Architecture: SiteOps — Data offline sync queue + snag worker.
// Ports: OfflineSyncManager.kt (in-memory queue + auto-sync on reconnect)
// and SyncWorker.kt (pending snags → Firestore with conflict handling).
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../documents/domain/entities/sync_entities.dart';

class SyncQueueItem {
  final String id;
  final String entityType;
  final String action;
  final String payloadJson;
  final String timestamp;
  const SyncQueueItem({
    required this.id, required this.entityType, required this.action,
    required this.payloadJson, required this.timestamp,
  });
}

class OfflineSyncManager extends ChangeNotifier {
  final List<SyncQueueItem> _queue = [];
  bool isOnline = true;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  int get pendingSyncCount => _queue.length;

  /// Constructor stays channel-free (test-safe). Call [startMonitoring]
  /// after first frame (AppShell) for live connectivity tracking.
  OfflineSyncManager();

  void startMonitoring() {
    if (_connectivitySub != null) return;
    try {
      _connectivitySub = Connectivity()
          .onConnectivityChanged
          .listen(
            (results) => setNetworkStatus(
                !results.contains(ConnectivityResult.none)),
            onError: (_) {},
            cancelOnError: false,
          );
    } catch (_) {}
  }

  void queueOfflineAction(
      String entityType, String action, String payloadJson) {
    _queue.add(SyncQueueItem(
      id: const Uuid().v4(), entityType: entityType, action: action,
      payloadJson: payloadJson,
      timestamp: DateTime.now().toIso8601String(),
    ));
    notifyListeners();
  }

  void setNetworkStatus(bool online) {
    final wasOffline = !isOnline && online;
    isOnline = online;
    notifyListeners();
    if (wasOffline) triggerBackgroundSync();
  }

  Future<void> triggerBackgroundSync() async {
    while (_queue.isNotEmpty && isOnline) {
      await Future.delayed(const Duration(milliseconds: 300));
      // TODO: dispatch _queue.first by entityType/action to repositories.
      _queue.removeAt(0);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
  }
}

abstract class SnagRemoteSource {
  Future<void> upsert(SnagEntity snag);
}

class FirestoreSnagRemoteSource implements SnagRemoteSource {
  @override
  Future<void> upsert(SnagEntity snag) async {
    // TODO: set() snags/{id} with id/projectId/title/status/severity/
    // location/updatedAt/version (see FirestorePaths.snagDoc).
  }
}

class SnagSyncWorker extends ChangeNotifier {
  final List<SnagEntity> _local;
  final SnagRemoteSource remote;

  SnagSyncWorker({List<SnagEntity>? local, SnagRemoteSource? remote})
      : _local = local ?? [],
        remote = remote ?? FirestoreSnagRemoteSource();

  List<SnagEntity> pending() => _local
      .where((s) => s.syncState == SyncState.pending)
      .toList();

  /// Mirrors SyncWorker.doSync: success → SYNCED, conflict → CONFLICT,
  /// IO → stop, other → FAILED.
  Future<bool> doSync() async {
    for (final snag in pending()) {
      try {
        await remote.upsert(snag);
        _mark(snag, SyncState.synced);
      } on ConflictException {
        _mark(snag, SyncState.conflict);
      } on IOException {
        return false;
      } catch (_) {
        _mark(snag, SyncState.failed);
      }
    }
    return true;
  }

  void _mark(SnagEntity snag, SyncState state) {
    final i = _local.indexWhere((s) => s.id == snag.id);
    if (i != -1) {
      _local[i] = snag.copyWith(
          syncState: state,
          updatedAt: DateTime.now().toIso8601String());
      notifyListeners();
    }
  }
}

class IOException implements Exception {
  final String message;
  const IOException([this.message = 'Transport failure']);
}
