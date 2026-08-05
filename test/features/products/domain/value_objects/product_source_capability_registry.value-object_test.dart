// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/product_source_capability.value-object.dart';
import 'package:worth_loop/features/products/domain/value_objects/product_source_capability_registry.value-object.dart';

void main() {
  group('ProductSourceCapabilityRegistry.resolve', () {
    test('returns the adapter registered for a source domain', () {
      final ProductSourceCapabilityRegistry registry =
          ProductSourceCapabilityRegistry(
            adapterIdsByDomain: {'example.com': 'example-adapter'},
          );
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/products/1',
        createdAt: DateTime(2026),
      );

      final ProductSourceCapability capability = registry.resolve(source);

      expect(capability.merchantDomain, 'example.com');
      expect(capability.adapterId, 'example-adapter');
      expect(capability.isSupported, isTrue);
    });

    test('returns unsupported for an unregistered source domain', () {
      final ProductSourceCapabilityRegistry registry =
          ProductSourceCapabilityRegistry();
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://unknown.example/products/1',
        createdAt: DateTime(2026),
      );

      final ProductSourceCapability capability = registry.resolve(source);

      expect(capability.merchantDomain, 'unknown.example');
      expect(capability.adapterId, isNull);
      expect(capability.isSupported, isFalse);
    });

    test('does not retain a mutable registration map', () {
      final Map<String, String> adapterIdsByDomain = {
        'example.com': 'example-adapter',
      };
      final ProductSourceCapabilityRegistry registry =
          ProductSourceCapabilityRegistry(
            adapterIdsByDomain: adapterIdsByDomain,
          );
      adapterIdsByDomain['example.com'] = 'changed-adapter';
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/products/1',
        createdAt: DateTime(2026),
      );

      final ProductSourceCapability capability = registry.resolve(source);

      expect(capability.adapterId, 'example-adapter');
    });
  });
}
