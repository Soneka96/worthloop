// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.middleware.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/db/app_data_root_service.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/notifications/system_notification_service.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/preferences/general_settings_snapshot.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/utils/Iapp_relaunch.gateway.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/window/Iwindow.gateway.dart';

class MockStore extends Mock implements Store<AppState> {}

class MockAppPreferencesStore extends Mock implements AppPreferencesStore {}

class MockAppDataRootService extends Mock implements AppDataRootService {}

class MockAppDatabase extends Mock implements AppDatabase {}

class MockLoggerService extends Mock implements LoggerService {}

class MockSystemNotificationService extends Mock
    implements SystemNotificationService {}

class MockIAppRelaunchGateway extends Mock implements IAppRelaunchGateway {}

class MockIWindowGateway extends Mock implements IWindowGateway {}

void main() {
  late GeneralSettingsMiddleware middleware;
  late MockStore store;
  late MockAppPreferencesStore mockPreferencesStore;
  late MockAppDataRootService mockAppDataRootService;
  late MockAppDatabase mockAppDatabase;
  late MockLoggerService mockLoggerService;
  late MockSystemNotificationService mockNotificationService;
  late MockIAppRelaunchGateway mockRelaunchGateway;
  late MockIWindowGateway mockWindowGateway;
  late List<dynamic> actionLog;

  void next(dynamic action) => actionLog.add(action);

  setUp(() {
    middleware = GeneralSettingsMiddleware();
    store = MockStore();
    mockPreferencesStore = MockAppPreferencesStore();
    mockAppDataRootService = MockAppDataRootService();
    mockAppDatabase = MockAppDatabase();
    mockLoggerService = MockLoggerService();
    mockNotificationService = MockSystemNotificationService();
    mockRelaunchGateway = MockIAppRelaunchGateway();
    mockWindowGateway = MockIWindowGateway();
    actionLog = [];

    when(() => store.dispatch(any())).thenAnswer(
      (invocation) => actionLog.add(invocation.positionalArguments[0]),
    );

    sl.registerSingleton<AppPreferencesStore>(mockPreferencesStore);
    sl.registerSingleton<AppDataRootService>(mockAppDataRootService);
    sl.registerSingleton<AppDatabase>(mockAppDatabase);
    sl.registerSingleton<LoggerService>(mockLoggerService);
    sl.registerSingleton<SystemNotificationService>(mockNotificationService);
    sl.registerSingleton<IAppRelaunchGateway>(mockRelaunchGateway);
    sl.registerSingleton<IWindowGateway>(mockWindowGateway);
  });

  tearDown(() => sl.reset());

  group('GeneralSettingsMiddleware processes LoadGeneralSettingsAction', () {
    test(
      'LoadGeneralSettingsAction dispatches GeneralSettingsLoadedAction with the persisted values',
      () async {
        when(() => mockPreferencesStore.readGeneralSettings()).thenAnswer(
          (_) async => const GeneralSettingsSnapshot(
            defaultSaveLocation: 'C:/App',
            pendingDataRoot: 'C:/NewApp',
          ),
        );

        middleware.call(store, const LoadGeneralSettingsAction(), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog.length, 2);
        expect(actionLog[0], isA<LoadGeneralSettingsAction>());
        expect(actionLog[1], isA<GeneralSettingsLoadedAction>());

        final GeneralSettingsLoadedAction action =
            actionLog[1] as GeneralSettingsLoadedAction;
        expect(action.defaultSaveLocation, 'C:/App');
        expect(action.pendingDataRoot, 'C:/NewApp');
      },
    );

    test(
      'LoadGeneralSettingsAction forwards null untouched when nothing is persisted, leaving defaulting to the reducer',
      () async {
        when(() => mockPreferencesStore.readGeneralSettings()).thenAnswer(
          (_) async => const GeneralSettingsSnapshot(
            defaultSaveLocation: null,
            pendingDataRoot: null,
          ),
        );

        middleware.call(store, const LoadGeneralSettingsAction(), next);
        await Future<void>.delayed(Duration.zero);

        final GeneralSettingsLoadedAction action =
            actionLog[1] as GeneralSettingsLoadedAction;
        expect(action.defaultSaveLocation, isNull);
        expect(action.pendingDataRoot, isNull);
      },
    );
  });

  group('GeneralSettingsMiddleware processes PickDefaultSaveLocationAction', () {
    const String notEmptyMessage =
        "This folder isn't empty. Choose an empty folder — the app will move its data here.";
    const String restartMessage =
        'Restart the app to finish moving your data to the new folder.';
    const String stayMessage = 'Your data will stay in its current folder.';

    test(
      'PickDefaultSaveLocationAction shows the failure popup and does not show the restart notification when AppDataRootService.requestMove returns Left(FileSystemFailure)',
      () async {
        when(() => mockAppDataRootService.requestMove(any())).thenAnswer(
          (_) async => const Left(FileSystemFailure(notEmptyMessage)),
        );

        middleware.call(
          store,
          const PickDefaultSaveLocationAction('C:/App'),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockAppDataRootService.requestMove('C:/App'),
        ).called(1);
        verify(
          () => mockLoggerService.e(notEmptyMessage, showPopup: true),
        ).called(1);
        verifyNever(
          () => mockNotificationService.show(
            title: any(named: 'title'),
            body: any(named: 'body'),
            onClick: any(named: 'onClick'),
          ),
        );
      },
    );

    test(
      'PickDefaultSaveLocationAction dispatches PendingDataRootUpdatedAction and shows a restart notification whose onClick dispatches RestartNowAction when a move is left pending after AppDataRootService.requestMove returns Right(unit)',
      () async {
        when(
          () => mockAppDataRootService.requestMove(any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockPreferencesStore.readPendingDataRoot(),
        ).thenAnswer((_) async => 'C:/App');
        when(
          () => mockNotificationService.show(
            title: any(named: 'title'),
            body: any(named: 'body'),
            onClick: any(named: 'onClick'),
          ),
        ).thenAnswer((_) async {});

        middleware.call(
          store,
          const PickDefaultSaveLocationAction('C:/App'),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockAppDataRootService.requestMove('C:/App'),
        ).called(1);
        expect(actionLog, [
          isA<PickDefaultSaveLocationAction>(),
          const PendingDataRootUpdatedAction('C:/App'),
        ]);
        final void Function() onClick =
            verify(
                  () => mockNotificationService.show(
                    title: 'Restart pending',
                    body: restartMessage,
                    onClick: captureAny(named: 'onClick'),
                  ),
                ).captured.single
                as void Function();
        verifyNever(
          () => mockLoggerService.e(notEmptyMessage, showPopup: true),
        );
        verifyNever(() => mockLoggerService.i(stayMessage, showPopup: true));

        onClick();

        expect(actionLog.last, const RestartNowAction());
      },
    );

    test(
      'PickDefaultSaveLocationAction dispatches PendingDataRootUpdatedAction and shows the stay popup when no move is left pending after AppDataRootService.requestMove returns Right(unit)',
      () async {
        when(
          () => mockAppDataRootService.requestMove(any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockPreferencesStore.readPendingDataRoot(),
        ).thenAnswer((_) async => null);

        middleware.call(
          store,
          const PickDefaultSaveLocationAction('C:/App'),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockAppDataRootService.requestMove('C:/App'),
        ).called(1);
        expect(actionLog, [
          isA<PickDefaultSaveLocationAction>(),
          const PendingDataRootUpdatedAction(null),
        ]);
        verify(
          () => mockLoggerService.i(stayMessage, showPopup: true),
        ).called(1);
        verifyNever(
          () => mockLoggerService.e(notEmptyMessage, showPopup: true),
        );
        verifyNever(
          () => mockNotificationService.show(
            title: any(named: 'title'),
            body: any(named: 'body'),
            onClick: any(named: 'onClick'),
          ),
        );
      },
    );
  });

  group('GeneralSettingsMiddleware processes RestartNowAction', () {
    test(
      'RestartNowAction calls IWindowGateway.hide() before AppDatabase.close() before IAppRelaunchGateway.relaunch() before IWindowGateway.close()',
      () async {
        when(() => mockWindowGateway.hide()).thenAnswer((_) async {});
        when(() => mockAppDatabase.close()).thenAnswer((_) async {});
        when(() => mockRelaunchGateway.relaunch()).thenAnswer((_) async {});
        when(() => mockWindowGateway.close()).thenAnswer((_) async {});

        middleware.call(store, const RestartNowAction(), next);
        await Future<void>.delayed(Duration.zero);

        verifyInOrder([
          () => mockWindowGateway.hide(),
          () => mockAppDatabase.close(),
          () => mockRelaunchGateway.relaunch(),
          () => mockWindowGateway.close(),
        ]);
      },
    );
  });

  group('GeneralSettingsMiddleware processes CheckForUpdatesAction', () {
    test('CheckForUpdatesAction shows a not-implemented-yet popup', () {
      middleware.call(store, const CheckForUpdatesAction(), next);

      verify(
        () => mockLoggerService.i(
          'Checking for updates is not implemented yet.',
          showPopup: true,
        ),
      ).called(1);
    });
  });

  group('GeneralSettingsMiddleware processes OpenPrivacyPolicyAction', () {
    test('OpenPrivacyPolicyAction shows a not-implemented-yet popup', () {
      middleware.call(store, const OpenPrivacyPolicyAction(), next);

      verify(
        () => mockLoggerService.i(
          'Privacy & data use is not implemented yet.',
          showPopup: true,
        ),
      ).called(1);
    });
  });
}
