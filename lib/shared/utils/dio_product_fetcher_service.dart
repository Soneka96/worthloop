// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import 'package:worth_loop/shared/utils/fetch_result.value-object.dart';

/// Fetches a product page's raw HTML via Dio. App-wide plumbing with no
/// business rule behind it — registered via DI, called from
/// `ProductPriceFetchOrchestratorService` only.
class DioProductFetcherService {
  final Dio _dio;

  DioProductFetcherService(this._dio);

  /// Fetches [url] and returns its status code and response body. On a
  /// [DioException], returns the exception's own status code/body instead
  /// of rethrowing, so the orchestrator can classify success/failure the
  /// same way for both this and the WebView fetcher.
  Future<FetchResult> fetch(String url) async {
    try {
      final Response<String> response = await _dio.get<String>(
        url,
        options: Options(responseType: ResponseType.plain),
      );
      return FetchResult(
        statusCode: response.statusCode,
        body: response.data ?? '',
      );
    } on DioException catch (error) {
      return FetchResult(
        statusCode: error.response?.statusCode,
        body: error.response?.data?.toString() ?? '',
      );
    }
  }
}
