// Dart imports:
import 'dart:io';

// Package imports:
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/data/models/drift_schemas/github_profile.table.dart';

part 'app_database.g.dart';

/// Root drift database. Schema lives in per-feature tables listed in [tables] —
/// each feature owns its own table class; this file only aggregates them into
/// one database instance.
@DriftDatabase(tables: [GithubProfileTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Test-only constructor — pass an in-memory [QueryExecutor] (e.g.
  /// [NativeDatabase.memory] ()).
  AppDatabase.forTesting(super.executor);

  /// The SQLite file name inside the application support directory.
  static const String fileName = 'app.sqlite';

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory dbFolder = await getApplicationSupportDirectory();
    final File file = File(p.join(dbFolder.path, AppDatabase.fileName));
    return NativeDatabase.createInBackground(file);
  });
}
