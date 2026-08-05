// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/value_objects/product_source_capability.value-object.dart';

void main() {
  group('ProductSourceCapability', () {
    test('isSupported is true when an adapter is registered', () {
      const ProductSourceCapability capability = ProductSourceCapability(
        merchantDomain: 'example.com',
        adapterId: 'example-adapter',
      );

      expect(capability.isSupported, isTrue);
    });

    test('isSupported is false without an adapter', () {
      const ProductSourceCapability capability = ProductSourceCapability(
        merchantDomain: 'unknown.example',
        adapterId: null,
      );

      expect(capability.isSupported, isFalse);
    });
  });
}
