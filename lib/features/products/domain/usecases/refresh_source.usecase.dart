// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/params/refresh_source.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Refreshes one source through [IProductsRepository].
class RefreshSourceUseCase
    extends UseCase<Either<Failure, Product>, RefreshSourceParams> {
  final IProductsRepository _repository;

  RefreshSourceUseCase(this._repository);

  @override
  Future<Either<Failure, Product>> call(RefreshSourceParams params) {
    return _repository.refreshSource(
      params.sourceId,
      onSourceStatusChanged: params.onSourceStatusChanged,
      bypassCooldown: params.bypassCooldown,
    );
  }
}
