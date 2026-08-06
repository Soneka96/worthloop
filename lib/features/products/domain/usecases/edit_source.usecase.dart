// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/params/edit_source.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Updates an existing source's URL, only once a fresh offer has been
/// fetched for it.
class EditSourceUseCase
    extends UseCase<Either<Failure, Product>, EditSourceParams> {
  final IProductsRepository _repository;

  /// Creates an edit-source use case backed by [IProductsRepository].
  EditSourceUseCase(this._repository);

  @override
  Future<Either<Failure, Product>> call(EditSourceParams params) {
    return _repository.updateSource(params.sourceId, params.url);
  }
}
