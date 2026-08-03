// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/shared/constants/app_constants.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/popup_service.dart';

class MockLogger extends Mock implements Logger {}

class MockPopupService extends Mock implements PopupService {}

void main() {
  late MockLogger mockLogger;
  late MockPopupService mockPopupService;

  setUp(() {
    mockLogger = MockLogger();
    mockPopupService = MockPopupService();
  });

  group('LoggerService behaves correctly', () {
    test('d() calls Logger.d() with the exact message', () {
      LoggerService(mockLogger, mockPopupService).d('debug message');

      verify(() => mockLogger.d('debug message')).called(1);
      verifyNoMoreInteractions(mockLogger);
      verifyNever(() => mockPopupService.show(any()));
    });

    test('d() calls PopupService.show() when showPopup = true', () {
      LoggerService(
        mockLogger,
        mockPopupService,
      ).d('debug message', showPopup: true);

      verify(() => mockPopupService.show('debug message')).called(1);
    });

    test('i() calls Logger.i() with the exact message', () {
      LoggerService(mockLogger, mockPopupService).i('info message');

      verify(() => mockLogger.i('info message')).called(1);
      verifyNoMoreInteractions(mockLogger);
      verifyNever(() => mockPopupService.show(any()));
    });

    test('i() calls PopupService.show() when showPopup = true', () {
      LoggerService(
        mockLogger,
        mockPopupService,
      ).i('info message', showPopup: true);

      verify(() => mockPopupService.show('info message')).called(1);
    });

    test('w() calls Logger.w() with the exact message', () {
      LoggerService(mockLogger, mockPopupService).w('warning message');

      verify(() => mockLogger.w('warning message')).called(1);
      verifyNoMoreInteractions(mockLogger);
      verifyNever(() => mockPopupService.show(any()));
    });

    test('w() calls PopupService.show() when showPopup = true', () {
      LoggerService(
        mockLogger,
        mockPopupService,
      ).w('warning message', showPopup: true);

      verify(() => mockPopupService.show('warning message')).called(1);
    });

    test('e() calls Logger.e() with the exact message', () {
      LoggerService(mockLogger, mockPopupService).e('error message');

      verify(() => mockLogger.e('error message')).called(1);
      verifyNoMoreInteractions(mockLogger);
      verifyNever(() => mockPopupService.show(any()));
    });

    test('e() calls PopupService.show() when showPopup = true', () {
      LoggerService(
        mockLogger,
        mockPopupService,
      ).e('error message', showPopup: true);

      verify(() => mockPopupService.show('error message')).called(1);
    });

    test(
      'f() calls Logger.f() and PopupService.show() with the exact message',
      () {
        LoggerService(mockLogger, mockPopupService).f('fatal message');

        verify(() => mockLogger.f('fatal message')).called(1);
        verify(() => mockPopupService.show('fatal message')).called(1);
      },
    );

    test(
      'f() does not call PopupService.show() a second time for the same message within the dedupe window',
      () {
        final LoggerService loggerService = LoggerService(
          mockLogger,
          mockPopupService,
        );

        loggerService.f('fatal message');
        loggerService.f('fatal message');

        verify(() => mockPopupService.show('fatal message')).called(1);
      },
    );

    test(
      'f() calls PopupService.show() again for the same message after the dedupe window elapses',
      () {
        DateTime fakeNow = DateTime(2026, 1, 1, 12);
        final LoggerService loggerService = LoggerService(
          mockLogger,
          mockPopupService,
          now: () => fakeNow,
        );

        loggerService.f('fatal message');
        fakeNow = fakeNow.add(AlertConstants.alertDedupeWindow);
        loggerService.f('fatal message');

        verify(() => mockPopupService.show('fatal message')).called(2);
      },
    );

    test(
      'e() does not call PopupService.show() a second time for the same message within the dedupe window when showPopup = true',
      () {
        final LoggerService loggerService = LoggerService(
          mockLogger,
          mockPopupService,
        );

        loggerService.e('error message', showPopup: true);
        loggerService.e('error message', showPopup: true);

        verify(() => mockPopupService.show('error message')).called(1);
      },
    );
  });
}
