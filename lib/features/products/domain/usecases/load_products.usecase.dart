// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Loads tracked products through [IProductsRepository].
class LoadProductsUseCase
    extends UseCase<Either<Failure, List<Product>>, NoParams> {
  final IProductsRepository _repository;

  LoadProductsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) {
    return _repository.loadProducts();
  }
}
