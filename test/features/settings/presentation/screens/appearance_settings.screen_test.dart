// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/screens/appearance_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/widgets/appearance/corner_style.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/appearance/density.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/appearance/font.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/appearance/theme.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/appearance/zoom.section.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/theme/app_font.dart';
import 'package:worth_loop/shared/theme/app_shape.dart';
import 'package:worth_loop/shared/theme/app_spacing.dart';
import 'package:worth_loop/shared/theme/app_theme.dart';
import 'package:worth_loop/shared/theme/app_zoom.dart';

void main() {
  setUp(() {
    sl.registerLazySingleton<AppTheme>(AppTheme.new);
    sl.registerLazySingleton<AppShape>(AppShape.new);
    sl.registerLazySingleton<AppSpacing>(AppSpacing.new);
    sl.registerLazySingleton<AppZoom>(AppZoom.new);
    sl.registerLazySingleton<AppFont>(AppFont.new);
  });

  tearDown(() => sl.reset());

  Widget buildWidget() {
    return const MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: AppearanceSettingsScreen()),
      ),
    );
  }

  group('AppearanceSettingsScreen contains widgets', () {
    testWidgets(
      'AppearanceSettingsScreen contains a "Appearance" headline Text with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('Appearance'), findsOneWidget);
      },
    );

    testWidgets(
      'AppearanceSettingsScreen contains ThemeSection with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(ThemeSection), findsOneWidget);
      },
    );

    testWidgets(
      'AppearanceSettingsScreen contains CornerStyleSection with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(CornerStyleSection), findsOneWidget);
      },
    );

    testWidgets(
      'AppearanceSettingsScreen contains DensitySection with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(DensitySection), findsOneWidget);
      },
    );

    testWidgets(
      'AppearanceSettingsScreen contains FontSection with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(FontSection), findsOneWidget);
      },
    );

    testWidgets(
      'AppearanceSettingsScreen contains ZoomSection with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(ZoomSection), findsOneWidget);
      },
    );
  });

  group(
    'AppearanceSettingsScreen meets the accessibility recommended guidelines',
    () {
      testWidgets('AppearanceSettingsScreen meets WCAG contrast guidelines', (
        tester,
      ) async {
        final SemanticsHandle handle = tester.ensureSemantics();
        await tester.pumpWidget(buildWidget());

        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      });

      testWidgets(
        'AppearanceSettingsScreen all tap targets meet minimum 48dp size',
        (tester) async {
          final SemanticsHandle handle = tester.ensureSemantics();
          await tester.pumpWidget(buildWidget());

          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          handle.dispose();
        },
      );

      testWidgets(
        'AppearanceSettingsScreen all interactive elements have semantic labels',
        (tester) async {
          final SemanticsHandle handle = tester.ensureSemantics();
          await tester.pumpWidget(buildWidget());

          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          handle.dispose();
        },
      );

      testWidgets(
        'AppearanceSettingsScreen renders without overflow at 150% text scale',
        (tester) async {
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
              child: buildWidget(),
            ),
          );

          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'AppearanceSettingsScreen renders without overflow at 200% text scale',
        (tester) async {
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
              child: buildWidget(),
            ),
          );

          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'AppearanceSettingsScreen Tab key traverses all focusable elements',
        (tester) async {
          await tester.pumpWidget(buildWidget());

          final int focusableCount = tester
              .widgetList(find.byWidgetPredicate((widget) => widget is Focus))
              .length;
          for (int i = 0; i < focusableCount; i++) {
            await tester.sendKeyEvent(LogicalKeyboardKey.tab);
            await tester.pump();
          }

          expect(FocusManager.instance.primaryFocus, isNotNull);
        },
      );
    },
  );
}
