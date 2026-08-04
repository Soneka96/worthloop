// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/data/models/store_price.model.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Remote merchant-price lookup contract.
abstract class ProductsRemoteDatasource {
  /// Fetches the latest merchant offers for [product].
  Future<Either<Failure, List<StorePriceModel>>> fetchPrices(
    ProductModel product,
  );
}
