// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Describes whether a product source has an automatic refresh adapter.
@immutable
class ProductSourceCapability extends Equatable {
  /// Lower-case merchant domain being described.
  final String merchantDomain;

  /// Identifier of the refresh adapter, or `null` when unsupported.
  final String? adapterId;

  const ProductSourceCapability({
    required this.merchantDomain,
    required this.adapterId,
  });

  /// Whether automatic price refresh is available for this source.
  bool get isSupported => adapterId != null;

  @override
  List<Object?> get props => [merchantDomain, adapterId];
}
