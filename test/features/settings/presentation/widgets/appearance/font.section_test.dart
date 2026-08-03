// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/appearance/font.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/font_picker_dropdown.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_font.dart';
import '../../../../../support/test_helper.dart';

void main() {
  late AppFont appFont;

  setUp(() {
    appFont = AppFont();
    sl.registerLazySingleton<AppFont>(() => appFont);
  });

  tearDown(() => sl.reset());

  Widget buildWidget() {
    return const MaterialApp(home: Scaffold(body: FontSection()));
  }

  group('FontSection contains widgets', () {
    testWidgets(
      'FontSection contains a "Font" section label with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('Font'), findsOneWidget);
      },
    );

    testWidgets(
      'FontSection contains a FontPickerDropdown for the current font',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        final FontPickerDropdown dropdown = tester.widget(
          find.byType(FontPickerDropdown),
        );

        expect(dropdown.selectedFontId, appFont.fontId);
      },
    );
  });

  group("FontSection's elements behavior", () {
    testWidgets('Selecting Inter in the font dropdown calls appFont.setFont', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      await tester.tap(find.byKey(const Key('font-picker-dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(FontId.inter.label).last);
      await tester.pumpAndSettle();

      expect(appFont.fontId, FontId.inter);
    });
  });

  group("FontSection's translations", () {
    testWidgets('FontSection displays the correct translations', (
      tester,
    ) async {
      await TestHelper.pumpEachLocale(tester, buildWidget, () async {
        expect(find.text(t.settings.appearance.font), findsOneWidget);
      });
    });
  });
}
