// Project imports:
import 'package:worth_loop/shared/usecase/no_params.dart';

/// Base class for all synchronous use cases.
///
/// [T] is the return type. [Params] is the input parameter object.
/// Use [NoParams] when the use case requires no input.
abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}
