// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/data/models/product_source.model.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/price_fetch_result.value-object.dart';
import 'package:worth_loop/shared/utils/product_offer.value-object.dart';
import 'package:worth_loop/shared/utils/product_price_fetch_orchestrator_service.dart';

/// Remote merchant-price lookup contract.
abstract class IProductsRemoteDatasource {
  /// Fetches the latest merchant offer for [source] and returns it applied
  /// to that same source.
  Future<Either<Failure, ProductSourceModel>> fetchPrices(
    ProductSource source,
  );
}

/// Implements [IProductsRemoteDatasource] via
/// [ProductPriceFetchOrchestratorService] (Dio first, falling back to a
/// headless WebView), mapping the result to this feature's
/// [ProductSourceModel]/[Failure] contract.
class ProductsRemoteDatasource implements IProductsRemoteDatasource {
  final ProductPriceFetchOrchestratorService _orchestrator;
  final LoggerService _loggerService;

  /// Creates a remote datasource backed by [_orchestrator].
  ProductsRemoteDatasource(this._orchestrator, this._loggerService);

  @override
  Future<Either<Failure, ProductSourceModel>> fetchPrices(
    ProductSource source,
  ) async {
    final PriceFetchResult result = await _orchestrator.fetch(source.url);
    final ProductOffer? offer = result.offer;
    if (result.status == PriceFetchStatus.success && offer != null) {
      return Right(
        ProductSourceModel(
          id: source.id,
          productId: source.productId,
          url: source.url,
          merchantDomain: source.merchantDomain,
          createdAt: source.createdAt,
          currentPrice: Money(
            minorUnits: offer.minorUnits,
            currencyCode: offer.currencyCode,
          ),
          isAvailable: offer.isAvailable,
          lastCheckedAt: DateTime.now(),
        ),
      );
    }
    final Failure failure = _failureFor(result.status);
    _loggerService.e(failure.message);
    return Left(failure);
  }

  Failure _failureFor(PriceFetchStatus status) => switch (status) {
    PriceFetchStatus.blocked => const PriceFetchFailure(
      status: PriceFetchStatus.blocked,
      message: 'Website blocked the price request',
    ),
    PriceFetchStatus.networkError => const PriceFetchFailure(
      status: PriceFetchStatus.networkError,
      message: 'Unable to fetch the product price',
    ),
    PriceFetchStatus.invalidData => const PriceFetchFailure(
      status: PriceFetchStatus.invalidData,
      message: 'Website returned invalid price data',
    ),
    PriceFetchStatus.unsupported => const PriceFetchFailure(
      status: PriceFetchStatus.unsupported,
      message: 'Website does not expose supported price data',
    ),
    PriceFetchStatus.success => const ValidationFailure(
      'Price fetch unexpectedly succeeded',
    ),
    PriceFetchStatus.none => const NetworkFailure('Price fetch did not run'),
  };
}
