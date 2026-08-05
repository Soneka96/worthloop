// Package imports:
import 'package:dio/dio.dart';

/// Retries a request once when it fails with a connection-level error (DNS
/// failure, connection refused) before surfacing the failure to the caller.
class RetryOnConnectionErrorInterceptor extends Interceptor {
  final Dio _dio;

  /// Retries requests dispatched through [dio].
  RetryOnConnectionErrorInterceptor(this._dio);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.type != DioExceptionType.connectionError) {
      return handler.next(err);
    }
    try {
      return handler.resolve(await _dio.fetch(err.requestOptions));
    } on DioException catch (retryError) {
      return handler.next(retryError);
    }
  }
}
