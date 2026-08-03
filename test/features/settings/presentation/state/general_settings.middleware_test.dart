// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.middleware.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

class MockStore extends Mock implements Store<AppState> {}

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late List<dynamic> actionLog;
  late GeneralSettingsMiddleware middleware;
  late MockLoggerService mockLoggerService;
  late MockStore mockStore;

  void next(dynamic action) => actionLog.add(action);

  setUp(() {
    actionLog = [];
    middleware = GeneralSettingsMiddleware();
    mockLoggerService = MockLoggerService();
    mockStore = MockStore();
    sl.registerSingleton<LoggerService>(mockLoggerService);
  });

  tearDown(() async {
    await sl.reset();
    reset(mockLoggerService);
    reset(mockStore);
  });

  group('GeneralSettingsMiddleware processes CheckForUpdatesAction', () {
    test('calls i and forwards CheckForUpdatesAction', () {
      const CheckForUpdatesAction action = CheckForUpdatesAction();

      middleware.call(mockStore, action, next);

      expect(actionLog, [action]);
      verify(
        () => mockLoggerService.i(
          t.settings.general.updates.notImplemented,
          showPopup: true,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockLoggerService);
    });
  });

  group('GeneralSettingsMiddleware processes OpenPrivacyPolicyAction', () {
    test('calls i and forwards OpenPrivacyPolicyAction', () {
      const OpenPrivacyPolicyAction action = OpenPrivacyPolicyAction();

      middleware.call(mockStore, action, next);

      expect(actionLog, [action]);
      verify(
        () => mockLoggerService.i(
          t.settings.general.about.notImplemented,
          showPopup: true,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockLoggerService);
    });
  });

  group('GeneralSettingsMiddleware processes unhandled actions', () {
    test('does not call i and forwards the action', () {
      final Object action = Object();

      middleware.call(mockStore, action, next);

      expect(actionLog, [action]);
      verifyNever(
        () => mockLoggerService.i(
          t.settings.general.updates.notImplemented,
          showPopup: true,
        ),
      );
      verifyNever(
        () => mockLoggerService.i(
          t.settings.general.about.notImplemented,
          showPopup: true,
        ),
      );
    });
  });
}
