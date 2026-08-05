// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/data/models/store_price.model.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Remote merchant-price lookup contract.
abstract class ProductsRemoteDatasource {
  /// Fetches the latest merchant offer for [source].
  Future<Either<Failure, List<StorePriceModel>>> fetchPrices(
    ProductSource source,
  );
}
