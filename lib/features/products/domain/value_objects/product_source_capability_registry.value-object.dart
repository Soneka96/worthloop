// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/product_source_capability.value-object.dart';

/// Resolves saved product sources to registered refresh capabilities.
class ProductSourceCapabilityRegistry {
  final Map<String, String> _adapterIdsByDomain;

  /// Creates a registry from lower-case merchant domains to adapter IDs.
  ProductSourceCapabilityRegistry({
    Map<String, String> adapterIdsByDomain = const {},
  }) : _adapterIdsByDomain = Map.unmodifiable(adapterIdsByDomain);

  /// Resolves the capability of [source] without contacting its website.
  ProductSourceCapability resolve(ProductSource source) {
    final String? adapterId = _adapterIdsByDomain[source.merchantDomain];
    return ProductSourceCapability(
      merchantDomain: source.merchantDomain,
      adapterId: adapterId,
    );
  }
}
