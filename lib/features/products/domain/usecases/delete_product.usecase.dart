// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/params/delete_product.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Deletes a product and its sources and offers.
class DeleteProductUseCase
    extends UseCase<Either<Failure, Unit>, DeleteProductParams> {
  final IProductsRepository _repository;

  /// Creates a delete-product use case backed by [IProductsRepository].
  DeleteProductUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteProductParams params) {
    return _repository.deleteProduct(params.productId);
  }
}
