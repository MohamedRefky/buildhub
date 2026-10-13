// Clean Architecture: SitePulse — Data repository.
// Ports: SitePulseFirestoreRepository.kt + SitePulseModels.kt state.
import 'package:flutter/material.dart';

class SitePulseRepository extends ChangeNotifier {
  int initialTab = 0;
  int initialSubTab = 0;
  final List<Map<String, String>> snags = [];
  final List<Map<String, dynamic>> concreteTests = [];

  void openArea(int tab, int subTab) {
    initialTab = tab;
    initialSubTab = subTab;
    notifyListeners();
  }

  void addSnag(String title, String location) {
    snags.add({'title': title, 'location': location});
    notifyListeners();
  }
}
