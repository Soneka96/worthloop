// Package imports:
import 'package:drift/drift.dart';

/// Persisted refresh scheduling preferences.
@DataClassName('RefreshSettingsRow')
class RefreshSettingsTable extends Table {
  /// Singleton row identifier.
  IntColumn get id => integer().withDefault(const Constant(1))();

  /// Preferred refresh interval in minutes.
  IntColumn get intervalMinutes => integer().withDefault(const Constant(60))();

  /// Whether browser-backed background refresh is enabled.
  BoolColumn get browserRefreshEnabled =>
      boolean().withDefault(const Constant(false))();

  /// Whether product price-drop notifications are enabled.
  BoolColumn get priceDropAlertsEnabled =>
      boolean().withDefault(const Constant(false))();

  /// Whether product price-increase notifications are enabled.
  BoolColumn get priceIncreaseAlertsEnabled =>
      boolean().withDefault(const Constant(false))();

  /// Whether a notification is shown for every completed background refresh.
  BoolColumn get refreshCompletedAlertsEnabled =>
      boolean().withDefault(const Constant(false))();

  /// Whether the background refresh shows a progress bar on its
  /// notification while sources are being fetched.
  BoolColumn get showRefreshProgress =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['CHECK (id = 1)'];
}
