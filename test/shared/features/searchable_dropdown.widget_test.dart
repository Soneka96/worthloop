// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/features/searchable_dropdown.widget.dart';

void main() {
  Widget buildWidget({
    String selected = 'dracula',
    ValueChanged<String>? onSelected,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SearchableDropdown<String>(
          key: const Key('dropdown'),
          selected: selected,
          selectedLabel: selected,
          semanticLabel: 'Theme picker',
          onSelected: onSelected ?? (_) {},
          entries: const [
            DropdownMenuEntry(value: 'dracula', label: 'dracula'),
            DropdownMenuEntry(value: 'oneDarkPro', label: 'oneDarkPro'),
          ],
        ),
      ),
    );
  }

  group('SearchableDropdown contains widgets', () {
    testWidgets(
      'SearchableDropdown contains a "dropdown" SearchableDropdown with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget(selected: 'oneDarkPro'));

        final SearchableDropdown<String> searchableDropdown = tester.widget(
          find.byKey(const Key('dropdown')),
        );

        expect(searchableDropdown.selected, isA<String>());
        expect(searchableDropdown.selected, 'oneDarkPro');
        expect(searchableDropdown.selectedLabel, isA<String>());
        expect(searchableDropdown.selectedLabel, 'oneDarkPro');
      },
    );
  });

  group("SearchableDropdown's elements behavior", () {
    testWidgets(
      'SearchableDropdown displays an empty field when it gains focus',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.byKey(const Key('dropdown')));
        await tester.pumpAndSettle();

        final TextField field = tester.widget(find.byType(TextField).first);
        expect(field.controller?.text, isEmpty);
      },
    );

    testWidgets(
      'SearchableDropdown displays the selected label when focus is lost without picking',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.byKey(const Key('dropdown')));
        await tester.pumpAndSettle();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();

        final TextField field = tester.widget(find.byType(TextField).first);
        expect(field.controller?.text, 'dracula');
      },
    );

    testWidgets('SearchableDropdown calls onSelected when an entry is picked', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        buildWidget(onSelected: (value) => selected = value),
      );

      await tester.tap(find.byKey(const Key('dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('oneDarkPro').last);
      await tester.pumpAndSettle();

      expect(selected, isA<String>());
      expect(selected, 'oneDarkPro');
    });

    testWidgets(
      'SearchableDropdown does not call onSelected when focus is lost without picking',
      (tester) async {
        String? selected;
        await tester.pumpWidget(
          buildWidget(onSelected: (value) => selected = value),
        );

        await tester.tap(find.byKey(const Key('dropdown')));
        await tester.pumpAndSettle();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();

        expect(selected, isNull);
      },
    );
  });
}
