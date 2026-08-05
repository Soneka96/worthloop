import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:worth_loop/shared/utils/retry_on_connection_error_interceptor.dart';

class MockDio extends Mock implements Dio {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

void main() {
  group('RetryOnConnectionErrorInterceptor behaves correctly', () {
    late MockDio dio;
    late MockErrorInterceptorHandler handler;
    late RetryOnConnectionErrorInterceptor interceptor;
    late RequestOptions requestOptions;

    setUp(() {
      dio = MockDio();
      handler = MockErrorInterceptorHandler();
      interceptor = RetryOnConnectionErrorInterceptor(dio);
      requestOptions = RequestOptions(path: '/test');
    });

    test('calls handler.next() when err.type is not retryable', () async {
      final DioException err = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionTimeout,
      );

      await interceptor.onError(err, handler);

      verify(() => handler.next(err)).called(1);
      verifyNoMoreInteractions(dio);
      verifyNoMoreInteractions(handler);
    });

    test('does not retry a request that was already retried', () async {
      requestOptions.extra['retry_on_connection_error_interceptor_attempted'] =
          true;
      final DioException err = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionError,
      );

      await interceptor.onError(err, handler);

      verify(() => handler.next(err)).called(1);
      verifyNoMoreInteractions(dio);
      verifyNoMoreInteractions(handler);
    });

    test('calls handler.resolve() when the retried request succeeds', () async {
      final DioException err = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionError,
      );
      final Response<dynamic> response = Response<dynamic>(
        requestOptions: requestOptions,
        statusCode: 200,
      );
      when(
        () => dio.fetch<dynamic>(requestOptions),
      ).thenAnswer((_) async => response);

      await interceptor.onError(err, handler);

      verify(() => dio.fetch<dynamic>(requestOptions)).called(1);
      verifyNoMoreInteractions(dio);
      verify(() => handler.resolve(response)).called(1);
      verifyNoMoreInteractions(handler);
    });

    test(
      'calls handler.next() with the retry failure when the retried request also throws',
      () async {
        final DioException err = DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.connectionError,
        );
        final DioException retryError = DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.connectionError,
        );
        when(() => dio.fetch<dynamic>(requestOptions)).thenThrow(retryError);

        await interceptor.onError(err, handler);

        verify(() => dio.fetch<dynamic>(requestOptions)).called(1);
        verifyNoMoreInteractions(dio);
        verify(() => handler.next(retryError)).called(1);
        verifyNoMoreInteractions(handler);
      },
    );
  });
}
