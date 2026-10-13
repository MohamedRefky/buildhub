// Clean Architecture: Documents — Data row mappers.
// Entity <-> sqflite row conversions for the offline-first pipeline.
// Enums travel as names (see DbConverters), mirroring BuildHubConverters.
import 'package:buildhub/core/database/converters.dart';
import '../../domain/entities/sync_entities.dart';

class SyncMappers {
  static Map<String, Object?> recordToRow(RecordEntity r) => {
        'id': r.id, 'projectId': r.projectId, 'orgId': r.orgId,
        'type': r.type, 'number': r.number, 'title': r.title,
        'status': r.status, 'createdBy': r.createdBy,
        'createdAt': r.createdAt, 'updatedAt': r.updatedAt,
        'version': r.version, 'contentHash': r.contentHash,
        'syncState': DbConverters.e(r.syncState),
        'dueDate': r.dueDate, 'comments': r.comments,
      };

  static RecordEntity recordFromRow(Map<String, Object?> row) =>
      RecordEntity(
        id: DbConverters.s(row['id']),
        projectId: DbConverters.s(row['projectId']),
        orgId: DbConverters.s(row['orgId']),
        type: DbConverters.s(row['type']),
        number: DbConverters.s(row['number']),
        title: DbConverters.s(row['title']),
        status: DbConverters.s(row['status']),
        createdBy: DbConverters.s(row['createdBy']),
        createdAt: DbConverters.s(row['createdAt']),
        updatedAt: DbConverters.s(row['updatedAt']),
        version: DbConverters.n(row['version']),
        contentHash: row['contentHash']?.toString(),
        syncState: DbConverters.enums(
            row['syncState'], SyncState.values, SyncState.pending),
        dueDate: DbConverters.s(row['dueDate']),
        comments: DbConverters.s(row['comments']),
      );

  static Map<String, Object?> reportToRow(DailyReportEntity r) => {
        'id': r.id, 'projectId': r.projectId, 'date': r.date,
        'status': DbConverters.e(r.status),
        'weatherJson': r.weatherJson, 'manpowerJson': r.manpowerJson,
        'activitiesJson': r.activitiesJson,
        'deliveriesJson': r.deliveriesJson, 'issuesJson': r.issuesJson,
        'photosJson': r.photosJson,
        'instructionsJson': r.instructionsJson,
        'generatedBy': r.generatedBy, 'signedBy': r.signedBy,
        'signedAt': r.signedAt, 'contentHash': r.contentHash,
        'syncState': DbConverters.e(r.syncState),
        'updatedAt': r.updatedAt, 'version': r.version,
      };

  static DailyReportEntity reportFromRow(Map<String, Object?> row) =>
      DailyReportEntity(
        id: DbConverters.s(row['id']),
        projectId: DbConverters.s(row['projectId']),
        date: DbConverters.s(row['date']),
        status: DbConverters.enums(
            row['status'], ReportStatus.values, ReportStatus.draft),
        weatherJson: DbConverters.s(row['weatherJson']),
        manpowerJson: DbConverters.s(row['manpowerJson']),
        activitiesJson: DbConverters.s(row['activitiesJson']),
        deliveriesJson: DbConverters.s(row['deliveriesJson']),
        issuesJson: DbConverters.s(row['issuesJson']),
        photosJson: DbConverters.s(row['photosJson']),
        instructionsJson: DbConverters.s(row['instructionsJson']),
        generatedBy: DbConverters.s(row['generatedBy']),
        signedBy: DbConverters.s(row['signedBy']),
        signedAt: DbConverters.s(row['signedAt']),
        contentHash: row['contentHash']?.toString(),
        syncState: DbConverters.enums(
            row['syncState'], SyncState.values, SyncState.pending),
        updatedAt: DbConverters.s(row['updatedAt']),
        version: DbConverters.n(row['version']),
      );

  static Map<String, Object?> snagToRow(SnagEntity s) => {
        'id': s.id, 'projectId': s.projectId, 'title': s.title,
        'status': s.status,
        'severity': DbConverters.e(s.severity),
        'location': s.location, 'updatedAt': s.updatedAt,
        'syncState': DbConverters.e(s.syncState), 'version': s.version,
      };

  static SnagEntity snagFromRow(Map<String, Object?> row) => SnagEntity(
        id: DbConverters.s(row['id']),
        projectId: DbConverters.s(row['projectId']),
        title: DbConverters.s(row['title']),
        status: DbConverters.s(row['status']),
        severity: DbConverters.enums(
            row['severity'], SnagSeverity.values, SnagSeverity.major),
        location: DbConverters.s(row['location']),
        updatedAt: DbConverters.s(row['updatedAt']),
        syncState: DbConverters.enums(
            row['syncState'], SyncState.values, SyncState.pending),
        version: DbConverters.n(row['version']),
      );
}
