// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/params/rename_product.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Renames an existing product.
class RenameProductUseCase
    extends UseCase<Either<Failure, Product>, RenameProductParams> {
  final IProductsRepository _repository;

  /// Creates a rename-product use case backed by [IProductsRepository].
  RenameProductUseCase(this._repository);

  @override
  Future<Either<Failure, Product>> call(RenameProductParams params) async {
    final String name = params.name.trim();
    if (name.isEmpty) {
      return const Left(ValidationFailure('Product name is required'));
    }
    return _repository.renameProduct(params.productId, name);
  }
}
