// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/logs/data/datasources/log_entry_local.datasource.dart';
import 'package:worth_loop/features/logs/domain/repositories/Ilogs.repository.dart';
import 'package:worth_loop/features/logs/domain/usecases/clear_log_entries.usecase.dart';
import 'package:worth_loop/features/logs/domain/usecases/export_log_entries.usecase.dart';
import 'package:worth_loop/features/logs/domain/usecases/load_log_entries.usecase.dart';
import 'package:worth_loop/features/logs/logs.injection_container.dart';
import 'package:worth_loop/features/logs/presentation/state/viewmodels/logs_screen.viewmodel.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/db/app_database.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  setUp(() {
    // The logs feature container only needs AppDatabase to be registered —
    // a mock keeps this test from booting the real shared layer (drift, GoRouter, etc).
    sl.registerSingleton<AppDatabase>(MockAppDatabase());
    initLogsDependencies();
  });

  tearDown(() async => sl.reset());

  group('logs.injection_container — logs feature registrations', () {
    test('datasources are registered', () {
      expect(
        sl.isRegistered<LogEntryLocalDatasource>(),
        isTrue,
        reason: 'LogEntryLocalDatasource should be registered',
      );
    });

    test('repositories are registered', () {
      expect(
        sl.isRegistered<ILogsRepository>(),
        isTrue,
        reason: 'ILogsRepository should be registered',
      );
    });

    test('usecases are registered', () {
      expect(
        sl.isRegistered<LoadLogEntriesUseCase>(),
        isTrue,
        reason: 'LoadLogEntriesUseCase should be registered',
      );
      expect(
        sl.isRegistered<ClearLogEntriesUseCase>(),
        isTrue,
        reason: 'ClearLogEntriesUseCase should be registered',
      );
      expect(
        sl.isRegistered<ExportLogEntriesUseCase>(),
        isTrue,
        reason: 'ExportLogEntriesUseCase should be registered',
      );
    });

    test('viewmodels are registered', () {
      expect(
        sl.isRegistered<LogsScreenViewModel>(),
        isTrue,
        reason: 'LogsScreenViewModel should be registered',
      );
    });
  });
}
