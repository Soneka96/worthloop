// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/utils/product_offer.value-object.dart';

/// The outcome of `ProductPriceFetchOrchestratorService.fetch` — the
/// classified status and, on success, the decoded [ProductOffer].
@immutable
class PriceFetchResult extends Equatable {
  /// The classified outcome of the fetch attempt.
  final PriceFetchStatus status;

  /// The decoded offer, present only when [status] is
  /// [PriceFetchStatus.success].
  final ProductOffer? offer;

  const PriceFetchResult({required this.status, required this.offer});

  @override
  List<Object?> get props => [status, offer];
}
