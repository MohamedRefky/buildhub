import 'package:flutter_test/flutter_test.dart';
import 'package:buildhub/main.dart';

void main() {
  testWidgets('BuildHub app boots', (WidgetTester tester) async {
    await tester.pumpWidget(const BuildHubApp());
    await tester.pumpAndSettle();
    // Default tab is Services (الخدمات) like MainActivity.kt selectedTabIndex = 1
    expect(find.text('الخدمات'), findsWidgets);
  });
}
