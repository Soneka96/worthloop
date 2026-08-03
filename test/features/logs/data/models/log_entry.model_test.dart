// Package imports:
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/logs/data/models/log_entry.model.dart';
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/db/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async => db.close());

  group('LogEntryModel is an implementation of LogEntry', () {
    test('LogEntryModel is a LogEntry', () {
      final LogEntryModel model = LogEntryModel(
        timestamp: DateTime(2026, 1, 1),
        level: LogLevel.info,
        message: 'Test',
      );

      expect(model, isA<LogEntry>());
    });
  });

  group("LogEntryModel's methods return the correct value", () {
    test('Method fromRow() should return a LogEntryModel', () async {
      final int id = await db
          .into(db.logEntryTable)
          .insert(
            LogEntryTableCompanion.insert(
              timestamp: DateTime(2026, 1, 1, 12),
              level: LogLevel.error,
              message: 'File 12 failed — 500 response',
              details: const Value('decorated File 12 failed'),
            ),
          );
      final LogEntryRow row = await (db.select(
        db.logEntryTable,
      )..where((t) => t.id.equals(id))).getSingle();

      final LogEntryModel model = LogEntryModel.fromRow(row);

      expect(model, isA<LogEntryModel>());
      expect(model.timestamp, DateTime(2026, 1, 1, 12));
      expect(model.level, LogLevel.error);
      expect(model.message, 'File 12 failed — 500 response');
      expect(model.details, 'decorated File 12 failed');
    });
  });
}
