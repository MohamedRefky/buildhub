// Clean Architecture: base UseCase contract.
// Mirrors Kotlin repository suspend functions + Flow use-cases.
import '../error/failures.dart';

abstract class UseCase<T, Params> {
  Future<(Failure?, T?)> call(Params params);
}

class NoParams {
  const NoParams();
}
