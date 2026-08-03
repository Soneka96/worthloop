// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/appearance/density.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/settings_option_preview_card.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_spacing.dart';
import '../../../../../support/test_helper.dart';

void main() {
  late AppSpacing appSpacing;

  setUp(() {
    appSpacing = AppSpacing();
    sl.registerLazySingleton<AppSpacing>(() => appSpacing);
  });

  tearDown(() => sl.reset());

  Widget buildWidget() {
    return const MaterialApp(home: Scaffold(body: DensitySection()));
  }

  group('DensitySection contains widgets', () {
    testWidgets(
      'DensitySection contains a selected SettingsOptionPreviewCard for the current density',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        final SettingsOptionPreviewCard card = tester.widget(
          find.byWidgetPredicate(
            (widget) =>
                widget is SettingsOptionPreviewCard &&
                widget.label == SpacingDensity.comfortable.label,
          ),
        );

        expect(card.isSelected, isTrue);
      },
    );
  });

  group("DensitySection's elements behavior", () {
    testWidgets(
      'Tapping the Compact density card calls appSpacing.setDensity',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.text(SpacingDensity.compact.label));
        await tester.pump();

        expect(appSpacing.density, SpacingDensity.compact);
      },
    );
  });

  group("DensitySection's translations", () {
    testWidgets('DensitySection displays the correct translations', (
      tester,
    ) async {
      await TestHelper.pumpEachLocale(tester, buildWidget, () async {
        expect(find.text(t.settings.appearance.density), findsOneWidget);
        expect(find.text(SpacingDensity.comfortable.label), findsOneWidget);
        expect(find.text(SpacingDensity.compact.label), findsOneWidget);
      });
    });
  });
}
