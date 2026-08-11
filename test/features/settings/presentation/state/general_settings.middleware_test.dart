// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/usecases/load_refresh_settings.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_browser_refresh_enabled.params.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_price_drop_alerts_enabled.params.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_price_increase_alerts_enabled.params.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_refresh_completed_alerts_enabled.params.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_refresh_interval.params.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_show_refresh_progress.params.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_browser_refresh_enabled.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_price_drop_alerts_enabled.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_price_increase_alerts_enabled.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_refresh_completed_alerts_enabled.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_refresh_interval.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_show_refresh_progress.usecase.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.middleware.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/utils/android_background_capabilities_service.dart';
import 'package:worth_loop/shared/utils/android_background_refresh_service.dart';
import 'package:worth_loop/shared/utils/android_price_alert_notification_service.dart';
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

class MockSavePriceDropAlertsEnabledUseCase extends Mock
    implements SavePriceDropAlertsEnabledUseCase {}

class MockSavePriceIncreaseAlertsEnabledUseCase extends Mock
    implements SavePriceIncreaseAlertsEnabledUseCase {}

class MockSaveRefreshCompletedAlertsEnabledUseCase extends Mock
    implements SaveRefreshCompletedAlertsEnabledUseCase {}

class MockSaveShowRefreshProgressUseCase extends Mock
    implements SaveShowRefreshProgressUseCase {}

class MockAndroidBackgroundCapabilitiesService extends Mock
    implements AndroidBackgroundCapabilitiesService {}

class MockAndroidBackgroundRefreshService extends Mock
    implements AndroidBackgroundRefreshService {}

class MockAndroidPriceAlertNotificationService extends Mock
    implements AndroidPriceAlertNotificationService {}

class FakeSaveRefreshIntervalParams extends Fake
    implements SaveRefreshIntervalParams {}

class FakeSaveBrowserRefreshEnabledParams extends Fake
    implements SaveBrowserRefreshEnabledParams {}

class FakeSavePriceDropAlertsEnabledParams extends Fake
    implements SavePriceDropAlertsEnabledParams {}

class FakeSavePriceIncreaseAlertsEnabledParams extends Fake
    implements SavePriceIncreaseAlertsEnabledParams {}

class FakeSaveRefreshCompletedAlertsEnabledParams extends Fake
    implements SaveRefreshCompletedAlertsEnabledParams {}

class FakeSaveShowRefreshProgressParams extends Fake
    implements SaveShowRefreshProgressParams {}

void main() {
  late List<dynamic> actionLog;
  late GeneralSettingsMiddleware middleware;
  late MockLoggerService mockLoggerService;
  late MockStore mockStore;
  late MockLoadRefreshSettingsUseCase mockLoadUseCase;
  late MockSaveRefreshIntervalUseCase mockSaveUseCase;
  late MockSaveBrowserRefreshEnabledUseCase mockSaveBrowserRefreshUseCase;
  late MockSavePriceDropAlertsEnabledUseCase mockSavePriceDropAlertsUseCase;
  late MockSavePriceIncreaseAlertsEnabledUseCase
  mockSavePriceIncreaseAlertsUseCase;
  late MockSaveRefreshCompletedAlertsEnabledUseCase
  mockSaveRefreshCompletedAlertsUseCase;
  late MockSaveShowRefreshProgressUseCase mockSaveShowRefreshProgressUseCase;
  late MockAndroidBackgroundCapabilitiesService mockCapabilitiesService;
  late MockAndroidBackgroundRefreshService mockBackgroundRefreshService;
  late MockAndroidPriceAlertNotificationService mockNotificationService;

  void next(dynamic action) => actionLog.add(action);

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(FakeSaveRefreshIntervalParams());
    registerFallbackValue(FakeSaveBrowserRefreshEnabledParams());
    registerFallbackValue(FakeSavePriceDropAlertsEnabledParams());
    registerFallbackValue(FakeSavePriceIncreaseAlertsEnabledParams());
    registerFallbackValue(FakeSaveRefreshCompletedAlertsEnabledParams());
    registerFallbackValue(FakeSaveShowRefreshProgressParams());
  });

  setUp(() {
    actionLog = [];
    middleware = GeneralSettingsMiddleware();
    mockLoggerService = MockLoggerService();
    mockStore = MockStore();
    mockLoadUseCase = MockLoadRefreshSettingsUseCase();
    mockSaveUseCase = MockSaveRefreshIntervalUseCase();
    mockSaveBrowserRefreshUseCase = MockSaveBrowserRefreshEnabledUseCase();
    mockSavePriceDropAlertsUseCase = MockSavePriceDropAlertsEnabledUseCase();
    mockSavePriceIncreaseAlertsUseCase =
        MockSavePriceIncreaseAlertsEnabledUseCase();
    mockSaveRefreshCompletedAlertsUseCase =
        MockSaveRefreshCompletedAlertsEnabledUseCase();
    mockSaveShowRefreshProgressUseCase = MockSaveShowRefreshProgressUseCase();
    mockCapabilitiesService = MockAndroidBackgroundCapabilitiesService();
    mockBackgroundRefreshService = MockAndroidBackgroundRefreshService();
    mockNotificationService = MockAndroidPriceAlertNotificationService();
    when(
      () => mockNotificationService.requestPermission(),
    ).thenAnswer((_) async => true);
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
    sl.registerSingleton<SavePriceDropAlertsEnabledUseCase>(
      mockSavePriceDropAlertsUseCase,
    );
    sl.registerSingleton<SavePriceIncreaseAlertsEnabledUseCase>(
      mockSavePriceIncreaseAlertsUseCase,
    );
    sl.registerSingleton<SaveRefreshCompletedAlertsEnabledUseCase>(
      mockSaveRefreshCompletedAlertsUseCase,
    );
    sl.registerSingleton<SaveShowRefreshProgressUseCase>(
      mockSaveShowRefreshProgressUseCase,
    );
    sl.registerSingleton<AndroidBackgroundCapabilitiesService>(
      mockCapabilitiesService,
    );
    sl.registerSingleton<AndroidBackgroundRefreshService>(
      mockBackgroundRefreshService,
    );
    sl.registerSingleton<AndroidPriceAlertNotificationService>(
      mockNotificationService,
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
      verifyZeroInteractions(mockBackgroundRefreshService);
    });

    test(
      'restarts the background refresh service when settings load with browserRefreshEnabled = true',
      () async {
        when(() => mockLoadUseCase(any())).thenAnswer(
          (_) async => Right(buildRefreshSettings(browserRefreshEnabled: true)),
        );
        when(
          () => mockBackgroundRefreshService.start(),
        ).thenAnswer((_) async => true);

        middleware.call(mockStore, const LoadRefreshSettingsAction(), next);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verify(() => mockBackgroundRefreshService.start()).called(1);
        verifyNoMoreInteractions(mockBackgroundRefreshService);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'warns when the background refresh service fails to restart on load',
      () async {
        when(() => mockLoadUseCase(any())).thenAnswer(
          (_) async => Right(buildRefreshSettings(browserRefreshEnabled: true)),
        );
        when(
          () => mockBackgroundRefreshService.start(),
        ).thenAnswer((_) async => false);

        middleware.call(mockStore, const LoadRefreshSettingsAction(), next);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verify(() => mockBackgroundRefreshService.start()).called(1);
        verify(
          () => mockLoggerService.w(
            'Background browser refresh could not start yet',
            showPopup: true,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockBackgroundRefreshService);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );

    test(
      'does not restart the background refresh service when settings load with browserRefreshEnabled = false',
      () async {
        when(() => mockLoadUseCase(any())).thenAnswer(
          (_) async =>
              Right(buildRefreshSettings(browserRefreshEnabled: false)),
        );

        middleware.call(mockStore, const LoadRefreshSettingsAction(), next);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => mockBackgroundRefreshService.start());
        verifyZeroInteractions(mockBackgroundRefreshService);
        verifyZeroInteractions(mockLoggerService);
      },
    );
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

  group('GeneralSettingsMiddleware processes SavePriceAlertsEnabledAction', () {
    test('dispatches PriceAlertsEnabledSavedAction when successful', () async {
      when(() => mockSavePriceDropAlertsUseCase(any())).thenAnswer(
        (_) async => Right(buildRefreshSettings(priceDropAlertsEnabled: true)),
      );

      middleware.call(
        mockStore,
        const SavePriceAlertsEnabledAction(true),
        next,
      );
      await Future<void>.delayed(Duration.zero);

      expect(actionLog[0], isA<SavePriceAlertsEnabledAction>());
      expect(actionLog[1], const PriceAlertsEnabledSavedAction(true));
      verify(() => mockNotificationService.requestPermission()).called(1);
      verify(
        () => mockSavePriceDropAlertsUseCase(
          const SavePriceDropAlertsEnabledParams(enabled: true),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockSavePriceDropAlertsUseCase);
      verifyZeroInteractions(mockLoggerService);
    });

    test('does not save when notification permission is denied', () async {
      when(
        () => mockNotificationService.requestPermission(),
      ).thenAnswer((_) async => false);

      middleware.call(
        mockStore,
        const SavePriceAlertsEnabledAction(true),
        next,
      );
      await Future<void>.delayed(Duration.zero);

      expect(actionLog, [const SavePriceAlertsEnabledAction(true)]);
      verifyNever(() => mockSavePriceDropAlertsUseCase(any()));
      verify(
        () => mockLoggerService.w(
          t.settings.notifications.priceAlerts.permissionDenied,
          showPopup: true,
        ),
      ).called(1);
    });

    test('dispatches PriceAlertsSaveFailedAction when failed', () async {
      const DatabaseFailure failure = DatabaseFailure('failed');
      when(
        () => mockSavePriceDropAlertsUseCase(any()),
      ).thenAnswer((_) async => const Left(failure));

      middleware.call(
        mockStore,
        const SavePriceAlertsEnabledAction(false),
        next,
      );
      await Future<void>.delayed(Duration.zero);

      expect(actionLog[1], const PriceAlertsSaveFailedAction('failed'));
      verifyNever(() => mockNotificationService.requestPermission());
      verify(
        () => mockSavePriceDropAlertsUseCase(
          const SavePriceDropAlertsEnabledParams(enabled: false),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockSavePriceDropAlertsUseCase);
      verify(() => mockLoggerService.e('failed', showPopup: true)).called(1);
      verifyNoMoreInteractions(mockLoggerService);
    });
  });

  group(
    'GeneralSettingsMiddleware processes SavePriceIncreaseAlertsEnabledAction',
    () {
      test(
        'dispatches PriceIncreaseAlertsEnabledSavedAction when successful',
        () async {
          when(() => mockSavePriceIncreaseAlertsUseCase(any())).thenAnswer(
            (_) async =>
                Right(buildRefreshSettings(priceIncreaseAlertsEnabled: true)),
          );

          middleware.call(
            mockStore,
            const SavePriceIncreaseAlertsEnabledAction(true),
            next,
          );
          await Future<void>.delayed(Duration.zero);

          expect(actionLog[0], isA<SavePriceIncreaseAlertsEnabledAction>());
          expect(
            actionLog[1],
            const PriceIncreaseAlertsEnabledSavedAction(true),
          );
          verify(() => mockNotificationService.requestPermission()).called(1);
          verify(
            () => mockSavePriceIncreaseAlertsUseCase(
              const SavePriceIncreaseAlertsEnabledParams(enabled: true),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockSavePriceIncreaseAlertsUseCase);
          verifyZeroInteractions(mockLoggerService);
        },
      );

      test('does not save when notification permission is denied', () async {
        when(
          () => mockNotificationService.requestPermission(),
        ).thenAnswer((_) async => false);

        middleware.call(
          mockStore,
          const SavePriceIncreaseAlertsEnabledAction(true),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        expect(actionLog, [const SavePriceIncreaseAlertsEnabledAction(true)]);
        verifyNever(() => mockSavePriceIncreaseAlertsUseCase(any()));
        verify(
          () => mockLoggerService.w(
            t.settings.notifications.priceIncreaseAlerts.permissionDenied,
            showPopup: true,
          ),
        ).called(1);
      });

      test(
        'dispatches PriceIncreaseAlertsSaveFailedAction when failed',
        () async {
          const DatabaseFailure failure = DatabaseFailure('failed');
          when(
            () => mockSavePriceIncreaseAlertsUseCase(any()),
          ).thenAnswer((_) async => const Left(failure));

          middleware.call(
            mockStore,
            const SavePriceIncreaseAlertsEnabledAction(false),
            next,
          );
          await Future<void>.delayed(Duration.zero);

          expect(
            actionLog[1],
            const PriceIncreaseAlertsSaveFailedAction('failed'),
          );
          verifyNever(() => mockNotificationService.requestPermission());
          verify(
            () => mockSavePriceIncreaseAlertsUseCase(
              const SavePriceIncreaseAlertsEnabledParams(enabled: false),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockSavePriceIncreaseAlertsUseCase);
          verify(
            () => mockLoggerService.e('failed', showPopup: true),
          ).called(1);
          verifyNoMoreInteractions(mockLoggerService);
        },
      );

      test(
        'dispatches PriceIncreaseAlertsSaveFailedAction when permission is granted but saving fails',
        () async {
          const DatabaseFailure failure = DatabaseFailure('failed');
          when(
            () => mockSavePriceIncreaseAlertsUseCase(any()),
          ).thenAnswer((_) async => const Left(failure));

          middleware.call(
            mockStore,
            const SavePriceIncreaseAlertsEnabledAction(true),
            next,
          );
          await Future<void>.delayed(Duration.zero);

          expect(
            actionLog[1],
            const PriceIncreaseAlertsSaveFailedAction('failed'),
          );
          verify(() => mockNotificationService.requestPermission()).called(1);
          verify(
            () => mockSavePriceIncreaseAlertsUseCase(
              const SavePriceIncreaseAlertsEnabledParams(enabled: true),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockSavePriceIncreaseAlertsUseCase);
          verify(
            () => mockLoggerService.e('failed', showPopup: true),
          ).called(1);
          verifyNoMoreInteractions(mockLoggerService);
        },
      );
    },
  );

  group(
    'GeneralSettingsMiddleware processes SaveRefreshCompletedAlertsEnabledAction',
    () {
      test(
        'dispatches RefreshCompletedAlertsEnabledSavedAction when successful',
        () async {
          when(() => mockSaveRefreshCompletedAlertsUseCase(any())).thenAnswer(
            (_) async => Right(
              buildRefreshSettings(refreshCompletedAlertsEnabled: true),
            ),
          );

          middleware.call(
            mockStore,
            const SaveRefreshCompletedAlertsEnabledAction(true),
            next,
          );
          await Future<void>.delayed(Duration.zero);

          expect(actionLog[0], isA<SaveRefreshCompletedAlertsEnabledAction>());
          expect(
            actionLog[1],
            const RefreshCompletedAlertsEnabledSavedAction(true),
          );
          verify(() => mockNotificationService.requestPermission()).called(1);
          verify(
            () => mockSaveRefreshCompletedAlertsUseCase(
              const SaveRefreshCompletedAlertsEnabledParams(enabled: true),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockSaveRefreshCompletedAlertsUseCase);
          verifyZeroInteractions(mockLoggerService);
        },
      );

      test('does not save when notification permission is denied', () async {
        when(
          () => mockNotificationService.requestPermission(),
        ).thenAnswer((_) async => false);

        middleware.call(
          mockStore,
          const SaveRefreshCompletedAlertsEnabledAction(true),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        expect(actionLog, [
          const SaveRefreshCompletedAlertsEnabledAction(true),
        ]);
        verifyNever(() => mockSaveRefreshCompletedAlertsUseCase(any()));
        verify(
          () => mockLoggerService.w(
            t.settings.notifications.refreshCompletedAlerts.permissionDenied,
            showPopup: true,
          ),
        ).called(1);
      });

      test(
        'dispatches RefreshCompletedAlertsSaveFailedAction when failed',
        () async {
          const DatabaseFailure failure = DatabaseFailure('failed');
          when(
            () => mockSaveRefreshCompletedAlertsUseCase(any()),
          ).thenAnswer((_) async => const Left(failure));

          middleware.call(
            mockStore,
            const SaveRefreshCompletedAlertsEnabledAction(false),
            next,
          );
          await Future<void>.delayed(Duration.zero);

          expect(
            actionLog[1],
            const RefreshCompletedAlertsSaveFailedAction('failed'),
          );
          verifyNever(() => mockNotificationService.requestPermission());
          verify(
            () => mockSaveRefreshCompletedAlertsUseCase(
              const SaveRefreshCompletedAlertsEnabledParams(enabled: false),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockSaveRefreshCompletedAlertsUseCase);
          verify(
            () => mockLoggerService.e('failed', showPopup: true),
          ).called(1);
          verifyNoMoreInteractions(mockLoggerService);
        },
      );

      test(
        'dispatches RefreshCompletedAlertsSaveFailedAction when permission is granted but saving fails',
        () async {
          const DatabaseFailure failure = DatabaseFailure('failed');
          when(
            () => mockSaveRefreshCompletedAlertsUseCase(any()),
          ).thenAnswer((_) async => const Left(failure));

          middleware.call(
            mockStore,
            const SaveRefreshCompletedAlertsEnabledAction(true),
            next,
          );
          await Future<void>.delayed(Duration.zero);

          expect(
            actionLog[1],
            const RefreshCompletedAlertsSaveFailedAction('failed'),
          );
          verify(() => mockNotificationService.requestPermission()).called(1);
          verify(
            () => mockSaveRefreshCompletedAlertsUseCase(
              const SaveRefreshCompletedAlertsEnabledParams(enabled: true),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockSaveRefreshCompletedAlertsUseCase);
          verify(
            () => mockLoggerService.e('failed', showPopup: true),
          ).called(1);
          verifyNoMoreInteractions(mockLoggerService);
        },
      );
    },
  );

  group(
    'GeneralSettingsMiddleware processes SaveShowRefreshProgressAction',
    () {
      test(
        'dispatches ShowRefreshProgressSavedAction when successful',
        () async {
          when(() => mockSaveShowRefreshProgressUseCase(any())).thenAnswer(
            (_) async => Right(buildRefreshSettings(showRefreshProgress: true)),
          );

          middleware.call(
            mockStore,
            const SaveShowRefreshProgressAction(true),
            next,
          );
          await Future<void>.delayed(Duration.zero);

          expect(actionLog[0], isA<SaveShowRefreshProgressAction>());
          expect(actionLog[1], const ShowRefreshProgressSavedAction(true));
          verifyNever(() => mockNotificationService.requestPermission());
          verify(
            () => mockSaveShowRefreshProgressUseCase(
              const SaveShowRefreshProgressParams(enabled: true),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockSaveShowRefreshProgressUseCase);
          verifyZeroInteractions(mockLoggerService);
        },
      );

      test(
        'dispatches ShowRefreshProgressSaveFailedAction when failed',
        () async {
          const DatabaseFailure failure = DatabaseFailure('failed');
          when(
            () => mockSaveShowRefreshProgressUseCase(any()),
          ).thenAnswer((_) async => const Left(failure));

          middleware.call(
            mockStore,
            const SaveShowRefreshProgressAction(false),
            next,
          );
          await Future<void>.delayed(Duration.zero);

          expect(
            actionLog[1],
            const ShowRefreshProgressSaveFailedAction('failed'),
          );
          verify(
            () => mockSaveShowRefreshProgressUseCase(
              const SaveShowRefreshProgressParams(enabled: false),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockSaveShowRefreshProgressUseCase);
          verify(
            () => mockLoggerService.e('failed', showPopup: true),
          ).called(1);
          verifyNoMoreInteractions(mockLoggerService);
        },
      );
    },
  );

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

      test('stops background refresh when disabled successfully', () async {
        when(() => mockSaveBrowserRefreshUseCase(any())).thenAnswer(
          (_) async =>
              Right(buildRefreshSettings(browserRefreshEnabled: false)),
        );
        when(
          () => mockBackgroundRefreshService.stop(),
        ).thenAnswer((_) async => true);

        middleware.call(
          mockStore,
          const SaveBrowserRefreshEnabledAction(false),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[1], const BrowserRefreshEnabledSavedAction(false));
        verify(() => mockBackgroundRefreshService.stop()).called(1);
        verifyNoMoreInteractions(mockBackgroundRefreshService);
        verifyZeroInteractions(mockLoggerService);
      });

      test('warns when background refresh cannot start', () async {
        when(() => mockSaveBrowserRefreshUseCase(any())).thenAnswer(
          (_) async => Right(buildRefreshSettings(browserRefreshEnabled: true)),
        );
        when(
          () => mockBackgroundRefreshService.start(),
        ).thenAnswer((_) async => false);

        middleware.call(
          mockStore,
          const SaveBrowserRefreshEnabledAction(true),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        verify(() => mockBackgroundRefreshService.start()).called(1);
        verify(
          () => mockLoggerService.w(
            'Background browser refresh could not start yet',
            showPopup: true,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockBackgroundRefreshService);
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
