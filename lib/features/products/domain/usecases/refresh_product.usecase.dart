// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/params/refresh_product.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Refreshes one product through [IProductsRepository].
class RefreshProductUseCase
    extends UseCase<Either<Failure, Product>, RefreshProductParams> {
  final IProductsRepository _repository;

  RefreshProductUseCase(this._repository);

  @override
  Future<Either<Failure, Product>> call(RefreshProductParams params) {
    return _repository.refreshProduct(
      params.productId,
      onSourceStatusChanged: params.onSourceStatusChanged,
    );
  }
}
