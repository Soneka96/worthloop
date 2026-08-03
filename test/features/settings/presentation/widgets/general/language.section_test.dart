// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/general/language.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/language_picker_dropdown.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/theme/app_language.dart';
import '../../../../../support/test_helper.dart';

void main() {
  late AppLanguage appLanguage;

  setUp(() {
    appLanguage = AppLanguage();
    sl.registerLazySingleton<AppLanguage>(() => appLanguage);
  });

  tearDown(() => sl.reset());

  Widget buildWidget() {
    return const MaterialApp(home: Scaffold(body: LanguageSection()));
  }

  group('LanguageSection contains widgets', () {
    testWidgets(
      'LanguageSection contains a "Language" section label with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('Language'), findsOneWidget);
      },
    );

    testWidgets(
      'LanguageSection contains a LanguagePickerDropdown for the current locale',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        final LanguagePickerDropdown dropdown = tester.widget(
          find.byType(LanguagePickerDropdown),
        );

        expect(dropdown.selectedLocale, appLanguage.locale);
      },
    );
  });

  group("LanguageSection's elements behavior", () {
    testWidgets(
      'Selecting Português in the language dropdown calls appLanguage.setLocale',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.byKey(const Key('language-picker-dropdown')));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppLocale.pt.label).last);
        await tester.pumpAndSettle();

        expect(appLanguage.locale, AppLocale.pt);
      },
    );
  });

  group("LanguageSection's translations", () {
    testWidgets('LanguageSection displays the correct translations', (
      tester,
    ) async {
      await TestHelper.pumpEachLocale(tester, buildWidget, () async {
        expect(find.text(t.settings.general.language.title), findsOneWidget);
      });
    });
  });
}
