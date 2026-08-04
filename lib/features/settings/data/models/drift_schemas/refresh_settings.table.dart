// Package imports:
import 'package:drift/drift.dart';

/// Persisted manual-refresh scheduling preferences.
@DataClassName('RefreshSettingsRow')
class RefreshSettingsTable extends Table {
  /// Singleton row identifier.
  IntColumn get id => integer().withDefault(const Constant(1))();

  /// Preferred refresh interval in minutes.
  IntColumn get intervalMinutes => integer().withDefault(const Constant(60))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['CHECK (id = 1)'];
}
