// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/language_picker_dropdown.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/theme/app_language.dart';

void main() {
  Widget buildWidget({
    AppLocale selectedLocale = AppLocale.en,
    ValueChanged<AppLocale>? onLocaleSelected,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: LanguagePickerDropdown(
          selectedLocale: selectedLocale,
          onLocaleSelected: onLocaleSelected ?? (_) {},
        ),
      ),
    );
  }

  group('LanguagePickerDropdown contains widgets', () {
    testWidgets(
      'LanguagePickerDropdown contains a "language-picker-dropdown" DropdownMenu with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget(selectedLocale: AppLocale.pt));

        final DropdownMenu<AppLocale> dropdown = tester.widget(
          find.byKey(const Key('language-picker-dropdown')),
        );

        expect(dropdown.initialSelection, AppLocale.pt);
        expect(dropdown.enableSearch, isFalse);
        expect(dropdown.selectOnly, isTrue);
      },
    );

    testWidgets(
      'LanguagePickerDropdown contains one entry per AppLocale value',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.byKey(const Key('language-picker-dropdown')));
        await tester.pumpAndSettle();

        for (final AppLocale locale in AppLocale.values) {
          expect(find.text(locale.label), findsWidgets);
        }
      },
    );
  });

  group("LanguagePickerDropdown's elements behavior", () {
    testWidgets(
      'LanguagePickerDropdown calls onLocaleSelected when a different language is selected',
      (tester) async {
        AppLocale? selected;
        await tester.pumpWidget(
          buildWidget(onLocaleSelected: (locale) => selected = locale),
        );

        await tester.tap(find.byKey(const Key('language-picker-dropdown')));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppLocale.pt.label).last);
        await tester.pumpAndSettle();

        expect(selected, AppLocale.pt);
      },
    );
  });
}
