// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';

/// Watches tracked products through [IProductsRepository].
class WatchProductsUseCase {
  final IProductsRepository _repository;

  WatchProductsUseCase(this._repository);

  Stream<List<Product>> call(NoParams params) => _repository.watchProducts();
}
