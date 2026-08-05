// Package imports:
import 'package:dio/dio.dart';

/// Retries a request once when it fails with a connection-level error (DNS
/// failure, connection refused) before surfacing the failure to the caller.
class RetryOnConnectionErrorInterceptor extends Interceptor {
  static const String _retryAttemptKey =
      'retry_on_connection_error_interceptor_attempted';

  final Dio _dio;

  /// Retries requests dispatched through [dio].
  RetryOnConnectionErrorInterceptor(this._dio);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.requestOptions.extra[_retryAttemptKey] == true ||
        (err.type != DioExceptionType.connectionError &&
            err.type != DioExceptionType.badResponse)) {
      return handler.next(err);
    }
    err.requestOptions.extra[_retryAttemptKey] = true;
    try {
      return handler.resolve(await _dio.fetch(err.requestOptions));
    } on DioException catch (retryError) {
      return handler.next(retryError);
    } finally {
      err.requestOptions.extra.remove(_retryAttemptKey);
    }
  }
}
