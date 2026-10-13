// Guards the no-hardcode rule: every loc.t() key used in lib/ must exist
// in BOTH language files, and both files must carry the same key set.
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ar/en strings share the exact key set', () async {
    Map<String, dynamic> read(String path) =>
        json.decode(File(path).readAsStringSync()) as Map<String, dynamic>;
    final ar = read('assets/lang/ar/strings.json');
    final en = read('assets/lang/en/strings.json');
    final arKeys = ar.keys.toSet();
    final enKeys = en.keys.toSet();
    expect(arKeys.difference(enKeys), isEmpty,
        reason: 'keys missing in en: ${arKeys.difference(enKeys)}');
    expect(enKeys.difference(arKeys), isEmpty,
        reason: 'keys missing in ar: ${enKeys.difference(arKeys)}');
    expect(arKeys.length, greaterThan(200));
  });

  test('every loc.t() key used in lib exists in strings', () async {
    final strings = json.decode(
            File('assets/lang/ar/strings.json').readAsStringSync())
        as Map<String, dynamic>;
    final used = <String>{};
    final keyPattern = RegExp("loc\\.t\\('([^']+)'\\)");
    final titleKeyPattern = RegExp("(titleKey|hintKey|bodyKey): '([^']+)'");
    const addCategories = [
      'blocker', 'workfront', 'action', 'inspection', 'rfi', 'commitment',
      'manpower', 'equipment', 'production', 'snag', 'variation', 'weather',
    ];
    final dir = Directory('lib');
    await for (final entity in dir.list(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final content = entity.readAsStringSync();
      for (final m in keyPattern.allMatches(content)) {
        final key = m.group(1)!;
        if (key.contains(r'${_categoryKey(_category)}')) {
          for (final c in addCategories) {
            used.add(key.replaceAll(
                r'${_categoryKey(_category)}', 'sp.add_$c'));
          }
        } else {
          used.add(key);
        }
      }
      for (final m in titleKeyPattern.allMatches(content)) {
        used.add(m.group(2)!);
      }
    }
    // Dynamic lookups: titleKey variables passed as constructor args.
    final missing = used.where((k) =>
        !strings.containsKey(k) && !k.contains(' ') && !k.contains(r'$'));
    expect(missing, isEmpty, reason: 'missing keys: $missing');
    expect(used.length, greaterThan(150));
  });
}
