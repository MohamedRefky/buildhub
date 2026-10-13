// Port of ui/localization/LocalizationManager.kt
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum AppLanguage { arabic, english }
enum NumeralSystem { western, easternArabic }

class AppLocalization extends ChangeNotifier {
  AppLanguage language = AppLanguage.arabic;
  NumeralSystem numeralSystem = NumeralSystem.western;

  bool get isArabic => language == AppLanguage.arabic;
  bool get isRtl => isArabic;

  void toggleLanguage() {
    language = isArabic ? AppLanguage.english : AppLanguage.arabic;
    notifyListeners();
  }

  String tr(String ar, String en) => isArabic ? ar : en;

  String applyNumerals(String input) {
    if (numeralSystem == NumeralSystem.western) return input;
    const eastern = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
    return input.split('').map((ch) {
      final d = int.tryParse(ch);
      return d == null ? ch : eastern[d];
    }).join();
  }

  String formatNumber(num n) =>
      applyNumerals(NumberFormat('#,###', 'en_US').format(n));

  String formatAed(double amount) {
    final num = applyNumerals(NumberFormat('#,###', 'en_US').format(amount.toInt()));
    return isArabic ? '$num د.إ' : 'AED $num';
  }

  Locale get locale => isArabic ? const Locale('ar') : const Locale('en');
}
