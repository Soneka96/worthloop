// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/shared/utils/fetch_result.value-object.dart';
import 'package:worth_loop/shared/utils/webview_product_fetcher_service.dart';

class MockRunHeadlessFetch extends Mock {
  Future<String> call(String url);
}

void main() {
  group('WebViewProductFetcherService behaves correctly', () {
    const String url = 'https://example.com/product-1';
    late MockRunHeadlessFetch runHeadlessFetch;
    late WebViewProductFetcherService service;

    setUp(() {
      runHeadlessFetch = MockRunHeadlessFetch();
      service = WebViewProductFetcherService(
        runHeadlessFetch: runHeadlessFetch.call,
      );
    });

    test(
      'returns a 200 status code and the html when the fetch succeeds',
      () async {
        when(
          () => runHeadlessFetch(url),
        ).thenAnswer((_) async => '<html>ok</html>');

        final FetchResult result = await service.fetch(url);

        expect(result, isA<FetchResult>());
        expect(result.statusCode, isA<int>());
        expect(result.statusCode, 200);
        expect(result.body, isA<String>());
        expect(result.body, '<html>ok</html>');
        verify(() => runHeadlessFetch(url)).called(1);
        verifyNoMoreInteractions(runHeadlessFetch);
      },
    );

    test(
      'returns a null status code and empty body when the fetch returns empty html',
      () async {
        when(() => runHeadlessFetch(url)).thenAnswer((_) async => '');

        final FetchResult result = await service.fetch(url);

        expect(result.statusCode, isNull);
        expect(result.body, isA<String>());
        expect(result.body, '');
        verify(() => runHeadlessFetch(url)).called(1);
        verifyNoMoreInteractions(runHeadlessFetch);
      },
    );

    test(
      'returns a null status code and empty body when the fetch throws an Exception',
      () async {
        when(
          () => runHeadlessFetch(url),
        ).thenThrow(Exception('webview crashed'));

        final FetchResult result = await service.fetch(url);

        expect(result.statusCode, isNull);
        expect(result.body, isA<String>());
        expect(result.body, '');
        verify(() => runHeadlessFetch(url)).called(1);
        verifyNoMoreInteractions(runHeadlessFetch);
      },
    );

    test('lets a non-Exception error propagate uncaught', () async {
      when(() => runHeadlessFetch(url)).thenThrow(StateError('programmer bug'));

      expect(() => service.fetch(url), throwsA(isA<StateError>()));
    });
  });
}
