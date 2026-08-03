// Package imports:
import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/features/logs/domain/usecases/clear_log_entries.usecase.dart';
import 'package:worth_loop/features/logs/domain/usecases/export_log_entries.usecase.dart';
import 'package:worth_loop/features/logs/domain/usecases/load_log_entries.usecase.dart';
import 'package:worth_loop/features/logs/domain/usecases/params/clear_log_entries.params.dart';
import 'package:worth_loop/features/logs/domain/usecases/params/export_log_entries.params.dart';
import 'package:worth_loop/features/logs/presentation/state/logs.actions.dart';
import 'package:worth_loop/features/logs/presentation/state/logs.middleware.dart';
import 'package:worth_loop/features/logs/presentation/state/logs.state.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/db/app_data_root_service.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/system_opener.dart';
import '../../fixtures/log_entry.fixture.dart';

class MockStore extends Mock implements Store<AppState> {}

class MockAppDataRootService extends Mock implements AppDataRootService {}

class MockLoadLogEntriesUseCase extends Mock implements LoadLogEntriesUseCase {}

class MockClearLogEntriesUseCase extends Mock
    implements ClearLogEntriesUseCase {}

class MockExportLogEntriesUseCase extends Mock
    implements ExportLogEntriesUseCase {}

class MockLoggerService extends Mock implements LoggerService {}

class MockSystemOpener extends Mock implements SystemOpener {}

class FakeClearLogEntriesParams extends Fake implements ClearLogEntriesParams {}

class FakeExportLogEntriesParams extends Fake
    implements ExportLogEntriesParams {}

void main() {
  late LogsMiddleware middleware;
  late MockStore store;
  late MockAppDataRootService mockAppDataRootService;
  late MockLoadLogEntriesUseCase mockLoadUseCase;
  late MockClearLogEntriesUseCase mockClearUseCase;
  late MockExportLogEntriesUseCase mockExportUseCase;
  late MockLoggerService mockLoggerService;
  late MockSystemOpener mockSystemOpener;
  late List<dynamic> actionLog;

  void next(dynamic action) => actionLog.add(action);

  setUpAll(() {
    registerFallbackValue(FakeClearLogEntriesParams());
    registerFallbackValue(FakeExportLogEntriesParams());
    registerFallbackValue(NoParams());
  });

  setUp(() {
    middleware = LogsMiddleware();
    store = MockStore();
    mockAppDataRootService = MockAppDataRootService();
    mockLoadUseCase = MockLoadLogEntriesUseCase();
    mockClearUseCase = MockClearLogEntriesUseCase();
    mockExportUseCase = MockExportLogEntriesUseCase();
    mockLoggerService = MockLoggerService();
    mockSystemOpener = MockSystemOpener();
    actionLog = [];

    when(() => store.dispatch(any())).thenAnswer(
      (invocation) => actionLog.add(invocation.positionalArguments[0]),
    );
    when(() => store.state).thenReturn(AppState.initial());
    when(
      () => mockAppDataRootService.resolveCurrentDataDirectory(),
    ).thenAnswer((_) async => MemoryFileSystem().directory('C:/App'));

    sl.registerSingleton<AppDataRootService>(mockAppDataRootService);
    sl.registerSingleton<LoadLogEntriesUseCase>(mockLoadUseCase);
    sl.registerSingleton<ClearLogEntriesUseCase>(mockClearUseCase);
    sl.registerSingleton<ExportLogEntriesUseCase>(mockExportUseCase);
    sl.registerSingleton<LoggerService>(mockLoggerService);
    sl.registerSingleton<SystemOpener>(mockSystemOpener);
  });

  tearDown(() => sl.reset());

  group('LogsMiddleware processes LoadLogEntriesAction', () {
    test(
      'LoadLogEntriesAction dispatches LogEntriesLoadedAction with the loaded entries and resolved folder path',
      () async {
        final LogEntry entry = buildLogEntry();
        when(
          () => mockLoadUseCase(any()),
        ).thenAnswer((_) async => Right([entry]));

        middleware.call(store, const LoadLogEntriesAction(), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog.length, 2);
        expect(actionLog[0], isA<LoadLogEntriesAction>());
        expect(actionLog[1], isA<LogEntriesLoadedAction>());

        final LogEntriesLoadedAction action =
            actionLog[1] as LogEntriesLoadedAction;
        expect(action.entries, [entry]);
        expect(action.folderPath, p.join('C:/App', 'logs'));
      },
    );

    test(
      'LoadLogEntriesAction shows a popup and dispatches nothing else when the usecase fails',
      () async {
        const DatabaseFailure failure = DatabaseFailure('boom');
        when(
          () => mockLoadUseCase(any()),
        ).thenAnswer((_) async => const Left(failure));

        middleware.call(store, const LoadLogEntriesAction(), next);
        await Future<void>.delayed(Duration.zero);

        expect(
          actionLog.length,
          1,
          reason: 'only the original action, no follow-up dispatch',
        );
        verify(() => mockLoggerService.e('boom', showPopup: true)).called(1);
      },
    );
  });

  group('LogsMiddleware processes ClearLogEntriesAction', () {
    final DateTime cutoff = DateTime(2026, 1, 1, 12);

    test(
      'ClearLogEntriesAction forwards cutoff unchanged and re-dispatches LoadLogEntriesAction when the usecase succeeds',
      () async {
        when(
          () => mockClearUseCase(any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockLoadUseCase(any()),
        ).thenAnswer((_) async => const Right([]));

        middleware.call(store, ClearLogEntriesAction(cutoff), next);
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockClearUseCase(ClearLogEntriesParams(cutoff: cutoff)),
        ).called(1);
        expect(
          actionLog.whereType<LoadLogEntriesAction>(),
          isNotEmpty,
          reason: 'should reload after a successful clear',
        );
      },
    );

    test(
      'ClearLogEntriesAction shows a popup and does not reload when the usecase fails',
      () async {
        const DatabaseFailure failure = DatabaseFailure('boom');
        when(
          () => mockClearUseCase(any()),
        ).thenAnswer((_) async => const Left(failure));

        middleware.call(store, ClearLogEntriesAction(cutoff), next);
        await Future<void>.delayed(Duration.zero);

        verify(() => mockLoggerService.e('boom', showPopup: true)).called(1);
        expect(actionLog.whereType<LoadLogEntriesAction>(), isEmpty);
      },
    );
  });

  group('LogsMiddleware processes ExportLogEntriesAction', () {
    test(
      'ExportLogEntriesAction shows a success popup when the usecase returns Right(path)',
      () async {
        when(
          () => mockExportUseCase(any()),
        ).thenAnswer((_) async => const Right('C:/App/logs.txt'));

        middleware.call(store, const ExportLogEntriesAction(), next);
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockLoggerService.i(
            'Logs exported to C:/App/logs.txt',
            showPopup: true,
          ),
        ).called(1);
      },
    );

    test(
      'ExportLogEntriesAction shows no popup when the usecase returns Right(null)',
      () async {
        when(
          () => mockExportUseCase(any()),
        ).thenAnswer((_) async => const Right(null));

        middleware.call(store, const ExportLogEntriesAction(), next);
        await Future<void>.delayed(Duration.zero);

        verifyNever(
          () => mockLoggerService.i(any(), showPopup: any(named: 'showPopup')),
        );
      },
    );

    test(
      'ExportLogEntriesAction shows a failure popup when the usecase fails',
      () async {
        const FileSystemFailure failure = FileSystemFailure('boom');
        when(
          () => mockExportUseCase(any()),
        ).thenAnswer((_) async => const Left(failure));

        middleware.call(store, const ExportLogEntriesAction(), next);
        await Future<void>.delayed(Duration.zero);

        verify(() => mockLoggerService.e('boom', showPopup: true)).called(1);
      },
    );
  });

  group('LogsMiddleware processes OpenLogsFolderAction', () {
    test(
      'OpenLogsFolderAction calls SystemOpener.openFolder() with the resolved folder path',
      () async {
        when(() => store.state).thenReturn(
          AppState.initial().copyWith(
            logs: LogsState.initial().copyWith(folderPath: 'C:/App/logs'),
          ),
        );
        when(() => mockSystemOpener.openFolder(any())).thenAnswer((_) async {});

        middleware.call(store, const OpenLogsFolderAction(), next);
        await Future<void>.delayed(Duration.zero);

        verify(() => mockSystemOpener.openFolder('C:/App/logs')).called(1);
      },
    );

    test(
      'OpenLogsFolderAction does not call SystemOpener.openFolder() when folderPath == null',
      () async {
        middleware.call(store, const OpenLogsFolderAction(), next);
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => mockSystemOpener.openFolder(any()));
      },
    );
  });
}
