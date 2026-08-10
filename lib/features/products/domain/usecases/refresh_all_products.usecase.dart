// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Queues every tracked product's sources for refresh through
/// [IProductsRepository].
class RefreshAllProductsUseCase
    extends UseCase<Either<Failure, Unit>, NoParams> {
  final IProductsRepository _repository;

  RefreshAllProductsUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    final Either<Failure, List<Product>> productsResult = await _repository
        .loadProducts();
    return productsResult.match((Failure failure) async => Left(failure), (
      List<Product> products,
    ) async {
      final List<String> sourceIds = products
          .expand((Product product) => product.sources)
          .map((ProductSource source) => source.id)
          .toList(growable: false);
      return _repository.enqueueSourceRefresh(sourceIds);
    });
  }
}
