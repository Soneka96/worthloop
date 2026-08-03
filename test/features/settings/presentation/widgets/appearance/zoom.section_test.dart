// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/appearance/zoom.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/zoom_control.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/theme/app_zoom.dart';
import '../../../../../support/test_helper.dart';

void main() {
  late AppZoom appZoom;

  setUp(() {
    appZoom = AppZoom();
    sl.registerLazySingleton<AppZoom>(() => appZoom);
  });

  tearDown(() => sl.reset());

  Widget buildWidget() {
    return const MaterialApp(home: Scaffold(body: ZoomSection()));
  }

  group('ZoomSection contains widgets', () {
    testWidgets(
      'ZoomSection contains a "Text Size" section label with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('Text Size'), findsOneWidget);
      },
    );

    testWidgets(
      'ZoomSection contains a ZoomControl with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        final ZoomControl control = tester.widget(find.byType(ZoomControl));

        expect(control.currentLevel, appZoom.level);
      },
    );

    testWidgets(
      'ZoomSection contains the current zoom level as a percentage with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('${appZoom.level.toInt()}%'), findsOneWidget);
      },
    );

    testWidgets(
      'ZoomSection contains the current zoom level as a percentage with the correct parameters when the level changes',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        appZoom.setLevel(AppZoom.levels.last);
        await tester.pump();

        expect(find.text('${AppZoom.levels.last.toInt()}%'), findsOneWidget);
      },
    );
  });

  group("ZoomSection's translations", () {
    testWidgets('ZoomSection displays the correct translations', (
      tester,
    ) async {
      await TestHelper.pumpEachLocale(tester, buildWidget, () async {
        expect(find.text(t.settings.appearance.zoom), findsOneWidget);
      });
    });
  });
}
