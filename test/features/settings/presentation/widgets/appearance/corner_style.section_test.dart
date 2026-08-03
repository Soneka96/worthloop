// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/appearance/corner_style.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/settings_option_preview_card.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_shape.dart';
import '../../../../../support/test_helper.dart';

void main() {
  late AppShape appShape;

  setUp(() {
    appShape = AppShape();
    sl.registerLazySingleton<AppShape>(() => appShape);
  });

  tearDown(() => sl.reset());

  Widget buildWidget() {
    return const MaterialApp(home: Scaffold(body: CornerStyleSection()));
  }

  group('CornerStyleSection contains widgets', () {
    testWidgets(
      'CornerStyleSection contains a selected SettingsOptionPreviewCard for the current corner style',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        final SettingsOptionPreviewCard card = tester.widget(
          find.byWidgetPredicate(
            (widget) =>
                widget is SettingsOptionPreviewCard &&
                widget.label == CornerStyle.rounded.label,
          ),
        );

        expect(card.isSelected, isTrue);
      },
    );
  });

  group("CornerStyleSection's elements behavior", () {
    testWidgets(
      'Tapping the Square corner style card calls appShape.setCornerStyle',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.text(CornerStyle.square.label));
        await tester.pump();

        expect(appShape.cornerStyle, CornerStyle.square);
      },
    );
  });

  group("CornerStyleSection's translations", () {
    testWidgets('CornerStyleSection displays the correct translations', (
      tester,
    ) async {
      await TestHelper.pumpEachLocale(tester, buildWidget, () async {
        expect(find.text(t.settings.appearance.cornerStyle), findsOneWidget);
        expect(find.text(CornerStyle.rounded.label), findsOneWidget);
        expect(find.text(CornerStyle.square.label), findsOneWidget);
      });
    });
  });
}
