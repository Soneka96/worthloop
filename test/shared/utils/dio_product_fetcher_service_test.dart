// Package imports:
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/shared/utils/dio_product_fetcher_service.dart';
import 'package:worth_loop/shared/utils/fetch_result.value-object.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('DioProductFetcherService behaves correctly', () {
    late MockDio dio;
    late DioProductFetcherService service;
    const String url = 'https://example.com/product-1';

    setUp(() {
      dio = MockDio();
      service = DioProductFetcherService(dio);
      registerFallbackValue(Options());
    });

    test('returns the status code and body on a successful fetch', () async {
      when(
        () => dio.get<String>(url, options: any(named: 'options')),
      ).thenAnswer(
        (_) async => Response<String>(
          requestOptions: RequestOptions(path: url),
          statusCode: 200,
          data: '<html>ok</html>',
        ),
      );

      final FetchResult result = await service.fetch(url);

      expect(result, isA<FetchResult>());
      expect(result.statusCode, 200);
      expect(result.body, isA<String>());
      expect(result.body, '<html>ok</html>');
      verify(
        () => dio.get<String>(url, options: any(named: 'options')),
      ).called(1);
      verifyNoMoreInteractions(dio);
    });

    test(
      'returns a null status code when a successful response has none',
      () async {
        when(
          () => dio.get<String>(url, options: any(named: 'options')),
        ).thenAnswer(
          (_) async => Response<String>(
            requestOptions: RequestOptions(path: url),
            data: '<html>ok</html>',
          ),
        );

        final FetchResult result = await service.fetch(url);

        expect(result.statusCode, isNull);
      },
    );

    test('returns an empty body when a successful response has none', () async {
      when(
        () => dio.get<String>(url, options: any(named: 'options')),
      ).thenAnswer(
        (_) async => Response<String>(
          requestOptions: RequestOptions(path: url),
          statusCode: 200,
        ),
      );

      final FetchResult result = await service.fetch(url);

      expect(result.body, isA<String>());
      expect(result.body, '');
    });

    test(
      'returns the exception status code and body on a DioException with a response',
      () async {
        when(
          () => dio.get<String>(url, options: any(named: 'options')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: url),
            response: Response<String>(
              requestOptions: RequestOptions(path: url),
              statusCode: 403,
              data: 'Access denied',
            ),
          ),
        );

        final FetchResult result = await service.fetch(url);

        expect(result.statusCode, 403);
        expect(result.body, isA<String>());
        expect(result.body, 'Access denied');
        verify(
          () => dio.get<String>(url, options: any(named: 'options')),
        ).called(1);
        verifyNoMoreInteractions(dio);
      },
    );

    test(
      'returns an empty body on a DioException whose response has no data',
      () async {
        when(
          () => dio.get<String>(url, options: any(named: 'options')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: url),
            response: Response<String>(
              requestOptions: RequestOptions(path: url),
              statusCode: 500,
            ),
          ),
        );

        final FetchResult result = await service.fetch(url);

        expect(result.statusCode, 500);
        expect(result.body, isA<String>());
        expect(result.body, '');
      },
    );

    test(
      'returns a null status code and empty body on a DioException with no response',
      () async {
        when(
          () => dio.get<String>(url, options: any(named: 'options')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: url),
            type: DioExceptionType.connectionError,
          ),
        );

        final FetchResult result = await service.fetch(url);

        expect(result.statusCode, isNull);
        expect(result.body, isA<String>());
        expect(result.body, '');
        verify(
          () => dio.get<String>(url, options: any(named: 'options')),
        ).called(1);
        verifyNoMoreInteractions(dio);
      },
    );
  });
}
