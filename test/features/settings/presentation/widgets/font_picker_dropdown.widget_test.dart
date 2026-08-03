// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/font_picker_dropdown.widget.dart';
import 'package:worth_loop/shared/constants/enums.dart';

void main() {
  Widget buildWidget({
    FontId selectedFontId = FontId.systemDefault,
    ValueChanged<FontId>? onFontSelected,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: FontPickerDropdown(
          selectedFontId: selectedFontId,
          onFontSelected: onFontSelected ?? (_) {},
        ),
      ),
    );
  }

  group('FontPickerDropdown contains widgets', () {
    testWidgets(
      'FontPickerDropdown contains a "font-picker-dropdown" DropdownMenu with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget(selectedFontId: FontId.inter));

        final DropdownMenu<FontId> dropdown = tester.widget(
          find.byKey(const Key('font-picker-dropdown')),
        );

        expect(dropdown.initialSelection, FontId.inter);
        expect(dropdown.enableFilter, isTrue);
        expect(dropdown.enableSearch, isTrue);
      },
    );

    testWidgets('FontPickerDropdown does not offer FontId.none as an option', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      await tester.tap(find.byKey(const Key('font-picker-dropdown')));
      await tester.pumpAndSettle();

      expect(find.text(FontId.none.label), findsNothing);
    });

    testWidgets(
      'FontPickerDropdown shows at most 10 entries before any search text is entered',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.byKey(const Key('font-picker-dropdown')));
        await tester.pumpAndSettle();

        // FontId.values order: none (excluded), systemDefault, inter,
        // jetBrainsMono, bungee, pacifico, permanentMarker, pressStart2p,
        // monoton, playfairDisplay, oswald - exactly 10 - then caveat (11th)
        // onward should not be visible without narrowing the search first.
        expect(find.text(FontId.oswald.label), findsOneWidget);
        expect(find.text(FontId.caveat.label), findsNothing);
      },
    );
  });

  group("FontPickerDropdown's elements behavior", () {
    testWidgets(
      'FontPickerDropdown calls onFontSelected when a different preset is selected',
      (tester) async {
        FontId? selected;
        await tester.pumpWidget(
          buildWidget(onFontSelected: (fontId) => selected = fontId),
        );

        await tester.tap(find.byKey(const Key('font-picker-dropdown')));
        await tester.pumpAndSettle();
        await tester.tap(find.text(FontId.inter.label).last);
        await tester.pumpAndSettle();

        expect(selected, FontId.inter);
      },
    );

    testWidgets(
      'FontPickerDropdown search matches the raw preset name as well as the pretty label',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.byKey(const Key('font-picker-dropdown')));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.descendant(
            of: find.byKey(const Key('font-picker-dropdown')),
            matching: find.byType(TextField),
          ),
          'jetbrainsmono',
        );
        await tester.pumpAndSettle();

        expect(find.text(FontId.jetBrainsMono.label), findsWidgets);
      },
    );

    testWidgets(
      'FontPickerDropdown filters from the full preset list every time, not whatever a previous search already narrowed it to',
      (tester) async {
        await tester.pumpWidget(buildWidget());
        final Finder searchField = find.descendant(
          of: find.byKey(const Key('font-picker-dropdown')),
          matching: find.byType(TextField),
        );

        await tester.tap(find.byKey(const Key('font-picker-dropdown')));
        await tester.pumpAndSettle();
        await tester.enterText(searchField, 'jetbrainsmono');
        await tester.pumpAndSettle();
        await tester.enterText(searchField, '');
        await tester.pumpAndSettle();

        expect(find.text(FontId.systemDefault.label), findsWidgets);
        expect(find.text(FontId.inter.label), findsWidgets);
        expect(find.text(FontId.jetBrainsMono.label), findsWidgets);
      },
    );
  });
}
