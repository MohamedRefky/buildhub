// Pure unit tests for the ported deterministic engines.
// No widgets, no platform channels — runs fast under `flutter test`.
import 'package:flutter_test/flutter_test.dart';
import 'package:buildhub/features/documents/domain/workflow/rfi_workflow.dart';
import 'package:buildhub/features/documents/domain/workflow/enterprise_workflow.dart';
import 'package:buildhub/features/documents/domain/workflow/record_workflow.dart';
import 'package:buildhub/features/documents/domain/audit/integrity_audit.dart';
import 'package:buildhub/features/planning/domain/entities/planning_entities.dart';
import 'package:buildhub/features/planning/data/datasources/baseline_generator.dart';
import 'package:buildhub/features/sitepulse/domain/entities/telemetry_entities.dart';
import 'package:buildhub/features/sitepulse/data/services/orion_service.dart';

void main() {
  group('RfiWorkflowEngine (FIDIC parity)', () {
    const engine = RfiWorkflowEngine();
    test('draft submit requires attachments', () {
      final denied = engine.transitionState(RfiWorkflowState.draft,
          RfiWorkflowAction.submit, WorkflowUserRole.contractor);
      expect(denied.success, isFalse);
      final ok = engine.transitionState(RfiWorkflowState.draft,
          RfiWorkflowAction.submit, WorkflowUserRole.contractor,
          hasMandatoryAttachments: true);
      expect(ok.success, isTrue);
      expect(ok.newState, RfiWorkflowState.pendingConsultantReview);
    });
    test('approval is consultant/owner only', () {
      final denied = engine.transitionState(
          RfiWorkflowState.pendingConsultantReview,
          RfiWorkflowAction.approve,
          WorkflowUserRole.contractor);
      expect(denied.success, isFalse);
      final ok = engine.transitionState(
          RfiWorkflowState.pendingConsultantReview,
          RfiWorkflowAction.approve,
          WorkflowUserRole.consultant);
      expect(ok.newState, RfiWorkflowState.approved);
    });
    test('terminal states reject transitions', () {
      final r = engine.transitionState(RfiWorkflowState.approved,
          RfiWorkflowAction.close, WorkflowUserRole.owner);
      expect(r.success, isFalse);
    });
    test('info request round-trip', () {
      final req = engine.transitionState(
          RfiWorkflowState.pendingConsultantReview,
          RfiWorkflowAction.requestInfo,
          WorkflowUserRole.consultant);
      expect(req.newState, RfiWorkflowState.infoRequested);
      final back = engine.transitionState(RfiWorkflowState.infoRequested,
          RfiWorkflowAction.respond, WorkflowUserRole.contractor);
      expect(back.newState, RfiWorkflowState.pendingConsultantReview);
    });
  });

  group('EnterpriseWorkflowEngine', () {
    test('rfi canMove gates roles', () {
      expect(
          StandardConstructionWorkflows.rfiWorkflow
              .canMove('DRAFT', 'PENDING_CONSULTANT', 'CONTRACTOR'),
          isTrue);
      expect(
          StandardConstructionWorkflows.rfiWorkflow
              .canMove('DRAFT', 'APPROVED', 'CONTRACTOR'),
          isFalse);
      expect(
          StandardConstructionWorkflows.submittalWorkflow
              .canMove('REVIEW', 'APPROVED_AS_NOTED', 'ARCHITECT'),
          isTrue);
    });
  });

  group('WorkflowEngine records + VO lock', () {
    SiteRecord draftVo() => SiteRecord(
          id: 'VO-1', projectId: 'p1', orgId: 'o1',
          type: RecordType.vo, number: 'VO-001', title: 'Variation',
          status: 'DRAFT', createdBy: 'u', createdAt: 't', updatedAt: 't',
        );
    test('draft submit is engineer-only', () {
      final engine = WorkflowEngine(timeProvider: () => 't');
      final denied = engine.move(
          draftVo(), 'SUBMITTED', 'u', RecordRole.foreman);
      expect(denied, isA<MoveDenied>());
      final ok = engine.move(
          draftVo(), 'SUBMITTED', 'u', RecordRole.engineer);
      expect(ok, isA<MoveOk>());
      expect((ok as MoveOk).record.version, 2);
    });
    test('VO approval locks with content hash', () {
      final engine = WorkflowEngine(timeProvider: () => 't');
      final submitted = (engine.move(draftVo(), 'SUBMITTED', 'u',
              RecordRole.engineer) as MoveOk)
          .record;
      final locked = engine.move(submitted, 'APPROVED', 'u',
          RecordRole.ownerRep);
      expect(locked, isA<MoveOk>());
      final rec = (locked as MoveOk).record;
      expect(rec.status, WorkflowEngine.locked);
      expect(rec.contentHash, isNotNull);
      final frozen = engine.move(rec, 'REJECTED', 'u',
          RecordRole.ownerRep);
      expect(frozen, isA<MoveDenied>());
    });
    test('answer requires non-empty comment', () {
      final engine = WorkflowEngine(timeProvider: () => 't');
      final rfi = SiteRecord(
          id: 'R-1', projectId: 'p1', orgId: 'o1',
          type: RecordType.rfi, number: 'RFI-1', title: 'Q',
          status: 'SUBMITTED', createdBy: 'u',
          createdAt: 't', updatedAt: 't');
      expect(
          engine.move(rfi, 'ANSWERED', 'u', RecordRole.consultant),
          isA<MoveDenied>());
      final ok = engine.move(rfi, 'ANSWERED', 'u',
          RecordRole.consultant, comment: 'see attached');
      expect(ok, isA<MoveOk>());
    });
  });

  group('CpmEngine (deterministic parity)', () {
    List<BaselineActivity> chain() => const [
          BaselineActivity(id: 'A', wbsCode: '1', nameAr: 'أ',
              nameEn: 'A', discipline: ActivityDiscipline.civil,
              durationDays: 5, plannedStart: '2026-01-01',
              plannedFinish: '2026-01-05'),
          BaselineActivity(id: 'B', wbsCode: '2', nameAr: 'ب',
              nameEn: 'B', discipline: ActivityDiscipline.civil,
              predecessorId: 'A', durationDays: 3,
              plannedStart: '2026-01-06', plannedFinish: '2026-01-08'),
        ];
    test('chain is fully critical with zero float', () {
      final nodes = CpmEngine.calculate(chain());
      expect(nodes['A']!.earlyFinish, 5);
      expect(nodes['B']!.earlyFinish, 8);
      expect(nodes['A']!.isCritical, isTrue);
      expect(nodes['B']!.isCritical, isTrue);
      expect(CpmEngine.criticalPath(nodes), ['A', 'B']);
    });
    test('delay within float has zero impact', () {
      const a = BaselineActivity(id: 'A', wbsCode: '1', nameAr: 'أ',
          nameEn: 'A', discipline: ActivityDiscipline.civil,
          durationDays: 5, plannedStart: '2026-01-01',
          plannedFinish: '2026-01-05');
      final r = CpmEngine.calculateActivityDelay(a, 6, 14);
      expect(r.criticalPathImpactDays, 0);
      expect(r.remainingTotalFloatDays, 8);
      final breach = CpmEngine.calculateActivityDelay(a, 20, 8);
      expect(breach.criticalPathImpactDays, 12);
      expect(breach.completionDateShifted, isTrue);
    });
    test('schedule audit summarizes slippage', () {
      final acts = [
        const BaselineActivity(id: 'A', wbsCode: '1', nameAr: 'أ',
            nameEn: 'A', discipline: ActivityDiscipline.civil,
            durationDays: 5, plannedStart: '2026-01-01',
            plannedFinish: '2026-01-05', forecastFinish: '2026-01-11'),
      ];
      final audit = CpmEngine.analyzeScheduleDelays(acts);
      expect(audit.totalActivities, 1);
      expect(audit.overallProjectDelayDays, 6);
      expect(audit.activityAnalyses.first.statusSummary,
          'CRITICAL_PATH_SLIP');
    });
  });

  group('DataIntegrityAuditEngine', () {
    const engine = DataIntegrityAuditEngine();
    test('flags all four issue classes', () {
      final report = engine.runSystemIntegrityCheck(
        vendors: const [
          {'id': 'v1', 'tradeLicenseNumber': 'L-1'},
          {'id': 'v2', 'tradeLicenseNumber': 'L-1'},
        ],
        activities: const [
          {'id': 'a1', 'predecessorId': 'ghost'},
        ],
        moneyDocs: const [
          {'id': 'q1', 'subtotalAed': 100, 'vatAed': 5, 'grandTotalAed': 200},
        ],
        purchaseOrders: const [
          {'id': 'po1', 'projectId': ''},
        ],
      );
      expect(report.totalIssuesFound, 4);
      expect(report.criticalIssuesCount, 2);
      expect(report.warningIssuesCount, 2);
      expect(report.isDatabaseHealthy, isFalse);
      final healed = engine.runAutoRemediation(report);
      expect(healed.issues.every((i) => i.isRemediated), isTrue);
    });
    test('clean data is healthy', () {
      final report = engine.runSystemIntegrityCheck(
        vendors: const [
          {'id': 'v1', 'tradeLicenseNumber': 'L-1'},
        ],
        moneyDocs: const [
          {'id': 'q1', 'subtotalAed': 100, 'vatAed': 5, 'grandTotalAed': 105},
        ],
      );
      expect(report.isDatabaseHealthy, isTrue);
    });
  });

  group('BaselineGenerator schema validation', () {
    const svc = AiBaselineGeneratorService();
    test('rejects bad payloads', () {
      final bad = svc.validateAndParseJsonSchema('not json');
      expect(bad, isA<BaselineValidationFailure>());
      final dup = svc.validateAndParseJsonSchema(
          '[{"id":"A","activityNameEn":"x","durationDays":2,'
          '"plannedStart":"2026-01-01","plannedFinish":"2026-01-02",'
          '"wbsCode":"1"},{"id":"A","activityNameEn":"y","durationDays":2,'
          '"plannedStart":"2026-01-01","plannedFinish":"2026-01-02",'
          '"wbsCode":"2"}]');
      expect(dup, isA<BaselineValidationFailure>());
    });
    test('accepts valid payload, flags ghost predecessor', () {
      final ghost = svc.validateAndParseJsonSchema(
          '[{"id":"A","activityNameEn":"x","durationDays":2,'
          '"plannedStart":"2026-01-01","plannedFinish":"2026-01-02",'
          '"wbsCode":"1","predecessorId":"ZZZ"}]');
      expect(ghost, isA<BaselineValidationFailure>());
    });
    test('deterministic fallback builds 10 activities', () {
      final res =
          AiBaselineGeneratorService.synthesizeCompleteLifecycleBaseline(
              const BaselineGenerationInput(
                  projectName: 'P', scopeOfWork: 'S',
                  plannedStartDate: '2026-01-01',
                  requiredCompletionDate: '2027-01-01'));
      expect(
          res.when(success: (a) => a.length, failure: (_) => -1), 10);
    });
  });

  group('OrionAiService thresholds', () {
    const svc = OrionAiService();
    const fleet = [
      FleetAsset(id: 'F1', callsign: 'C1', sector: 'A',
          status: 'ACTIVE', batteryPercent: 90),
    ];
    OrionTelemetryPacket packet(double temp, double grid) =>
        OrionTelemetryPacket(coreTemperature: temp,
            reactorStatus: ReactorStatus.nominal,
            powerGridEfficiency: grid, signalToNoiseRatio: 15,
            commsStatus: CommsStatus.locked, packetThroughput: 1000,
            chamberPressure: 101);
    test('nominal stays DEFCON 3', () {
      final a = svc.analyzeTelemetryAndSuggestDirectives(
          packet(50, 95), fleet);
      expect(a.defconLevel, 3);
      expect(a.recommendedDirective?.code, 'OB-118');
    });
    test('hot triggers DEFCON 2', () {
      final a = svc.analyzeTelemetryAndSuggestDirectives(
          packet(55, 95), fleet);
      expect(a.defconLevel, 2);
      expect(a.recommendedDirective?.code, 'OB-204');
    });
    test('critical triggers DEFCON 1', () {
      final a = svc.analyzeTelemetryAndSuggestDirectives(
          packet(61, 95), fleet);
      expect(a.defconLevel, 1);
      expect(a.recommendedDirective?.code, 'OB-909');
    });
  });
}
