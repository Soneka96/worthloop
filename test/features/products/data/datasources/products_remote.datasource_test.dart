// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_remote.datasource.dart';
import 'package:worth_loop/features/products/data/models/store_price.model.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/store_price_model.fixture.dart';

class MockProductsRemoteDatasource extends Mock
    implements ProductsRemoteDatasource {}

void main() {
  group('Method fetchPrices() returns the correct value', () {
    test('fetchPrices() returns the remote offers', () async {
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/product-1',
        createdAt: DateTime(2026),
      );
      final List<StorePriceModel> remoteOffers = [
        buildStorePriceModel(isAvailable: false),
      ];
      final ProductsRemoteDatasource datasource =
          MockProductsRemoteDatasource();
      when(
        () => datasource.fetchPrices(source),
      ).thenAnswer((_) async => Right(remoteOffers));

      final Either<Failure, List<StorePriceModel>> result = await datasource
          .fetchPrices(source);

      expect(result, Right(remoteOffers));
      verify(() => datasource.fetchPrices(source)).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('fetchPrices() returns the remote failure', () async {
      const NetworkFailure failure = NetworkFailure('failed');
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/product-1',
        createdAt: DateTime(2026),
      );
      final ProductsRemoteDatasource datasource =
          MockProductsRemoteDatasource();
      when(
        () => datasource.fetchPrices(source),
      ).thenAnswer((_) async => const Left(failure));

      final Either<Failure, List<StorePriceModel>> result = await datasource
          .fetchPrices(source);

      expect(result, const Left(failure));
      verify(() => datasource.fetchPrices(source)).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });
}
