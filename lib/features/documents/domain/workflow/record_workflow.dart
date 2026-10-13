// Clean Architecture: Documents — Domain unified record workflow engine.
// Ports: WorkflowEngine.kt — executes RFI / SUBMITTED / VO / SNAG records
// with VO locking, content hashing and versioning. Pure Dart.
import 'dart:convert';
import 'package:crypto/crypto.dart';

enum RecordType { rfi, submitted, vo, snag }

enum RecordRole { engineer, foreman, consultant, ownerRep }

class SiteRecord {
  final String id;
  final String projectId;
  final String orgId;
  final RecordType type;
  final String number;
  final String title;
  final String status;
  final String createdBy;
  final String createdAt;
  final String updatedAt;
  final int version;
  final String? contentHash;
  const SiteRecord({
    required this.id, required this.projectId, required this.orgId,
    required this.type, required this.number, required this.title,
    required this.status, required this.createdBy,
    required this.createdAt, required this.updatedAt,
    this.version = 1, this.contentHash,
  });

  SiteRecord copyWith({String? status, String? updatedAt, int? version, String? contentHash}) =>
      SiteRecord(
        id: id, projectId: projectId, orgId: orgId, type: type,
        number: number, title: title, status: status ?? this.status,
        createdBy: createdBy, createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        version: version ?? this.version,
        contentHash: contentHash ?? this.contentHash,
      );
}

sealed class MoveResult {
  const MoveResult();
}

class MoveOk extends MoveResult {
  final SiteRecord record;
  const MoveOk(this.record);
}

class MoveDenied extends MoveResult {
  final String reasonAr;
  final String reasonEn;
  const MoveDenied(this.reasonAr, this.reasonEn);
}

class WorkflowEngine {
  static const locked = 'LOCKED';
  final String Function() timeProvider;

  WorkflowEngine({String Function()? timeProvider})
      : timeProvider = timeProvider ?? (() => DateTime.now().toIso8601String());

  MoveResult move(
    SiteRecord record,
    String targetStatus,
    String userId,
    RecordRole role, {
    String? comment,
  }) {
    if (record.status == locked) {
      return const MoveDenied('السجل مقفل — لا يمكن تعديله', 'Record is locked');
    }
    final now = timeProvider();
    switch (record.status) {
      case 'DRAFT':
        if (targetStatus == 'SUBMITTED' && role == RecordRole.engineer) {
          return MoveOk(record.copyWith(
              status: 'SUBMITTED', updatedAt: now, version: record.version + 1));
        }
        return const MoveDenied('التقديم من المسودة للمهندس فقط',
            'Submit from draft is engineer-only');
      case 'SUBMITTED':
        if (targetStatus == 'ANSWERED') {
          if (comment == null || comment.isEmpty) {
            return const MoveDenied('الرد يشترط تعليقاً غير فارغ',
                'Answer requires a non-empty comment');
          }
          if (role == RecordRole.consultant ||
              role == RecordRole.ownerRep ||
              role == RecordRole.engineer) {
            if (record.type == RecordType.vo) {
              return const MoveDenied(
                  'الأوامر التغييرية تعتمد ولا يُرد عليها هنا',
                  'VOs are approved, not answered, here');
            }
            return MoveOk(record.copyWith(
                status: 'ANSWERED', updatedAt: now, version: record.version + 1));
          }
          return const MoveDenied('دور غير مخول بالرد', 'Role cannot answer');
        }
        if (targetStatus == 'APPROVED' && record.type == RecordType.vo) {
          if (role != RecordRole.ownerRep && role != RecordRole.consultant) {
            return const MoveDenied(
                'اعتماد الأوامر التغييرية للمالك أو الاستشاري فقط',
                'VO approval is owner/consultant-only');
          }
          final hash =
              sha256.convert(utf8.encode('${record.id}_$now')).toString();
          return MoveOk(record.copyWith(
              status: locked, updatedAt: now,
              version: record.version + 1, contentHash: hash));
        }
        return MoveDenied('انتقال غير مسموح من SUBMITTED إلى $targetStatus',
            'Transition SUBMITTED → $targetStatus not allowed');
      default:
        return MoveDenied('انتقال غير مسموح من ${record.status}',
            'Transition from ${record.status} not allowed');
    }
  }
}
