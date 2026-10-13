// Clean Architecture: core environment isolation.
// Ports: EnvironmentConfig.kt — keeps demo seeds out of production and
// enforces strict role access outside DEV.
enum BuildEnvironment { dev, test, prod }

class EnvironmentConfig {
  static BuildEnvironment _current = BuildEnvironment.prod;

  static BuildEnvironment get current => _current;
  static void setEnvironment(BuildEnvironment env) => _current = env;

  static bool get isProduction => _current == BuildEnvironment.prod;
  static bool get isTest => _current == BuildEnvironment.test;

  /// Demo-data seeding is allowed in DEV only.
  static bool get allowDemoDataSeeding =>
      _current == BuildEnvironment.dev;

  static bool get enforceStrictRoleAccess =>
      _current == BuildEnvironment.prod || _current == BuildEnvironment.test;
}
