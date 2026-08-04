// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';

class MockIProductsRepository extends Mock implements IProductsRepository {}

void main() {
  group('IProductsRepository contract', () {
    test('can be implemented by a repository double', () {
      final IProductsRepository repository = MockIProductsRepository();

      expect(repository, isA<IProductsRepository>());
    });
  });
}
