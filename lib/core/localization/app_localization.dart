// Clean Architecture: JSON-based localization.
// Single source of truth: assets/lang/ar/strings.json + assets/lang/en/strings.json.
// UI code uses t('key') — no hardcoded bilingual literals in widgets.
// tr(ar, en) is kept ONLY for bilingual entity data coming from DB/Firestore
// (project names, alert titles...), never for static UI chrome.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

enum AppLanguage { arabic, english }
enum NumeralSystem { western, easternArabic }

class AppLocalization extends ChangeNotifier {
  AppLanguage language = AppLanguage.arabic;
  NumeralSystem numeralSystem = NumeralSystem.western;
  Map<String, String> _strings = {};

  /// Injectable asset loader (defaults to rootBundle).
  /// Tests override it with a dart:io File reader so no device bundle is needed.
  Future<String> Function(String path) stringsLoader = rootBundle.loadString;

  bool get isArabic => language == AppLanguage.arabic;
  bool get isRtl => isArabic;

  static const _base = 'assets/lang';

  Future<void> load() async {
    final folder = isArabic ? 'ar' : 'en';
    try {
      final raw = await stringsLoader(
        '$_base/$folder/strings.json',
      ).timeout(const Duration(seconds: 5));
      _strings = Map<String, String>.from(
        (json.decode(raw) as Map).map((k, v) => MapEntry('$k', '$v')),
      );
    } catch (_) {
      _strings = {};
    }
    notifyListeners();
  }

  /// Test/seed hook: inject a decoded strings map directly (no hardcode in app).
  void loadFromMap(Map<String, String> map) {
    _strings = Map.of(map);
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    language = isArabic ? AppLanguage.english : AppLanguage.arabic;
    await load();
  }

  /// Static UI string lookup. Returns the key itself when missing.
  String t(String key) => _strings[key] ?? key;

  /// Bilingual DB/entity data selector (NOT for static UI text).
  String tr(String ar, String en) => isArabic ? ar : en;

  String applyNumerals(String input) {
    if (numeralSystem == NumeralSystem.western) return input;
    const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return input.split('').map((ch) {
      final d = int.tryParse(ch);
      return d == null ? ch : eastern[d];
    }).join();
  }

  String formatNumber(num n) =>
      applyNumerals(NumberFormat('#,###', 'en_US').format(n));

  String formatAed(double amount) {
    final num =
        applyNumerals(NumberFormat('#,###', 'en_US').format(amount.toInt()));
    return isArabic ? '$num ${t('currency.aed')}' : '${t('currency.aed')} $num';
  }

  Locale get locale => isArabic ? const Locale('ar') : const Locale('en');
}
