// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/settings_option_picker_row.widget.dart';
import 'package:worth_loop/features/settings/presentation/widgets/settings_option_preview_card.widget.dart';

void main() {
  Widget buildWidget({
    String selected = 'A',
    ValueChanged<String>? onSelected,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SettingsOptionPickerRow<String>(
          label: 'Pick one',
          options: const ['A', 'B'],
          isSelected: (option) => option == selected,
          onSelected: onSelected ?? (_) {},
          labelFor: (option) => option,
          previewFor: (option) => const SizedBox(height: 36),
        ),
      ),
    );
  }

  group('SettingsOptionPickerRow contains widgets', () {
    testWidgets('SettingsOptionPickerRow displays the given label', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Pick one'), findsOneWidget);
    });

    testWidgets(
      'SettingsOptionPickerRow contains one SettingsOptionPreviewCard per option',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(SettingsOptionPreviewCard), findsNWidgets(2));
      },
    );

    testWidgets('SettingsOptionPickerRow marks the currently selected option', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(selected: 'B'));

      final SettingsOptionPreviewCard cardB = tester.widget(
        find.byWidgetPredicate(
          (widget) =>
              widget is SettingsOptionPreviewCard && widget.label == 'B',
        ),
      );
      final SettingsOptionPreviewCard cardA = tester.widget(
        find.byWidgetPredicate(
          (widget) =>
              widget is SettingsOptionPreviewCard && widget.label == 'A',
        ),
      );

      expect(cardB.isSelected, isTrue);
      expect(cardA.isSelected, isFalse);
    });
  });

  group("SettingsOptionPickerRow's elements behavior", () {
    testWidgets(
      'SettingsOptionPickerRow calls onSelected with the tapped option',
      (tester) async {
        String? selectedOption;
        await tester.pumpWidget(
          buildWidget(onSelected: (option) => selectedOption = option),
        );

        await tester.tap(find.text('B'));
        await tester.pump();

        expect(selectedOption, 'B');
      },
    );
  });
}
