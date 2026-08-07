// Package imports:
import 'package:fpdart/fpdart.dart';
import 'package:sqlite3/sqlite3.dart';

// Project imports:
import 'package:worth_loop/features/settings/data/models/refresh_settings.model.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/refresh_interval_constants.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

/// Local refresh-settings persistence.
class RefreshSettingsLocalDatasource {
  final AppDatabase _db;

  /// Creates refresh-settings persistence backed by [AppDatabase].
  RefreshSettingsLocalDatasource(this._db);

  /// Loads the persisted refresh settings.
  Future<Either<Failure, RefreshSettingsModel>> loadSettings() async {
    try {
      final RefreshSettingsRow? row = await (_db.select(
        _db.refreshSettingsTable,
      )..where((table) => table.id.equals(1))).getSingleOrNull();
      if (row == null) {
        const RefreshSettingsModel defaults = RefreshSettingsModel(
          intervalMinutes: RefreshIntervalConstants.hourly,
        );
        await _db
            .into(_db.refreshSettingsTable)
            .insertOnConflictUpdate(defaults.toCompanion());
        return const Right(defaults);
      }
      return Right(RefreshSettingsModel.fromRow(row));
    } on SqliteException catch (error) {
      sl<LoggerService>().e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    }
  }

  /// Persists [intervalMinutes] and returns the saved settings.
  Future<Either<Failure, RefreshSettingsModel>> saveInterval(
    int intervalMinutes,
  ) async {
    try {
      final RefreshSettingsRow? existing = await (_db.select(
        _db.refreshSettingsTable,
      )..where((table) => table.id.equals(1))).getSingleOrNull();
      final RefreshSettingsModel model = RefreshSettingsModel(
        intervalMinutes: intervalMinutes,
        browserRefreshEnabled: existing?.browserRefreshEnabled ?? false,
      );
      await _db
          .into(_db.refreshSettingsTable)
          .insertOnConflictUpdate(model.toCompanion());
      return Right(model);
    } on SqliteException catch (error) {
      sl<LoggerService>().e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    }
  }

  /// Persists whether browser-backed background refresh is enabled.
  Future<Either<Failure, RefreshSettingsModel>> saveBrowserRefreshEnabled(
    bool enabled,
  ) async {
    try {
      final RefreshSettingsRow? existing = await (_db.select(
        _db.refreshSettingsTable,
      )..where((table) => table.id.equals(1))).getSingleOrNull();
      final RefreshSettingsModel model = RefreshSettingsModel(
        intervalMinutes:
            existing?.intervalMinutes ?? RefreshIntervalConstants.hourly,
        browserRefreshEnabled: enabled,
      );
      await _db
          .into(_db.refreshSettingsTable)
          .insertOnConflictUpdate(model.toCompanion());
      return Right(model);
    } on SqliteException catch (error) {
      sl<LoggerService>().e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    }
  }
}
