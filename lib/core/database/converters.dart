// Clean Architecture: core database converters.
// Ports: BuildHubConverters.kt — enum <-> string, bool <-> int and
// numeric guards shared by every DAO. Pure Dart.
class DbConverters {
  /// Enum lower-name encoding: `AlertSeverity.critical` -> 'critical'.
  static String e(Object? value) =>
      value?.toString().split('.').last ?? '';

  static T enums<T extends Enum>(
      Object? raw, List<T> values, T fallback) {
    final name = '$raw';
    for (final v in values) {
      if (v.name == name) return v;
    }
    return fallback;
  }

  static int i(bool value) => value ? 1 : 0;
  static bool b(Object? value) => (value as num?)?.toInt() == 1;
  static double d(Object? value) => (value as num?)?.toDouble() ?? 0;
  static int n(Object? value) => (value as num?)?.toInt() ?? 0;
  static String s(Object? value) => '${value ?? ''}';
}
