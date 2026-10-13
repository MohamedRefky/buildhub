// Clean Architecture: Documents — Domain RFI workflow engine.
// Ports: RfiWorkflowEngine.kt — FIDIC-grade RFI state machine with
// mandatory-attachment checks and role-gated approvals. Pure Dart.

enum RfiWorkflowState {
  draft,
  submittedToContractor,
  pendingConsultantReview,
  infoRequested,
  approved,
  approvedWithComments,
  rejected,
  closed,
}

enum WorkflowUserRole { contractor, supervisor, consultant, owner }

enum RfiWorkflowAction { submit, approve, approveWithComments, requestInfo, reject, respond, close }

class WorkflowTransitionResult {
  final bool success;
  final RfiWorkflowState newState;
  final String messageAr;
  final String messageEn;
  const WorkflowTransitionResult({
    required this.success, required this.newState,
    required this.messageAr, required this.messageEn,
  });
}

class RfiWorkflowEngine {
  const RfiWorkflowEngine();

  static const _closedStates = {
    RfiWorkflowState.approved,
    RfiWorkflowState.approvedWithComments,
    RfiWorkflowState.rejected,
    RfiWorkflowState.closed,
  };

  WorkflowTransitionResult transitionState(
    RfiWorkflowState current,
    RfiWorkflowAction action,
    WorkflowUserRole userRole, {
    bool hasMandatoryAttachments = false,
  }) {
    if (_closedStates.contains(current)) {
      return const WorkflowTransitionResult(
        success: false, newState: RfiWorkflowState.closed,
        messageAr: 'الحالة نهائية ومغلقة — لا يمكن الانتقال منها',
        messageEn: 'Terminal closed state — no further transitions allowed',
      );
    }
    switch (action) {
      case RfiWorkflowAction.submit:
        if (current != RfiWorkflowState.draft &&
            current != RfiWorkflowState.infoRequested) {
          return _denied(current, 'التقديم متاح من المسودة أو بعد طلب معلومات فقط',
              'Submit is allowed from draft or info-requested only');
        }
        if (!hasMandatoryAttachments) {
          return _denied(current, 'التقديم يشترط المرفقات الإلزامية',
              'Submit requires mandatory attachments');
        }
        return const WorkflowTransitionResult(
          success: true, newState: RfiWorkflowState.pendingConsultantReview,
          messageAr: 'تم التقديم للمراجعة الاستشارية',
          messageEn: 'Submitted for consultant review',
        );
      case RfiWorkflowAction.approve:
      case RfiWorkflowAction.approveWithComments:
        if (userRole != WorkflowUserRole.consultant &&
            userRole != WorkflowUserRole.owner) {
          return _denied(current, 'الاعتماد حصري للاستشاري أو المالك',
              'Approval is restricted to consultant/owner');
        }
        if (current != RfiWorkflowState.pendingConsultantReview) {
          return _denied(current, 'الاعتماد يتطلب حالة بانتظار المراجعة',
              'Approval requires pending-review state');
        }
        return WorkflowTransitionResult(
          success: true,
          newState: action == RfiWorkflowAction.approve
              ? RfiWorkflowState.approved
              : RfiWorkflowState.approvedWithComments,
          messageAr: 'تم الاعتماد', messageEn: 'Approved',
        );
      case RfiWorkflowAction.requestInfo:
        if (current != RfiWorkflowState.pendingConsultantReview) {
          return _denied(current, 'طلب المعلومات يتطلب حالة بانتظار المراجعة',
              'Info requests require pending-review state');
        }
        return const WorkflowTransitionResult(
          success: true, newState: RfiWorkflowState.infoRequested,
          messageAr: 'تم طلب معلومات إضافية',
          messageEn: 'Additional information requested',
        );
      case RfiWorkflowAction.reject:
        if (current != RfiWorkflowState.pendingConsultantReview) {
          return _denied(current, 'الرفض يتطلب حالة بانتظار المراجعة',
              'Rejection requires pending-review state');
        }
        return const WorkflowTransitionResult(
          success: true, newState: RfiWorkflowState.rejected,
          messageAr: 'تم الرفض', messageEn: 'Rejected',
        );
      case RfiWorkflowAction.respond:
        if (current != RfiWorkflowState.infoRequested) {
          return _denied(current, 'الرد متاح بعد طلب المعلومات فقط',
              'Response is allowed after info request only');
        }
        return const WorkflowTransitionResult(
          success: true, newState: RfiWorkflowState.pendingConsultantReview,
          messageAr: 'تم الرد وإعادة التقديم للمراجعة',
          messageEn: 'Responded and resubmitted for review',
        );
      case RfiWorkflowAction.close:
        return const WorkflowTransitionResult(
          success: true, newState: RfiWorkflowState.closed,
          messageAr: 'تم الإغلاق', messageEn: 'Closed',
        );
    }
  }

  WorkflowTransitionResult _denied(
          RfiWorkflowState current, String ar, String en) =>
      WorkflowTransitionResult(
          success: false, newState: current,
          messageAr: ar, messageEn: en);
}
