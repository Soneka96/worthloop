// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/theme_card.widget.dart';
import 'package:worth_loop/features/settings/presentation/widgets/theme_card_preview.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import '../../../../support/test_helper.dart';

void main() {
  Widget buildWidget({
    Brightness brightness = Brightness.dark,
    ThemeId selectedThemeId = ThemeId.dracula,
    bool isActive = false,
    double cornerRadius = 20.0,
    ValueChanged<ThemeId>? onThemeSelected,
    VoidCallback? onActivate,
  }) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [AppShapeThemeExtension(cornerRadius: cornerRadius)],
      ),
      home: Scaffold(
        body: ThemeCard(
          brightness: brightness,
          selectedThemeId: selectedThemeId,
          isActive: isActive,
          onThemeSelected: onThemeSelected ?? (_) {},
          onActivate: onActivate ?? () {},
        ),
      ),
    );
  }

  group('ThemeCard contains widgets', () {
    testWidgets(
      'ThemeCard contains a "theme-card-dark" Container with the correct parameters when isActive = true',
      (tester) async {
        await tester.pumpWidget(buildWidget(isActive: true));

        final Container container = tester.widget(
          find.byKey(const Key('theme-card-dark')),
        );
        final BoxDecoration decoration = container.decoration as BoxDecoration;

        expect(decoration.border?.top.width, 2);
      },
    );

    testWidgets(
      'ThemeCard contains a "theme-card-dark" Container with the correct parameters when isActive = false',
      (tester) async {
        await tester.pumpWidget(buildWidget(isActive: false));

        final Container container = tester.widget(
          find.byKey(const Key('theme-card-dark')),
        );
        final BoxDecoration decoration = container.decoration as BoxDecoration;

        expect(decoration.border?.top.width, 1);
      },
    );

    testWidgets(
      'ThemeCard contains a "theme-card-dark-dropdown" DropdownMenu with the correct parameters',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(selectedThemeId: ThemeId.oneDarkPro),
        );

        final DropdownMenu<ThemeId> dropdown = tester.widget(
          find.byKey(const Key('theme-card-dark-dropdown')),
        );

        expect(dropdown.initialSelection, ThemeId.oneDarkPro);
        expect(dropdown.enableFilter, isTrue);
        expect(dropdown.enableSearch, isTrue);
      },
    );

    testWidgets(
      'ThemeCard contains a "theme-card-dark" Container with decoration.borderRadius = cornerRadius when cornerRadius = 4.0',
      (tester) async {
        await tester.pumpWidget(buildWidget(cornerRadius: 4.0));

        final Container container = tester.widget(
          find.byKey(const Key('theme-card-dark')),
        );
        final BoxDecoration decoration = container.decoration as BoxDecoration;

        expect(decoration.borderRadius, BorderRadius.circular(4.0));
      },
    );

    testWidgets(
      'ThemeCard contains a ThemeCardPreview with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget(selectedThemeId: ThemeId.dracula));

        expect(find.byType(ThemeCardPreview), findsOneWidget);
      },
    );

    testWidgets('ThemeCard shows an "Active" chip when isActive = true', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(isActive: true));

      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('ThemeCard shows no "Active" chip when isActive = false', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(isActive: false));

      expect(find.text('Active'), findsNothing);
    });

    testWidgets(
      'ThemeCard shows an "Active" chip with the same cornerRadius as the card, not a fixed value',
      (tester) async {
        await tester.pumpWidget(buildWidget(isActive: true, cornerRadius: 4.0));

        final Container badge = tester.widget(
          find.byKey(const Key('theme-card-dark-active-badge')),
        );
        final BoxDecoration decoration = badge.decoration as BoxDecoration;

        expect(decoration.borderRadius, BorderRadius.circular(4.0));
      },
    );
  });

  group("ThemeCard's elements behavior", () {
    testWidgets('ThemeCard calls onActivate when the preview is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWidget(onActivate: () => print('onActivate called')),
      );

      await expectLater(
        () => tester.tap(find.byKey(const Key('theme-card-dark-preview'))),
        prints('onActivate called\n'),
      );
    });

    testWidgets(
      'ThemeCard calls onThemeSelected when a different preset is selected',
      (tester) async {
        ThemeId? selected;
        await tester.pumpWidget(
          buildWidget(onThemeSelected: (id) => selected = id),
        );

        await tester.tap(find.byKey(const Key('theme-card-dark-dropdown')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('One Dark Pro').last);
        await tester.pumpAndSettle();

        expect(selected, ThemeId.oneDarkPro);
      },
    );

    testWidgets(
      'ThemeCard dropdown shows the pretty label, not the raw preset name',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.byKey(const Key('theme-card-dark-dropdown')));
        await tester.pumpAndSettle();

        expect(find.text('One Dark Pro'), findsWidgets);
        expect(find.text('oneDarkPro'), findsNothing);
      },
    );

    testWidgets(
      'ThemeCard dropdown search matches the raw preset name as well as the pretty label',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.byKey(const Key('theme-card-dark-dropdown')));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.descendant(
            of: find.byKey(const Key('theme-card-dark-dropdown')),
            matching: find.byType(TextField),
          ),
          'onedarkpro',
        );
        await tester.pumpAndSettle();

        expect(find.text('One Dark Pro'), findsWidgets);
      },
    );
  });

  group("ThemeCard's translations", () {
    testWidgets('ThemeCard displays the correct translations', (tester) async {
      final SemanticsHandle semanticsHandle = tester.ensureSemantics();
      await TestHelper.pumpEachLocale(
        tester,
        () => buildWidget(brightness: Brightness.dark, isActive: true),
        () async {
          expect(find.text(t.settings.appearance.dark), findsOneWidget);
          expect(find.text(t.settings.appearance.active), findsOneWidget);
          final SemanticsNode previewSemantics = tester.getSemantics(
            find.byKey(const Key('theme-card-dark-preview')),
          );
          expect(
            previewSemantics.label,
            contains(
              t.settings.appearance.activateThemeSemantics(
                label: t.settings.appearance.dark,
              ),
            ),
          );
        },
      );
      semanticsHandle.dispose();
    });
  });
}
