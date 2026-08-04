// Project imports:
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import 'package:worth_loop/features/products/domain/usecases/params/compare_prices.params.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Orders a product's available offers by exact minor-unit price.
class ComparePricesUseCase
    extends UseCase<List<StorePrice>, ComparePricesParams> {
  @override
  Future<List<StorePrice>> call(ComparePricesParams params) =>
      Future<List<StorePrice>>.value(params.product.availablePricesSorted);
}
