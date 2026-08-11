// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/params/refresh_product.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Queues one product's sources for refresh through [IProductsRepository].
class RefreshProductUseCase
    extends UseCase<Either<Failure, Unit>, RefreshProductParams> {
  final IProductsRepository _repository;

  RefreshProductUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(RefreshProductParams params) async {
    final Either<Failure, List<Product>> productsResult = await _repository
        .loadProducts();
    return productsResult.match((Failure failure) async => Left(failure), (
      List<Product> products,
    ) async {
      Product? product;
      for (final Product candidate in products) {
        if (candidate.id == params.productId) {
          product = candidate;
          break;
        }
      }
      final List<String> sourceIds = product == null
          ? const <String>[]
          : product.sources
                .map((ProductSource source) => source.id)
                .toList(growable: false);
      return _repository.enqueueSourceRefresh(sourceIds);
    });
  }
}
