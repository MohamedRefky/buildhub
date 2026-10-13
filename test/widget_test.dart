import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/main.dart';

/// Boots the app with real JSON strings (read from disk — no hardcode).
/// Verifies Arabic default + English toggle both resolve from JSON.
///
/// NOTE: real disk IO must run inside tester.runAsync — the testWidgets
/// FakeAsync zone does not deliver real IO events to plain awaits.
void main() {
  testWidgets('BuildHub app boots with JSON localization', (
    WidgetTester tester,
  ) async {
    final loc = AppLocalization();
    // Hermetic: read JSON straight from disk instead of rootBundle.
    loc.stringsLoader = (p) => File(p).readAsString();
    await tester.runAsync(() => loc.load());

    await tester.pumpWidget(BuildHubApp(localization: loc));
    await tester.pumpAndSettle();

    // Default tab is Services — title must come from ar.json.
    expect(find.text('الخدمات'), findsWidgets);

    // Toggle to English — titles must come from en.json.
    await tester.runAsync(() => loc.toggleLanguage());
    await tester.pumpAndSettle();
    expect(find.text('Services'), findsWidgets);
  });
}
