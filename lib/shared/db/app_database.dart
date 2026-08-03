// Dart imports:
import 'dart:io' hide Directory;

// Package imports:
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:file/file.dart' show Directory;
import 'package:file/local.dart';
import 'package:path/path.dart' as p;

// Project imports:
import 'package:worth_loop/features/github_explorer/data/models/drift_schemas/github_profile.table.dart';
import 'package:worth_loop/features/logs/data/models/drift_schemas/log_entry.table.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/db/app_data_root_service.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';

part 'app_database.g.dart';

/// Root drift database. Schema lives in per-feature tables listed in [tables] —
/// each feature owns its own table class; this file only aggregates them into
/// one database instance.
@DriftDatabase(tables: [LogEntryTable, GithubProfileTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Test-only constructor — pass an in-memory [QueryExecutor] (e.g.
  /// [NativeDatabase.memory] ()).
  AppDatabase.forTesting(super.executor);

  /// The sqlite file's name — shared with [AppDataRootService], which needs
  /// it to identify this database's file (and its journal/wal/shm sidecars)
  /// when moving the data root.
  static const String fileName = 'app.sqlite';

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory dbFolder = await AppDataRootService(
      AppPreferencesStore(),
      const LocalFileSystem(),
    ).resolveCurrentDataDirectory();
    final File file = File(p.join(dbFolder.path, AppDatabase.fileName));
    return NativeDatabase.createInBackground(file);
  });
}
