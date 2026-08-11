// Package imports:
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// Project imports:
import 'package:worth_loop/shared/constants/price_fetch_constants.dart';
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
  /// single fixed delay, so a fast page returns as soon as it's rendered and
  /// a slow one still gets up to [PriceFetchConstants.webViewTotalTimeout]
  /// rather than being cut off early. That deadline bounds `run()` itself,
  /// not just the poll loop — otherwise a hung WebView load blocks this
  /// fetch, and every other source queued behind it on the same merchant,
  /// forever.
  static Future<String> _defaultHeadlessFetch(String url) async {
    String? html;
    final HeadlessInAppWebView headless = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onLoadStop: (controller, loadedUrl) async {
        await Future<void>.delayed(PriceFetchConstants.webViewJsRenderDelay);
        final dynamic outerHtml = await controller.evaluateJavascript(
          source: 'document.documentElement.outerHTML',
        );
        html = outerHtml as String? ?? '';
      },
    );
    final DateTime deadline = DateTime.now().add(
      PriceFetchConstants.webViewTotalTimeout,
    );
    try {
      await headless.run().timeout(PriceFetchConstants.webViewTotalTimeout);
      while (html == null && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(PriceFetchConstants.webViewPollInterval);
      }
      return html ?? '';
    } finally {
      await headless.dispose();
    }
  }
}
