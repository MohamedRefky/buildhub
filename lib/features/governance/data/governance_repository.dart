// Clean Architecture: Governance — Data repository.
// Ports: ApprovalEngineRepository.kt + ExceptionOverrideRepository.kt +
// OrionRoadmapRepository.kt + OrionGreenPassRepository.kt.
import 'package:flutter/material.dart';
import '../domain/entities/governance_entities.dart';

class GovernanceRepository extends ChangeNotifier {
  final List<ApprovalRequest> approvals = [];
  final List<ExceptionOverride> overrides = [];
  final List<RoadmapPhase> roadmap = List.generate(
    14,
    (i) => RoadmapPhase(
      index: i, titleAr: 'المرحلة ${i + 1}', titleEn: 'Phase ${i + 1}',
    ),
  );

  void decideApproval(String id, ApprovalStatus s) {
    final i = approvals.indexWhere((e) => e.id == id);
    if (i == -1) return;
    final a = approvals[i];
    approvals[i] = ApprovalRequest(
      id: a.id, titleAr: a.titleAr, titleEn: a.titleEn,
      requester: a.requester, status: s, level: a.level,
    );
    notifyListeners();
  }

  void addOverride(ExceptionOverride o) {
    overrides.add(o);
    notifyListeners();
  }
}
