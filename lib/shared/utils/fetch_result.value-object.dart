// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// The outcome of fetching a URL — an HTTP-like status code and the raw
/// response body, uniform across both the Dio and WebView fetch paths.
@immutable
class FetchResult extends Equatable {
  /// The HTTP-like status code, or `null` when the fetch failed outright.
  final int? statusCode;

  /// The raw response body, or an empty string on failure.
  final String body;

  const FetchResult({required this.statusCode, required this.body});

  @override
  List<Object?> get props => [statusCode, body];
}
