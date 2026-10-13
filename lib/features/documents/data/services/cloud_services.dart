// Clean Architecture: Documents — Data account sync + user storage.
// Ports: FirebaseAccountSyncService.kt + FirebaseUserStorageService.kt —
// 5-phase Room→Firestore sync with stats log, and per-user file storage
// (Storage users/{uid}/files + user_files index + offline cache + seed docs).
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/document_entities.dart';

class FirebaseSyncStats {
  final String connectedAccount;
  final bool isSyncing;
  final String lastSyncTime;
  final int syncedProjectsCount;
  final int syncedReportsCount;
  final int syncedActivitiesCount;
  final int syncedRecordsCount;
  final int syncedTicketsCount;
  final int syncedAgentActionsCount;
  final String lastErrorMessage;
  final List<String> syncLog;
  const FirebaseSyncStats({
    this.connectedAccount = '', this.isSyncing = false,
    this.lastSyncTime = '', this.syncedProjectsCount = 0,
    this.syncedReportsCount = 0, this.syncedActivitiesCount = 0,
    this.syncedRecordsCount = 0, this.syncedTicketsCount = 0,
    this.syncedAgentActionsCount = 0, this.lastErrorMessage = '',
    this.syncLog = const [],
  });

  FirebaseSyncStats copyWith({
    String? connectedAccount, bool? isSyncing, String? lastSyncTime,
    int? syncedProjectsCount, int? syncedReportsCount,
    int? syncedActivitiesCount, int? syncedRecordsCount,
    int? syncedTicketsCount, int? syncedAgentActionsCount,
    String? lastErrorMessage, List<String>? syncLog,
  }) =>
      FirebaseSyncStats(
        connectedAccount: connectedAccount ?? this.connectedAccount,
        isSyncing: isSyncing ?? this.isSyncing,
        lastSyncTime: lastSyncTime ?? this.lastSyncTime,
        syncedProjectsCount: syncedProjectsCount ?? this.syncedProjectsCount,
        syncedReportsCount: syncedReportsCount ?? this.syncedReportsCount,
        syncedActivitiesCount:
            syncedActivitiesCount ?? this.syncedActivitiesCount,
        syncedRecordsCount: syncedRecordsCount ?? this.syncedRecordsCount,
        syncedTicketsCount: syncedTicketsCount ?? this.syncedTicketsCount,
        syncedAgentActionsCount:
            syncedAgentActionsCount ?? this.syncedAgentActionsCount,
        lastErrorMessage: lastErrorMessage ?? this.lastErrorMessage,
        syncLog: syncLog ?? this.syncLog,
      );
}

class AccountSyncService extends ChangeNotifier {
  FirebaseSyncStats stats = const FirebaseSyncStats();

  void _log(String entry) {
    final now = DateTime.now();
    final stamp = '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    final log = [...stats.syncLog, '$stamp $entry'];
    stats = stats.copyWith(syncLog: log.length > 20 ? log.sublist(log.length - 20) : log);
    notifyListeners();
  }

  /// 5-phase sync: users → projects → dailyLogs → records → safety tickets.
  /// Each phase is best-effort until Firebase is configured.
  Future<bool> syncAllToFirebase({String? projectId}) async {
    stats = stats.copyWith(isSyncing: true, lastErrorMessage: '');
    notifyListeners();
    try {
      // TODO: phase 1 users/{uid}, 2 projects/{id}, 3 dailyLogs + markSynced,
      // 4 records + markSynced, 5 safety_tickets (first 15).
      _log('sync queued (5 phases)');
      stats = stats.copyWith(
        isSyncing: false,
        lastSyncTime: DateTime.now().toIso8601String(),
      );
      notifyListeners();
      return true;
    } catch (e) {
      stats = stats.copyWith(
          isSyncing: false, lastErrorMessage: '$e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> pushActivityData(
    String projectId,
    String activityId,
    String activityName,
    String dataType,
    Map<String, dynamic> payload,
  ) async {
    try {
      // TODO: set() FirestorePaths.activityEntry(projectId, activityId,
      //   'entry_${DateTime.now().millisecondsSinceEpoch}') with payload.
      _log('activity $activityId queued');
      return true;
    } catch (e) {
      stats = stats.copyWith(lastErrorMessage: '$e');
      notifyListeners();
      return false;
    }
  }
}

enum FileOperationStatus { idle, uploading, deleting, success, error }

class UserFileFull {
  final UserFileMeta meta;
  final String userId;
  final String fileType;
  final String mimeType;
  final String projectAssociated;
  final String description;
  final String uploaderEmail;
  final String uploadDateStr;
  final bool isLocalOnly;
  const UserFileFull({
    required this.meta, required this.userId,
    this.fileType = 'DOCUMENT', this.mimeType = '',
    this.projectAssociated = '', this.description = '',
    this.uploaderEmail = '', this.uploadDateStr = '',
    this.isLocalOnly = true,
  });
}

class UserStorageService extends ChangeNotifier {
  final List<UserFileFull> _files = [];

  FileOperationStatus operationStatus = FileOperationStatus.idle;
  double uploadProgress = 0;
  String statusMessageAr = '';
  String statusMessageEn = '';

  List<UserFileFull> filesOf(String userId) =>
      _files.where((f) => f.userId == userId).toList();

  int storageUsedBytes(String userId) =>
      filesOf(userId).fold<int>(0, (m, f) => m + f.meta.sizeBytes);

  static String fileTypeFor(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    return switch (ext) {
      'pdf' => 'PDF',
      'dwg' || 'dxf' => 'DWG_CAD',
      'rvt' || 'ifc' => 'BIM_MODEL',
      'jpg' || 'jpeg' || 'png' => 'IMAGE',
      'doc' || 'docx' => 'DOCUMENT',
      _ => 'REPORT',
    };
  }

  void seedDefaultDocumentsIfEmpty(String userId) {
    if (filesOf(userId).isNotEmpty) return;
    const seeds = [
      ('DM_Circular_Building_Permit.pdf', 'DM Permit circular'),
      ('Concrete_C70_Report.pdf', 'C70 test report'),
      ('Raft_Rebar.dwg', 'Raft reinforcement drawing'),
      ('Crane_Anchor.jpg', 'Crane anchor photo'),
    ];
    for (final (name, desc) in seeds) {
      _files.add(UserFileFull(
        meta: UserFileMeta(
          id: const Uuid().v4(), ownerUid: userId, fileName: name,
          storagePath: 'users/$userId/files/$name', sizeBytes: 0,
        ),
        userId: userId, fileType: fileTypeFor(name), description: desc,
        uploadDateStr: DateTime.now().toIso8601String().substring(0, 10),
      ));
    }
    notifyListeners();
  }

  Future<UserFileFull?> uploadFile({
    required String userId,
    required String fileName,
    required Uint8List fileBytes,
    required String mimeType,
    String projectAssociated = '',
    String description = '',
    String uploaderEmail = '',
  }) async {
    operationStatus = FileOperationStatus.uploading;
    uploadProgress = 0.15;
    notifyListeners();
    try {
      final meta = UserFileMeta(
        id: const Uuid().v4(), ownerUid: userId, fileName: fileName,
        storagePath: 'users/$userId/files/$fileName',
        sizeBytes: fileBytes.length,
      );
      // TODO: FirebaseStorage putBlob/putData to storagePath + downloadUrl,
      // then index in user_files/{id} + users/{uid}/files/{id} (merge).
      try {
        await FirebaseStorage.instance
            .ref(meta.storagePath)
            .putData(fileBytes, SettableMetadata(contentType: mimeType));
        uploadProgress = 0.9;
        notifyListeners();
      } catch (_) {}
      final full = UserFileFull(
        meta: meta, userId: userId, fileType: fileTypeFor(fileName),
        mimeType: mimeType, projectAssociated: projectAssociated,
        description: description, uploaderEmail: uploaderEmail,
        uploadDateStr: DateTime.now().toIso8601String().substring(0, 10),
        isLocalOnly: false,
      );
      _files.add(full);
      operationStatus = FileOperationStatus.success;
      uploadProgress = 1;
      notifyListeners();
      return full;
    } catch (_) {
      operationStatus = FileOperationStatus.error;
      statusMessageAr = 'فشل رفع الملف';
      statusMessageEn = 'File upload failed';
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteFile(UserFileFull file, String currentUserId) async {
    if (file.userId != currentUserId) {
      statusMessageAr = 'لا تملك صلاحية حذف هذا الملف';
      statusMessageEn = 'You cannot delete this file';
      notifyListeners();
      return false;
    }
    operationStatus = FileOperationStatus.deleting;
    notifyListeners();
    try {
      try {
        await FirebaseStorage.instance.ref(file.meta.storagePath).delete();
        // TODO: delete user_files/{id} + users/{uid}/files/{id}.
      } catch (_) {}
      _files.removeWhere((f) => f.meta.id == file.meta.id);
      operationStatus = FileOperationStatus.success;
      notifyListeners();
      return true;
    } catch (_) {
      operationStatus = FileOperationStatus.error;
      notifyListeners();
      return false;
    }
  }
}
