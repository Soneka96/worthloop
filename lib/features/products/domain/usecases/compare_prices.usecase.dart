// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/usecases/params/compare_prices.params.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Orders a product's available offers by exact minor-unit price.
class ComparePricesUseCase
    extends UseCase<List<ProductSource>, ComparePricesParams> {
  @override
  Future<List<ProductSource>> call(ComparePricesParams params) =>
      Future<List<ProductSource>>.value(params.product.availablePricesSorted);
}
