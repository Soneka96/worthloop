// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/settings_option_preview_card.widget.dart';

void main() {
  Widget buildWidget({
    String label = 'Rounded',
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SettingsOptionPreviewCard(
          label: label,
          isSelected: isSelected,
          onTap: onTap ?? () {},
          preview: const SizedBox(height: 36),
        ),
      ),
    );
  }

  group('SettingsOptionPreviewCard contains widgets', () {
    testWidgets('SettingsOptionPreviewCard displays the given label', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(label: 'Square'));

      expect(find.text('Square'), findsOneWidget);
    });

    testWidgets(
      'SettingsOptionPreviewCard has a wider border when isSelected = true',
      (tester) async {
        await tester.pumpWidget(buildWidget(isSelected: true));

        final Container container = tester.widget(
          find.descendant(
            of: find.byKey(const Key('settings-option-preview-card-rounded')),
            matching: find.byType(Container),
          ),
        );
        final BoxDecoration decoration = container.decoration as BoxDecoration;

        expect(decoration.border?.top.width, 2);
      },
    );

    testWidgets(
      'SettingsOptionPreviewCard has a thinner border when isSelected = false',
      (tester) async {
        await tester.pumpWidget(buildWidget(isSelected: false));

        final Container container = tester.widget(
          find.descendant(
            of: find.byKey(const Key('settings-option-preview-card-rounded')),
            matching: find.byType(Container),
          ),
        );
        final BoxDecoration decoration = container.decoration as BoxDecoration;

        expect(decoration.border?.top.width, 1);
      },
    );
  });

  group("SettingsOptionPreviewCard's elements behavior", () {
    testWidgets('SettingsOptionPreviewCard calls onTap when tapped', (
      tester,
    ) async {
      bool tapped = false;
      await tester.pumpWidget(buildWidget(onTap: () => tapped = true));

      await tester.tap(
        find.byKey(const Key('settings-option-preview-card-rounded')),
      );
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
