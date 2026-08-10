// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/params/refresh_source.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Queues one source for refresh through [IProductsRepository].
class RefreshSourceUseCase
    extends UseCase<Either<Failure, Unit>, RefreshSourceParams> {
  final IProductsRepository _repository;

  RefreshSourceUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(RefreshSourceParams params) {
    return _repository.enqueueSourceRefresh([
      params.sourceId,
    ], bypassCooldown: params.bypassCooldown);
  }
}
