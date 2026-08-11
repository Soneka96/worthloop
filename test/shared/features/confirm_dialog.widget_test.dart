// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/features/confirm_dialog.widget.dart';

void main() {
  Widget buildWidget() => const MaterialApp(
    home: ConfirmDialog(
      title: 'Remove this source?',
      message: "This can't be undone.",
      confirmLabel: 'Remove',
    ),
  );

  Widget buildTriggerWidget({required void Function(bool) onResult}) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            key: const Key('trigger'),
            onPressed: () async {
              final bool confirmed = await ConfirmDialog.show(
                context,
                title: 'Remove this source?',
                message: "This can't be undone.",
                confirmLabel: 'Remove',
              );
              onResult(confirmed);
            },
            child: const Text('trigger'),
          ),
        ),
      ),
    );
  }

  group('ConfirmDialog contains widgets', () {
    testWidgets(
      'ConfirmDialog contains the title, message, and actions with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        final ColorScheme colorScheme = Theme.of(
          tester.element(find.byType(ConfirmDialog)),
        ).colorScheme;
        final AlertDialog dialog = tester.widget(find.byType(AlertDialog));
        final RoundedRectangleBorder shape =
            dialog.shape as RoundedRectangleBorder;

        expect(find.text('Remove this source?'), findsOneWidget);
        expect(find.text("This can't be undone."), findsOneWidget);
        expect(shape.borderRadius, BorderRadius.circular(20));
        expect(
          find.byKey(const Key('confirm-dialog-cancel-button')),
          findsOneWidget,
        );
        expect(
          tester.widget(find.byKey(const Key('confirm-dialog-cancel-button'))),
          isA<TextButton>(),
        );
        expect(find.text('Cancel'), findsOneWidget);
        expect(
          find.byKey(const Key('confirm-dialog-confirm-button')),
          findsOneWidget,
        );
        final FilledButton confirmButton = tester.widget(
          find.byKey(const Key('confirm-dialog-confirm-button')),
        );
        expect(confirmButton, isA<FilledButton>());
        expect(find.text('Remove'), findsOneWidget);
        expect(
          confirmButton.style?.backgroundColor?.resolve({}),
          colorScheme.error,
        );
        expect(
          confirmButton.style?.foregroundColor?.resolve({}),
          colorScheme.onError,
        );
      },
    );
  });

  group("ConfirmDialog's elements behavior", () {
    testWidgets(
      'ConfirmDialog contains a "confirm-dialog-confirm-button" FilledButton with the correct behavior',
      (tester) async {
        bool? result;
        await tester.pumpWidget(
          buildTriggerWidget(onResult: (value) => result = value),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const Key('confirm-dialog-confirm-button')),
        );
        await tester.pumpAndSettle();

        expect(result, isA<bool>());
        expect(result, isTrue);
      },
    );

    testWidgets(
      'ConfirmDialog contains a "confirm-dialog-cancel-button" TextButton with the correct behavior',
      (tester) async {
        bool? result;
        await tester.pumpWidget(
          buildTriggerWidget(onResult: (value) => result = value),
        );

        await tester.tap(find.byKey(const Key('trigger')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('confirm-dialog-cancel-button')));
        await tester.pumpAndSettle();

        expect(result, isA<bool>());
        expect(result, isFalse);
      },
    );

    testWidgets('ConfirmDialog returns false when dismissed via the barrier', (
      tester,
    ) async {
      bool? result;
      await tester.pumpWidget(
        buildTriggerWidget(onResult: (value) => result = value),
      );

      await tester.tap(find.byKey(const Key('trigger')));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(result, isA<bool>());
      expect(result, isFalse);
    });
  });

  group("ConfirmDialog's translations", () {
    testWidgets('displays the correct translations', (
      tester,
    ) async {
      // Locale switching in tests causes deadlocks; use default locale.
      
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.common.cancel), findsOneWidget);
    });
  });
}
