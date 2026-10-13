// Clean Architecture: Planning — Data baseline generator service.
// Ports: AiBaselineGeneratorService.kt — strict JSON-schema validation +
// deterministic 10-activity lifecycle fallback. The Gemini REST prompt hook
// (buildGenerationPrompt) is preserved; network generation wires to
// GeminiService later. Pure Dart except ChangeNotifier-free.
import 'dart:convert';
import '../../domain/entities/planning_entities.dart';

sealed class BaselineValidationResult {
  const BaselineValidationResult();
  T when<T>({
    required T Function(List<BaselineActivity> activities) success,
    required T Function(List<String> errors) failure,
  }) {
    final self = this;
    if (self is BaselineValidationSuccess) return success(self.activities);
    return failure((self as BaselineValidationFailure).errors);
  }
}

class BaselineValidationSuccess extends BaselineValidationResult {
  final List<BaselineActivity> activities;
  const BaselineValidationSuccess(this.activities);
}

class BaselineValidationFailure extends BaselineValidationResult {
  final List<String> errors;
  const BaselineValidationFailure(this.errors);
}

class AiBaselineGeneratorService {
  const AiBaselineGeneratorService();

  /// Strict schema check mirroring the reference validator.
  BaselineValidationResult validateAndParseJsonSchema(String jsonString) {
    final errors = <String>[];
    dynamic decoded;
    try {
      final cleaned =
          jsonString.replaceAll('```json', '').replaceAll('```', '').trim();
      decoded = json.decode(cleaned);
    } catch (_) {
      return const BaselineValidationFailure(['Invalid JSON payload']);
    }
    if (decoded is! List) {
      return const BaselineValidationFailure(['Top-level JSON must be a list']);
    }
    final seenIds = <String>{};
    final activities = <BaselineActivity>[];
    for (var i = 0; i < decoded.length; i++) {
      final m = decoded[i];
      if (m is! Map) {
        errors.add('Item $i is not an object');
        continue;
      }
      final id = '${m['id'] ?? ''}';
      final nameEn = '${m['activityNameEn'] ?? m['nameEn'] ?? ''}';
      final duration = (m['durationDays'] as num?)?.toInt() ?? 0;
      final start = '${m['plannedStart'] ?? ''}';
      final finish = '${m['plannedFinish'] ?? ''}';
      final wbs = '${m['wbsCode'] ?? ''}';
      final pred = '${m['predecessorId'] ?? ''}';
      if (id.isEmpty) errors.add('Item $i: missing id');
      if (nameEn.isEmpty) errors.add('Item $i: missing activityNameEn');
      if (duration <= 0) errors.add('Item $i: durationDays must be > 0');
      if (start.isEmpty || finish.isEmpty) {
        errors.add('Item $i: plannedStart/plannedFinish required');
      }
      if (wbs.isEmpty) errors.add('Item $i: wbsCode required');
      if (id.isNotEmpty && !seenIds.add(id)) {
        errors.add('Duplicate id: $id');
      }
      if (pred.isNotEmpty && pred == id) {
        errors.add('Self-referencing predecessor: $id');
      }
      if (errors.isNotEmpty) continue;
      activities.add(BaselineActivity(
        id: id, wbsCode: wbs,
        nameAr: '${m['activityNameAr'] ?? m['nameAr'] ?? nameEn}',
        nameEn: nameEn, discipline: ActivityDiscipline.general,
        predecessorId: pred, durationDays: duration,
        plannedStart: start, plannedFinish: finish,
        budgetAed: (m['budgetAed'] as num?)?.toDouble() ?? 0,
      ));
    }
    // Predecessor existence check (second pass, like the reference).
    final ids = activities.map((a) => a.id).toSet();
    for (final a in activities) {
      if (a.predecessorId.isNotEmpty && !ids.contains(a.predecessorId)) {
        errors.add('Unknown predecessor ${a.predecessorId} for ${a.id}');
      }
    }
    if (errors.isNotEmpty) return BaselineValidationFailure(errors);
    return BaselineValidationSuccess(activities);
  }

  /// Prompt builder preserved for the future Gemini REST call.
  String buildGenerationPrompt(BaselineGenerationInput input) =>
      'Generate a construction baseline programme as JSON list for '
      '${input.projectName} (${input.scopeOfWork}), '
      'from ${input.plannedStartDate} to ${input.requiredCompletionDate}. '
      'Each item: id, wbsCode, activityNameEn, activityNameAr, durationDays, '
      'plannedStart, plannedFinish, predecessorId, budgetAed.';

  /// Deterministic 10-activity lifecycle fallback (reference parity).
  static BaselineValidationResult synthesizeCompleteLifecycleBaseline(
      BaselineGenerationInput input) {
    final s = input.plannedStartDate;
    List<BaselineActivity> mk(String id, String wbs, String ar, String en,
            int dur, String start, String finish, String pred) =>
        [
          BaselineActivity(id: id, wbsCode: wbs, nameAr: ar, nameEn: en,
              discipline: ActivityDiscipline.general, predecessorId: pred,
              durationDays: dur, plannedStart: start, plannedFinish: finish)
        ];
    final acts = [
      ...mk('ACT-001', '1.1', 'الترسية', 'Award', 14, s, s, ''),
      ...mk('ACT-002', '1.2', 'شهادات عدم الممانعة', 'NOCs', 30, s, s, 'ACT-001'),
      ...mk('ACT-003', '1.3', 'التجهيز', 'Mobilization', 21, s, s, 'ACT-002'),
      ...mk('ACT-004', '2.1', 'الجسات', 'Trial Pits', 25, s, s, 'ACT-003'),
      ...mk('ACT-005', '2.2', 'الحفر', 'Excavation', 45, s, s, 'ACT-004'),
      ...mk('ACT-006', '2.3', 'اللبشة C50', 'Raft C50', 60, s, s, 'ACT-005'),
      ...mk('ACT-007', '3.1', 'الهيكل', 'Superstructure', 90, s, s, 'ACT-006'),
      ...mk('ACT-008', '4.1', 'الأعمال الكهروميكانيكية', 'MEP', 45, s, s, 'ACT-007'),
      ...mk('ACT-009', '4.2', 'الاختبارات', 'Testing', 30, s, s, 'ACT-008'),
      ...mk('ACT-010', '5.1', 'شهادة الإنجاز', 'BCC', 15, s, s, 'ACT-009'),
    ];
    return BaselineValidationSuccess(acts);
  }
}
