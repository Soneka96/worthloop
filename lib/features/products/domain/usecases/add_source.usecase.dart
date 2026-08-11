// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/params/add_source.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Attaches a new website source to an existing product, only once an offer
/// has been fetched for it.
class AddSourceUseCase
    extends UseCase<Either<Failure, Product>, AddSourceParams> {
  final IProductsRepository _repository;

  /// Creates an add-source use case backed by [IProductsRepository].
  AddSourceUseCase(this._repository);

  @override
  Future<Either<Failure, Product>> call(AddSourceParams params) async {
    final DateTime createdAt = DateTime.now();
    try {
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-${createdAt.microsecondsSinceEpoch}',
        productId: params.productId,
        url: params.url,
        createdAt: createdAt,
      );
      return await _repository.addSource(source);
    } on ArgumentError catch (error) {
      return Left(ValidationFailure(error.message.toString()));
    }
  }
}
