// Package imports:
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// Project imports:
import 'package:worth_loop/shared/utils/fetch_result.value-object.dart';

/// Fetches a product page's rendered HTML via a headless WebView — the
/// fallback for sites that block Dio's non-browser request signature.
/// App-wide plumbing with no business rule behind it — registered via DI,
/// called from `ProductPriceFetchOrchestratorService` only.
class WebViewProductFetcherService {
  final Future<String> Function(String url) _runHeadlessFetch;

  /// [runHeadlessFetch] defaults to a real headless-WebView load — override
  /// only in tests, to exercise this service's status-derivation logic
  /// without touching the plugin.
  WebViewProductFetcherService({
    Future<String> Function(String url)? runHeadlessFetch,
  }) : _runHeadlessFetch = runHeadlessFetch ?? _defaultHeadlessFetch;

  static const Duration _jsRenderDelay = Duration(seconds: 2);
  static const Duration _pollInterval = Duration(milliseconds: 200);
  static const Duration _totalTimeout = Duration(seconds: 8);

  /// Fetches [url] in a headless browser and returns a synthesized status
  /// code (`200` if HTML came back, `null` otherwise) and the rendered
  /// outerHTML — matching [FetchResult]'s shape for the Dio fetcher.
  Future<FetchResult> fetch(String url) async {
    try {
      final String html = await _runHeadlessFetch(url);
      return FetchResult(statusCode: html.isEmpty ? null : 200, body: html);
    } on Exception {
      return const FetchResult(statusCode: null, body: '');
    }
  }

  /// Polls for the HTML captured by the `onLoadStop` callback instead of a
  /// single fixed delay, so a fast page returns as soon as it's rendered
  /// and a slow one still gets up to [_totalTimeout] rather than being cut
  /// off early.
  static Future<String> _defaultHeadlessFetch(String url) async {
    String? html;
    final HeadlessInAppWebView headless = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onLoadStop: (controller, loadedUrl) async {
        await Future<void>.delayed(_jsRenderDelay);
        final dynamic outerHtml = await controller.evaluateJavascript(
          source: 'document.documentElement.outerHTML',
        );
        html = outerHtml as String? ?? '';
      },
    );
    await headless.run();
    final DateTime deadline = DateTime.now().add(_totalTimeout);
    while (html == null && DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(_pollInterval);
    }
    await headless.dispose();
    return html ?? '';
  }
}
