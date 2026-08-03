// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/features/logs/presentation/widgets/log_entry_tile.widget.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import '../../fixtures/log_entry.fixture.dart';

void main() {
  Widget buildWidget(LogEntry entry) {
    return MaterialApp(
      home: Scaffold(body: LogEntryTile(entry: entry)),
    );
  }

  group('LogEntryTile contains widgets', () {
    testWidgets(
      'LogEntryTile contains a Text with the correct parameters for the formatted time',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(
            buildLogEntry(timestamp: DateTime(2026, 1, 1, 14, 2, 11)),
          ),
        );

        expect(find.text('14:02:11'), findsOneWidget);
      },
    );

    testWidgets(
      'LogEntryTile contains a Text with the correct parameters for the message',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(buildLogEntry(message: 'Run started — 42 files queued')),
        );

        expect(find.text('Run started — 42 files queued'), findsOneWidget);
      },
    );

    testWidgets('LogEntryTile contains an Icon with the correct parameters', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(buildLogEntry()));

      expect(find.byType(Icon), findsOneWidget);
    });
  });

  group("LogEntryTile's elements behavior", () {
    for (final LogLevel level in [
      LogLevel.none,
      LogLevel.info,
      LogLevel.warning,
      LogLevel.error,
      LogLevel.success,
    ]) {
      testWidgets(
        'LogEntryTile contains an Icon with the correct behavior when entry.level = LogLevel.${level.name}',
        (tester) async {
          await tester.pumpWidget(buildWidget(buildLogEntry(level: level)));

          final BuildContext context = tester.element(
            find.byType(LogEntryTile),
          );
          final ColorScheme colorScheme = Theme.of(context).colorScheme;
          final Icon icon = tester.widget(find.byType(Icon));

          expect(icon.icon, level.icon);
          expect(icon.color, level.color(colorScheme));
        },
      );
    }
  });
}
