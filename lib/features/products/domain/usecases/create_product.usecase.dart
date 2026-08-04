// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/params/create_product.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Creates a tracked product and its website source.
class CreateProductUseCase
    extends UseCase<Either<Failure, Product>, CreateProductParams> {
  final IProductsRepository _repository;

  /// Creates a product use case backed by [IProductsRepository].
  CreateProductUseCase(this._repository);

  @override
  Future<Either<Failure, Product>> call(CreateProductParams params) async {
    final String name = params.name.trim();
    if (name.isEmpty) {
      return const Left(ValidationFailure('Product name is required'));
    }

    final DateTime createdAt = DateTime.now();
    final String productId = 'product-${createdAt.microsecondsSinceEpoch}';
    try {
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-$productId',
        productId: productId,
        url: params.url,
        createdAt: createdAt,
      );
      final Product product = Product(
        id: productId,
        name: name,
        storePrices: const [],
        lastUpdatedAt: createdAt,
      );
      return await _repository.createProduct(product, source);
    } on ArgumentError catch (error) {
      return Left(ValidationFailure(error.message.toString()));
    }
  }
}
