// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/usecases/load_refresh_settings.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_browser_refresh_enabled.params.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_refresh_interval.params.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_browser_refresh_enabled.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_refresh_interval.usecase.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.middleware.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/utils/android_background_capabilities_service.dart';
import 'package:worth_loop/shared/utils/android_background_refresh_service.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import '../../fixtures/refresh_settings.fixture.dart';

class MockStore extends Mock implements Store<AppState> {}

class MockLoggerService extends Mock implements LoggerService {}

class MockLoadRefreshSettingsUseCase extends Mock
    implements LoadRefreshSettingsUseCase {}

class MockSaveRefreshIntervalUseCase extends Mock
    implements SaveRefreshIntervalUseCase {}

class MockSaveBrowserRefreshEnabledUseCase extends Mock
    implements SaveBrowserRefreshEnabledUseCase {}

class MockAndroidBackgroundCapabilitiesService extends Mock
    implements AndroidBackgroundCapabilitiesService {}

class MockAndroidBackgroundRefreshService extends Mock
    implements AndroidBackgroundRefreshService {}

class FakeSaveRefreshIntervalParams extends Fake
    implements SaveRefreshIntervalParams {}

class FakeSaveBrowserRefreshEnabledParams extends Fake
    implements SaveBrowserRefreshEnabledParams {}

void main() {
  late List<dynamic> actionLog;
  late GeneralSettingsMiddleware middleware;
  late MockLoggerService mockLoggerService;
  late MockStore mockStore;
  late MockLoadRefreshSettingsUseCase mockLoadUseCase;
  late MockSaveRefreshIntervalUseCase mockSaveUseCase;
  late MockSaveBrowserRefreshEnabledUseCase mockSaveBrowserRefreshUseCase;
  late MockAndroidBackgroundCapabilitiesService mockCapabilitiesService;
  late MockAndroidBackgroundRefreshService mockBackgroundRefreshService;

  void next(dynamic action) => actionLog.add(action);

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(FakeSaveRefreshIntervalParams());
    registerFallbackValue(FakeSaveBrowserRefreshEnabledParams());
  });

  setUp(() {
    actionLog = [];
    middleware = GeneralSettingsMiddleware();
    mockLoggerService = MockLoggerService();
    mockStore = MockStore();
    mockLoadUseCase = MockLoadRefreshSettingsUseCase();
    mockSaveUseCase = MockSaveRefreshIntervalUseCase();
    mockSaveBrowserRefreshUseCase = MockSaveBrowserRefreshEnabledUseCase();
    mockCapabilitiesService = MockAndroidBackgroundCapabilitiesService();
    mockBackgroundRefreshService = MockAndroidBackgroundRefreshService();
    when(() => mockStore.dispatch(any())).thenAnswer(
      (Invocation invocation) =>
          actionLog.add(invocation.positionalArguments.first),
    );
    sl.registerSingleton<LoggerService>(mockLoggerService);
    sl.registerSingleton<LoadRefreshSettingsUseCase>(mockLoadUseCase);
    sl.registerSingleton<SaveRefreshIntervalUseCase>(mockSaveUseCase);
    sl.registerSingleton<SaveBrowserRefreshEnabledUseCase>(
      mockSaveBrowserRefreshUseCase,
    );
    sl.registerSingleton<AndroidBackgroundCapabilitiesService>(
      mockCapabilitiesService,
    );
    sl.registerSingleton<AndroidBackgroundRefreshService>(
      mockBackgroundRefreshService,
    );
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

  group('GeneralSettingsMiddleware processes LoadRefreshSettingsAction', () {
    test('dispatches RefreshSettingsLoadedAction when successful', () async {
      when(
        () => mockLoadUseCase(any()),
      ).thenAnswer((_) async => Right(buildRefreshSettings()));

      middleware.call(mockStore, const LoadRefreshSettingsAction(), next);
      await Future<void>.delayed(Duration.zero);

      expect(actionLog[0], isA<LoadRefreshSettingsAction>());
      expect(actionLog[1], isA<RefreshSettingsLoadedAction>());
      expect(
        (actionLog[1] as RefreshSettingsLoadedAction).settings,
        buildRefreshSettings(),
      );
      final VerificationResult verification = verify(
        () => mockLoadUseCase(captureAny()),
      )..called(1);
      expect(verification.captured.single, isA<NoParams>());
      verifyNoMoreInteractions(mockLoadUseCase);
      verifyZeroInteractions(mockLoggerService);
    });

    test('dispatches RefreshSettingsLoadFailedAction when failed', () async {
      const DatabaseFailure failure = DatabaseFailure('failed');
      when(
        () => mockLoadUseCase(any()),
      ).thenAnswer((_) async => const Left(failure));

      middleware.call(mockStore, const LoadRefreshSettingsAction(), next);
      await Future<void>.delayed(Duration.zero);

      expect(actionLog[1], const RefreshSettingsLoadFailedAction('failed'));
      final VerificationResult verification = verify(
        () => mockLoadUseCase(captureAny()),
      )..called(1);
      expect(verification.captured.single, isA<NoParams>());
      verifyNoMoreInteractions(mockLoadUseCase);
      verify(() => mockLoggerService.e('failed', showPopup: true)).called(1);
      verifyNoMoreInteractions(mockLoggerService);
    });
  });

  group('GeneralSettingsMiddleware processes SaveRefreshIntervalAction', () {
    test('dispatches RefreshIntervalSavedAction when successful', () async {
      when(() => mockSaveUseCase(any())).thenAnswer(
        (_) async => Right(buildRefreshSettings(intervalMinutes: 180)),
      );

      middleware.call(mockStore, const SaveRefreshIntervalAction(180), next);
      await Future<void>.delayed(Duration.zero);

      expect(actionLog[0], isA<SaveRefreshIntervalAction>());
      expect(actionLog[1], const RefreshIntervalSavedAction(180));
      verify(
        () => mockSaveUseCase(
          const SaveRefreshIntervalParams(intervalMinutes: 180),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockSaveUseCase);
      verifyZeroInteractions(mockLoggerService);
    });

    test('dispatches RefreshIntervalSaveFailedAction when failed', () async {
      const DatabaseFailure failure = DatabaseFailure('failed');
      when(
        () => mockSaveUseCase(any()),
      ).thenAnswer((_) async => const Left(failure));

      middleware.call(mockStore, const SaveRefreshIntervalAction(180), next);
      await Future<void>.delayed(Duration.zero);

      expect(actionLog[1], const RefreshIntervalSaveFailedAction('failed'));
      verify(
        () => mockSaveUseCase(
          const SaveRefreshIntervalParams(intervalMinutes: 180),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockSaveUseCase);
      verify(() => mockLoggerService.e('failed', showPopup: true)).called(1);
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

  group(
    'GeneralSettingsMiddleware processes SaveBrowserRefreshEnabledAction',
    () {
      test(
        'dispatches BrowserRefreshEnabledSavedAction when successful',
        () async {
          when(() => mockSaveBrowserRefreshUseCase(any())).thenAnswer(
            (_) async =>
                Right(buildRefreshSettings(browserRefreshEnabled: true)),
          );
          when(
            () => mockBackgroundRefreshService.start(),
          ).thenAnswer((_) async => true);

          middleware.call(
            mockStore,
            const SaveBrowserRefreshEnabledAction(true),
            next,
          );
          await Future<void>.delayed(Duration.zero);

          expect(actionLog[0], isA<SaveBrowserRefreshEnabledAction>());
          expect(actionLog[1], const BrowserRefreshEnabledSavedAction(true));
          verify(
            () => mockSaveBrowserRefreshUseCase(
              const SaveBrowserRefreshEnabledParams(enabled: true),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockSaveBrowserRefreshUseCase);
          verify(() => mockBackgroundRefreshService.start()).called(1);
          verifyNoMoreInteractions(mockBackgroundRefreshService);
          verifyZeroInteractions(mockLoggerService);
        },
      );

      test('dispatches BrowserRefreshSaveFailedAction when failed', () async {
        const DatabaseFailure failure = DatabaseFailure('failed');
        when(
          () => mockSaveBrowserRefreshUseCase(any()),
        ).thenAnswer((_) async => const Left(failure));

        middleware.call(
          mockStore,
          const SaveBrowserRefreshEnabledAction(false),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[1], const BrowserRefreshSaveFailedAction('failed'));
        verify(
          () => mockSaveBrowserRefreshUseCase(
            const SaveBrowserRefreshEnabledParams(enabled: false),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockSaveBrowserRefreshUseCase);
        verifyNever(() => mockBackgroundRefreshService.start());
        verifyNoMoreInteractions(mockBackgroundRefreshService);
        verify(() => mockLoggerService.e('failed', showPopup: true)).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      });
    },
  );

  group(
    'GeneralSettingsMiddleware processes OpenBackgroundRestrictionsAction',
    () {
      test('opens Android background settings', () async {
        when(
          () => mockCapabilitiesService.openBatterySettings(),
        ).thenAnswer((_) async => true);

        middleware.call(
          mockStore,
          const OpenBackgroundRestrictionsAction(),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        expect(actionLog, [const OpenBackgroundRestrictionsAction()]);
        verify(() => mockCapabilitiesService.openBatterySettings()).called(1);
        verifyNoMoreInteractions(mockCapabilitiesService);
      });
    },
  );
}
