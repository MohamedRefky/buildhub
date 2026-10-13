// Clean Architecture: Safety — Data repository.
// Ports: SafetyPassportDao + BuildHubRepository safety parts + heat-stress.
import 'package:flutter/material.dart';
import '../../domain/entities/safety_entities.dart';

class SafetyRepository extends ChangeNotifier {
  final List<SafetyPassport> passports = [];
  CraneWindReading wind = const CraneWindReading(
    windSpeedMs: 8.5, craneOperationAllowed: true,
    adviceAr: 'الرياح ضمن الحد الآمن للرافعات البرجية',
    adviceEn: 'Wind within safe tower-crane limits',
  );

  void addPassport(SafetyPassport p) {
    passports.add(p);
    notifyListeners();
    // TODO: persist via sqflite (SafetyPassportDao port) + Firestore.
  }

  void updateWind(CraneWindReading w) {
    wind = w;
    notifyListeners();
  }
}
