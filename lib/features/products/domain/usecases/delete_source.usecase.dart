// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/params/delete_source.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Deletes a saved source and returns the product without it.
class DeleteSourceUseCase
    extends UseCase<Either<Failure, Product>, DeleteSourceParams> {
  final IProductsRepository _repository;

  /// Creates a delete-source use case backed by [IProductsRepository].
  DeleteSourceUseCase(this._repository);

  @override
  Future<Either<Failure, Product>> call(DeleteSourceParams params) {
    return _repository.deleteSource(params.sourceId);
  }
}
