// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/params/load_product_sources.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Loads every saved website source for one product.
class LoadProductSourcesUseCase
    extends
        UseCase<
          Either<Failure, List<ProductSource>>,
          LoadProductSourcesParams
        > {
  final IProductsRepository _repository;

  /// Creates a load-sources use case backed by [IProductsRepository].
  LoadProductSourcesUseCase(this._repository);

  @override
  Future<Either<Failure, List<ProductSource>>> call(
    LoadProductSourcesParams params,
  ) {
    return _repository.loadSourcesForProduct(params.productId);
  }
}
