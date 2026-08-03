// Package imports:
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/db/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async => db.close());

  group('LogEntryTable — round trip', () {
    test('LogEntryTable stores and reads back a log entry row', () async {
      final int id = await db
          .into(db.logEntryTable)
          .insert(
            LogEntryTableCompanion.insert(
              timestamp: DateTime(2026, 1, 1, 12),
              level: LogLevel.warning,
              message: 'Retrying file 07 after timeout',
              details: const Value('┌─────────\n│ decorated\n└─────────'),
            ),
          );

      final LogEntryRow row = await (db.select(
        db.logEntryTable,
      )..where((t) => t.id.equals(id))).getSingle();

      expect(row.timestamp, DateTime(2026, 1, 1, 12));
      expect(row.level, LogLevel.warning);
      expect(row.message, 'Retrying file 07 after timeout');
      expect(row.details, '┌─────────\n│ decorated\n└─────────');
    });

    test('LogEntryTable stores and reads back a null details column', () async {
      final int id = await db
          .into(db.logEntryTable)
          .insert(
            LogEntryTableCompanion.insert(
              timestamp: DateTime(2026, 1, 1, 12),
              level: LogLevel.warning,
              message: 'Retrying file 07 after timeout',
            ),
          );

      final LogEntryRow row = await (db.select(
        db.logEntryTable,
      )..where((t) => t.id.equals(id))).getSingle();

      expect(row.details, null);
    });
  });
}
