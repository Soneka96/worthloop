// Package imports:
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/db/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('RefreshSettingsTable — round trip', () {
    test('stores the default hourly interval', () async {
      await db
          .into(db.refreshSettingsTable)
          .insert(RefreshSettingsTableCompanion.insert());

      final RefreshSettingsRow row = await db
          .select(db.refreshSettingsTable)
          .getSingle();

      expect(row.id, isA<int>());
      expect(row.id, 1);
      expect(row.intervalMinutes, isA<int>());
      expect(row.intervalMinutes, 60);
      expect(row.priceDropAlertsEnabled, isA<bool>());
      expect(row.priceDropAlertsEnabled, isFalse);
      expect(row.priceIncreaseAlertsEnabled, isA<bool>());
      expect(row.priceIncreaseAlertsEnabled, isFalse);
      expect(row.refreshCompletedAlertsEnabled, isA<bool>());
      expect(row.refreshCompletedAlertsEnabled, isFalse);
      expect(row.showRefreshProgress, isA<bool>());
      expect(row.showRefreshProgress, isFalse);
    });

    test('rejects a non-singleton row identifier', () async {
      expect(
        () => db
            .into(db.refreshSettingsTable)
            .insert(RefreshSettingsTableCompanion.insert(id: const Value(2))),
        throwsA(isA<SqliteException>()),
      );
    });
  });
}
