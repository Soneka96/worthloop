// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_remote.datasource.dart';
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/data/models/store_price.model.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/product_model.fixture.dart';
import '../../fixtures/store_price_model.fixture.dart';

class MockProductsRemoteDatasource extends Mock
    implements ProductsRemoteDatasource {}

void main() {
  group('Method fetchPrices() returns the correct value', () {
    test('fetchPrices() returns the remote offers', () async {
      final StorePriceModel existingOffer = buildStorePriceModel();
      final ProductModel product = buildProductModel(
        storePrices: [existingOffer],
      );
      final List<StorePriceModel> remoteOffers = [
        buildStorePriceModel(isAvailable: false),
      ];
      final ProductsRemoteDatasource datasource =
          MockProductsRemoteDatasource();
      when(
        () => datasource.fetchPrices(product),
      ).thenAnswer((_) async => Right(remoteOffers));

      final Either<Failure, List<StorePriceModel>> result = await datasource
          .fetchPrices(product);

      expect(result, Right(remoteOffers));
      verify(() => datasource.fetchPrices(product)).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('fetchPrices() returns the remote failure', () async {
      const NetworkFailure failure = NetworkFailure('failed');
      final ProductModel product = buildProductModel();
      final ProductsRemoteDatasource datasource =
          MockProductsRemoteDatasource();
      when(
        () => datasource.fetchPrices(product),
      ).thenAnswer((_) async => const Left(failure));

      final Either<Failure, List<StorePriceModel>> result = await datasource
          .fetchPrices(product);

      expect(result, const Left(failure));
      verify(() => datasource.fetchPrices(product)).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });
}
