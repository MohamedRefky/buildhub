// Clean Architecture: Documents — Domain configurable workflows.
// Ports: EnterpriseWorkflowEngine.kt — config-driven workflow definitions
// for RFI / SUBMITTAL types with role-gated transitions. Pure Dart.

class WorkflowTransition {
  final String from;
  final String to;
  final Set<String> allowedRoles;
  final bool requiresSignature;
  const WorkflowTransition({
    required this.from, required this.to,
    required this.allowedRoles, this.requiresSignature = false,
  });
}

class WorkflowDef {
  final String type;
  final List<String> states;
  final List<WorkflowTransition> transitions;
  const WorkflowDef({
    required this.type, required this.states, required this.transitions,
  });

  bool canMove(String current, String target, String role) => transitions.any(
      (t) => t.from == current && t.to == target && t.allowedRoles.contains(role));
}

class StandardConstructionWorkflows {
  static const rfiWorkflow = WorkflowDef(
    type: 'RFI',
    states: ['DRAFT', 'PENDING_CONSULTANT', 'APPROVED', 'INFO_REQUESTED', 'REJECTED'],
    transitions: [
      WorkflowTransition(from: 'DRAFT', to: 'PENDING_CONSULTANT',
          allowedRoles: {'CONTRACTOR', 'SUPERVISOR'}),
      WorkflowTransition(from: 'PENDING_CONSULTANT', to: 'APPROVED',
          allowedRoles: {'CONSULTANT', 'OWNER'}, requiresSignature: true),
      WorkflowTransition(from: 'PENDING_CONSULTANT', to: 'INFO_REQUESTED',
          allowedRoles: {'CONSULTANT', 'OWNER'}),
      WorkflowTransition(from: 'PENDING_CONSULTANT', to: 'REJECTED',
          allowedRoles: {'CONSULTANT', 'OWNER'}, requiresSignature: true),
      WorkflowTransition(from: 'INFO_REQUESTED', to: 'PENDING_CONSULTANT',
          allowedRoles: {'CONTRACTOR', 'SUPERVISOR'}),
    ],
  );

  static const submittalWorkflow = WorkflowDef(
    type: 'SUBMITTAL',
    states: ['DRAFT', 'REVIEW', 'APPROVED_AS_NOTED', 'REJECTED'],
    transitions: [
      WorkflowTransition(from: 'DRAFT', to: 'REVIEW',
          allowedRoles: {'CONTRACTOR'}),
      WorkflowTransition(from: 'REVIEW', to: 'APPROVED_AS_NOTED',
          allowedRoles: {'CONSULTANT', 'ARCHITECT'}, requiresSignature: true),
      WorkflowTransition(from: 'REVIEW', to: 'REJECTED',
          allowedRoles: {'CONSULTANT', 'ARCHITECT'}, requiresSignature: true),
    ],
  );
}
