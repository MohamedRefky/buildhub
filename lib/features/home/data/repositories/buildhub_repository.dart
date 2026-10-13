// Clean Architecture: Home feature — Data repository (shared project store).
// Port of data/repository/BuildHubRepository.kt — in-memory store
// backed by ChangeNotifier. Swap with sqflite/cloud_firestore later.
import 'package:flutter/material.dart';
import '../../domain/entities/home_entities.dart';

class BuildHubRepository extends ChangeNotifier {
  Project currentProject = Project.demo();

  final List<Project> projects = [Project.demo()];
  final List<AlertItem> alerts = [
    const AlertItem(
      id: 'a1',
      titleAr: 'تصريح صب خرسانة يقترب من الانتهاء',
      titleEn: 'Concrete pour permit expiring',
      detailAr: 'تصريح بلدية دبي ينتهي خلال ٣ أيام',
      detailEn: 'Dubai Municipality permit expires in 3 days',
      severity: AlertSeverity.critical,
      category: AlertCategory.permits,
      dateStr: '2026-10-13',
    ),
  ];
  final List<MaterialSubmittal> submittals = [];
  final List<PermitItem> permits = [];
  final List<SafetyTicket> safetyTickets = [];
  final List<FidicClaim> claims = [];
  final List<DailySiteLog> siteLogs = [];
  final HeatStressReading heatStress = const HeatStressReading();

  void resolveAlert(String id) {
    final i = alerts.indexWhere((a) => a.id == id);
    if (i != -1) {
      alerts[i] = AlertItem(
        id: alerts[i].id, titleAr: alerts[i].titleAr, titleEn: alerts[i].titleEn,
        detailAr: alerts[i].detailAr, detailEn: alerts[i].detailEn,
        severity: alerts[i].severity, category: alerts[i].category,
        dateStr: alerts[i].dateStr, isResolved: true,
      );
      notifyListeners();
    }
  }

  void addSiteLog(DailySiteLog log) {
    siteLogs.add(log);
    notifyListeners();
  }

  void selectProject(String id) {
    final found = projects.where((p) => p.id == id);
    if (found.isNotEmpty) {
      currentProject = found.first;
      notifyListeners();
    }
  }
}
