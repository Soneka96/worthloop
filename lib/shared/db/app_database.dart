// Dart imports:
import 'dart:io';

// Package imports:
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:worth_loop/features/products/data/models/drift_schemas/product.table.dart';
import 'package:worth_loop/features/products/data/models/drift_schemas/product_source.table.dart';
import 'package:worth_loop/features/settings/data/models/drift_schemas/refresh_settings.table.dart';

part 'app_database.g.dart';

/// Root drift database. Schema lives in per-feature tables listed in [tables] —
/// each feature owns its own table class; this file only aggregates them into
/// one database instance.
@DriftDatabase(tables: [ProductTable, ProductSourceTable, RefreshSettingsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Test-only constructor — pass an in-memory [QueryExecutor] (e.g.
  /// [NativeDatabase.memory] ()).
  AppDatabase.forTesting(super.executor);

  /// The SQLite file name inside the application support directory.
  static const String fileName = 'app.sqlite';

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (Migrator migrator, int from, int to) async {
      if (from < 2) {
        await migrator.createTable(productTable);
        await migrator.createTable(refreshSettingsTable);
      }
      if (from < 4) {
        await migrator.createTable(productSourceTable);
      }
      if (from < 5) {
        await migrator.addColumn(
          productTable,
          productTable.previousBestPriceMinorUnits,
        );
        await migrator.addColumn(
          productTable,
          productTable.previousBestPriceCurrencyCode,
        );
        await migrator.addColumn(productTable, productTable.bestPriceChangedAt);
        if (from >= 4) {
          await migrator.addColumn(
            productSourceTable,
            productSourceTable.previousPriceMinorUnits,
          );
          await migrator.addColumn(
            productSourceTable,
            productSourceTable.previousPriceCurrencyCode,
          );
          await migrator.addColumn(
            productSourceTable,
            productSourceTable.priceChangedAt,
          );
        }
      }
      if (from < 6 && from >= 4) {
        await migrator.addColumn(
          productSourceTable,
          productSourceTable.lastRefreshStatus,
        );
        await migrator.addColumn(
          productSourceTable,
          productSourceTable.lastRefreshAt,
        );
      }
      if (from < 7) {
        await migrator.addColumn(
          refreshSettingsTable,
          refreshSettingsTable.browserRefreshEnabled,
        );
      }
    },
    beforeOpen: (OpeningDetails details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory dbFolder = await getApplicationSupportDirectory();
    final File file = File(p.join(dbFolder.path, AppDatabase.fileName));
    return NativeDatabase.createInBackground(file);
  });
}
