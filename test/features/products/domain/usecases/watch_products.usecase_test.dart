// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/watch_products.usecase.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import '../../fixtures/product.fixture.dart';

class MockIProductsRepository extends Mock implements IProductsRepository {}

void main() {
  late MockIProductsRepository mockRepository;
  late WatchProductsUseCase useCase;

  setUp(() {
    mockRepository = MockIProductsRepository();
    useCase = WatchProductsUseCase(mockRepository);
  });

  group('Usecase WatchProductsUseCase returns the correct value', () {
    test('returns repository product emissions', () async {
      final List<Product> products = [buildProduct()];
      final List<Product> updatedProducts = [
        buildProduct(name: 'Updated Product'),
      ];
      when(
        () => mockRepository.watchProducts(),
      ).thenAnswer((_) => Stream.fromIterable([products, updatedProducts]));

      final List<List<Product>> result = await useCase(
        NoParams(),
      ).take(2).toList();

      expect(result, [products, updatedProducts]);
      verify(() => mockRepository.watchProducts()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
