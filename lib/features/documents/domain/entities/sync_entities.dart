// Clean Architecture: Documents — Domain sync entities.
// Ports: RecordEntity.kt, DailyReportEntity.kt, SnagEntity.kt (+SyncState).
// Sync-aware mirrors of Room entities for the offline-first pipeline.

enum SyncState { pending, synced, conflict, failed }

enum ReportStatus { draft, inReview, signed }

enum SnagSeverity { minor, major, critical }

class ConflictException implements Exception {
  final String message;
  const ConflictException(this.message);
  @override
  String toString() => 'ConflictException: $message';
}

class RecordEntity {
  final String id;
  final String projectId;
  final String orgId;
  final String type;
  final String number;
  final String title;
  final String status;
  final String createdBy;
  final String createdAt;
  final String updatedAt;
  final int version;
  final String? contentHash;
  final SyncState syncState;
  final String dueDate;
  final String comments;
  const RecordEntity({
    required this.id, required this.projectId, required this.orgId,
    required this.type, required this.number, required this.title,
    required this.status, required this.createdBy,
    required this.createdAt, required this.updatedAt,
    this.version = 1, this.contentHash,
    this.syncState = SyncState.pending,
    this.dueDate = '', this.comments = '',
  });

  RecordEntity copyWith({
    String? status, String? updatedAt, int? version, String? contentHash,
    SyncState? syncState, String? dueDate, String? comments,
  }) =>
      RecordEntity(
        id: id, projectId: projectId, orgId: orgId, type: type,
        number: number, title: title, status: status ?? this.status,
        createdBy: createdBy, createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        version: version ?? this.version,
        contentHash: contentHash ?? this.contentHash,
        syncState: syncState ?? this.syncState,
        dueDate: dueDate ?? this.dueDate,
        comments: comments ?? this.comments,
      );
}

class DailyReportEntity {
  final String id;
  final String projectId;
  final String date;
  final ReportStatus status;
  final String weatherJson;
  final String manpowerJson;
  final String activitiesJson;
  final String deliveriesJson;
  final String issuesJson;
  final String photosJson;
  final String instructionsJson;
  final String generatedBy;
  final String signedBy;
  final String signedAt;
  final String? contentHash;
  final SyncState syncState;
  final String updatedAt;
  final int version;
  const DailyReportEntity({
    required this.id, required this.projectId, required this.date,
    this.status = ReportStatus.draft,
    this.weatherJson = '{}', this.manpowerJson = '[]',
    this.activitiesJson = '[]', this.deliveriesJson = '[]',
    this.issuesJson = '[]', this.photosJson = '[]',
    this.instructionsJson = '[]',
    required this.generatedBy, this.signedBy = '', this.signedAt = '',
    this.contentHash,
    this.syncState = SyncState.pending,
    this.updatedAt = '', this.version = 1,
  });

  DailyReportEntity copyWith({
    ReportStatus? status, String? signedBy, String? signedAt,
    String? contentHash, SyncState? syncState,
    String? updatedAt, int? version,
  }) =>
      DailyReportEntity(
        id: id, projectId: projectId, date: date,
        status: status ?? this.status,
        weatherJson: weatherJson, manpowerJson: manpowerJson,
        activitiesJson: activitiesJson, deliveriesJson: deliveriesJson,
        issuesJson: issuesJson, photosJson: photosJson,
        instructionsJson: instructionsJson, generatedBy: generatedBy,
        signedBy: signedBy ?? this.signedBy,
        signedAt: signedAt ?? this.signedAt,
        contentHash: contentHash ?? this.contentHash,
        syncState: syncState ?? this.syncState,
        updatedAt: updatedAt ?? this.updatedAt,
        version: version ?? this.version,
      );
}

class SnagEntity {
  final String id;
  final String projectId;
  final String title;
  final String status;
  final SnagSeverity severity;
  final String location;
  final String updatedAt;
  final SyncState syncState;
  final int version;
  const SnagEntity({
    required this.id, required this.projectId, required this.title,
    required this.status, this.severity = SnagSeverity.major,
    this.location = 'Site', this.updatedAt = '',
    this.syncState = SyncState.pending, this.version = 0,
  });

  SnagEntity copyWith({
    String? status, String? updatedAt, SyncState? syncState, int? version,
  }) =>
      SnagEntity(
        id: id, projectId: projectId, title: title,
        status: status ?? this.status, severity: severity,
        location: location, updatedAt: updatedAt ?? this.updatedAt,
        syncState: syncState ?? this.syncState,
        version: version ?? this.version,
      );
}
