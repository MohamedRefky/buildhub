// Clean Architecture: Planning — Data baseline lifecycle repository.
// Ports: AiBaselineRepository.kt — generate → review → edit → approve & lock
// (immutable after lock except via formal revision) + monitoring insight.
// In-memory now; Firestore wiring later.
import 'package:flutter/material.dart';
import '../../domain/entities/planning_entities.dart';
import '../datasources/baseline_generator.dart';

class BaselineOperationResult {
  final bool success;
  final String messageAr;
  final String messageEn;
  const BaselineOperationResult({
    required this.success, required this.messageAr, required this.messageEn,
  });
}

class BaselineRepository extends ChangeNotifier {
  List<BaselineActivity> activities = List.of(_sampleActivities);
  List<BaselineRevisionRecord> revisions = const [];
  BaselineStatus baselineStatus = BaselineStatus.approvedLocked;
  AiProjectMonitoringInsight monitoringInsight = const AiProjectMonitoringInsight(
    healthScore: 82, topRiskAr: 'المشتريات', topRiskEn: 'Procurement',
  );

  static const _sampleActivities = [
    BaselineActivity(id: 'ACT-001', wbsCode: '1.1', nameAr: 'الترسية والتعاقد',
        nameEn: 'Award & Contract', discipline: ActivityDiscipline.general,
        durationDays: 14, plannedStart: '2026-01-05', plannedFinish: '2026-01-18'),
    BaselineActivity(id: 'ACT-002', wbsCode: '1.2', nameAr: 'شهادات عدم الممانعة',
        nameEn: 'NOCs & Permits', discipline: ActivityDiscipline.general,
        predecessorId: 'ACT-001', durationDays: 30,
        plannedStart: '2026-01-19', plannedFinish: '2026-02-17'),
    BaselineActivity(id: 'ACT-003', wbsCode: '1.3', nameAr: 'التجهيز والتسوير',
        nameEn: 'Mobilization & Fencing', discipline: ActivityDiscipline.general,
        predecessorId: 'ACT-002', durationDays: 21,
        plannedStart: '2026-02-18', plannedFinish: '2026-03-10'),
    BaselineActivity(id: 'ACT-004', wbsCode: '2.1', nameAr: 'الجسات والأعمال الترابية',
        nameEn: 'Trial Pits & Earthworks', discipline: ActivityDiscipline.civil,
        predecessorId: 'ACT-003', durationDays: 25,
        plannedStart: '2026-03-11', plannedFinish: '2026-04-04'),
    BaselineActivity(id: 'ACT-005', wbsCode: '2.2', nameAr: 'الحفر والدعم',
        nameEn: 'Excavation & Shoring', discipline: ActivityDiscipline.civil,
        predecessorId: 'ACT-004', durationDays: 45,
        plannedStart: '2026-04-05', plannedFinish: '2026-05-19'),
    BaselineActivity(id: 'ACT-006', wbsCode: '2.3', nameAr: 'العزل واللبشة',
        nameEn: 'Waterproofing & Raft', discipline: ActivityDiscipline.structural,
        predecessorId: 'ACT-005', durationDays: 60, budgetAed: 12000000,
        plannedStart: '2026-05-20', plannedFinish: '2026-07-18'),
    BaselineActivity(id: 'ACT-007', wbsCode: '3.1', nameAr: 'تسليح 1850 طن',
        nameEn: 'Rebar 1850t', discipline: ActivityDiscipline.structural,
        predecessorId: 'ACT-006', durationDays: 75, budgetAed: 9500000,
        plannedStart: '2026-07-19', plannedFinish: '2026-10-01'),
    BaselineActivity(id: 'ACT-008', wbsCode: '3.2', nameAr: 'صب 12000 م³',
        nameEn: 'Concrete 12000m³', discipline: ActivityDiscipline.structural,
        predecessorId: 'ACT-007', durationDays: 60, budgetAed: 8400000,
        plannedStart: '2026-10-02', plannedFinish: '2026-11-30'),
    BaselineActivity(id: 'ACT-009', wbsCode: '4.1', nameAr: 'خط DN1500',
        nameEn: 'DN1500 Pipeline', discipline: ActivityDiscipline.mep,
        predecessorId: 'ACT-008', durationDays: 45,
        plannedStart: '2026-12-01', plannedFinish: '2027-01-14'),
    BaselineActivity(id: 'ACT-010', wbsCode: '4.2', nameAr: 'هيكل 30 طابق',
        nameEn: '30-Storey Structure', discipline: ActivityDiscipline.structural,
        predecessorId: 'ACT-009', durationDays: 90, budgetAed: 22000000,
        plannedStart: '2027-01-15', plannedFinish: '2027-04-14'),
    BaselineActivity(id: 'ACT-011', wbsCode: '5.1', nameAr: 'التسليم وشهادة الإنجاز',
        nameEn: 'Handover & BCC', discipline: ActivityDiscipline.testing,
        predecessorId: 'ACT-010', durationDays: 15,
        plannedStart: '2027-04-15', plannedFinish: '2027-04-29'),
  ];

  BaselineOperationResult generateBaselineFromAi(BaselineGenerationInput input) {
    final result = AiBaselineGeneratorService.synthesizeCompleteLifecycleBaseline(input);
    return result.when(
      success: (acts) {
        activities = acts;
        baselineStatus = BaselineStatus.draftAi;
        notifyListeners();
        return BaselineOperationResult(success: true,
            messageAr: 'تم توليد البيزلاين (${acts.length} نشاط) — بانتظار المراجعة',
            messageEn: 'Baseline generated (${acts.length} activities) — pending review');
      },
      failure: (errors) => BaselineOperationResult(success: false,
          messageAr: 'فشل التوليد: ${errors.join('، ')}',
          messageEn: 'Generation failed: ${errors.join(', ')}'),
    );
  }

  BaselineOperationResult submitForTeamReview() {
    if (baselineStatus == BaselineStatus.approvedLocked) {
      return const BaselineOperationResult(success: false,
          messageAr: 'البيزلاين معتمد ومقفل — التعديل بمراجعة رسمية فقط',
          messageEn: 'Baseline is approved & locked — formal revision only');
    }
    baselineStatus = BaselineStatus.underReview;
    notifyListeners();
    return const BaselineOperationResult(success: true,
        messageAr: 'تم التقديم لمراجعة الفريق', messageEn: 'Submitted for team review');
  }

  BaselineOperationResult editActivity(BaselineActivity updated) {
    if (baselineStatus == BaselineStatus.approvedLocked) {
      return const BaselineOperationResult(success: false,
          messageAr: 'انتهاك عدم القابلية للتعديل — البيزلاين مقفل',
          messageEn: 'IMMUTABILITY VIOLATION — baseline is locked');
    }
    final i = activities.indexWhere((a) => a.id == updated.id);
    if (i == -1) {
      return const BaselineOperationResult(success: false,
          messageAr: 'النشاط غير موجود', messageEn: 'Activity not found');
    }
    activities[i] = updated;
    CpmEngine.calculate(activities);
    notifyListeners();
    return const BaselineOperationResult(success: true,
        messageAr: 'تم تحديث النشاط وإعادة حساب المسار الحرج',
        messageEn: 'Activity updated and critical path recalculated');
  }

  BaselineOperationResult approveAndLockBaseline(String approverName) {
    if (activities.isEmpty) {
      return const BaselineOperationResult(success: false,
          messageAr: 'لا توجد أنشطة للاعتماد', messageEn: 'No activities to approve');
    }
    CpmEngine.calculate(activities);
    if (revisions.isEmpty) {
      revisions = [
        BaselineRevisionRecord(revId: 'REV-0', whatChangedAr: 'الاعتماد الأولي',
            whatChangedEn: 'Initial approval', reason: 'Baseline lock',
            requestedBy: approverName, approvedBy: approverName),
      ];
    }
    baselineStatus = BaselineStatus.approvedLocked;
    notifyListeners();
    return BaselineOperationResult(success: true,
        messageAr: 'تم الاعتماد والقفل بواسطة $approverName',
        messageEn: 'Approved and locked by $approverName');
  }

  void submitBaselineRevision(BaselineRevisionRecord rev) {
    revisions = [rev, ...revisions];
    baselineStatus = BaselineStatus.revision;
    notifyListeners();
  }

  void updateActivityProgress(String activityId, int newProgress, {String actualFinishDate = ''}) {
    final i = activities.indexWhere((a) => a.id == activityId);
    if (i == -1) return;
    final a = activities[i];
    activities[i] = BaselineActivity(
      id: a.id, wbsCode: a.wbsCode, nameAr: a.nameAr, nameEn: a.nameEn,
      discipline: a.discipline, predecessorId: a.predecessorId,
      dependencyType: a.dependencyType, durationDays: a.durationDays,
      plannedStart: a.plannedStart, plannedFinish: a.plannedFinish,
      budgetAed: a.budgetAed, actualProgressPercent: newProgress,
      actualFinish: newProgress >= 100 ? actualFinishDate : a.actualFinish,
      forecastFinish: a.forecastFinish,
    );
    notifyListeners();
  }

  ProjectScheduleAudit runDeterministicScheduleAudit() =>
      CpmEngine.analyzeScheduleDelays(activities);
}
