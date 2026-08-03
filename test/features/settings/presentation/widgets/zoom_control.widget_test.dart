// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/zoom_control.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/theme/app_zoom.dart';
import '../../../../support/test_helper.dart';

void main() {
  Widget buildWidget({
    double currentLevel = 100,
    ValueChanged<double>? onLevelChanged,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ZoomControl(
          currentLevel: currentLevel,
          onLevelChanged: onLevelChanged ?? (_) {},
        ),
      ),
    );
  }

  group('ZoomControl contains widgets', () {
    testWidgets('ZoomControl contains a zoom-out and a zoom-in icon', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      expect(
        find.byKey(const Key('zoom-control-zoom-out-icon')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('zoom-control-zoom-in-icon')),
        findsOneWidget,
      );
    });

    testWidgets('ZoomControl contains five dot indicators', (tester) async {
      await tester.pumpWidget(buildWidget());

      for (final double level in AppZoom.levels) {
        expect(
          find.byKey(Key('zoom-control-dot-${level.toInt()}')),
          findsOneWidget,
          reason: 'expected a dot for level $level',
        );
      }
    });

    testWidgets('ZoomControl contains a thumb indicator', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byKey(const Key('zoom-control-thumb')), findsOneWidget);
    });

    testWidgets(
      'ZoomControl positions the thumb further right for a higher currentLevel',
      (tester) async {
        Finder thumbPositioned() => find.ancestor(
          of: find.byKey(const Key('zoom-control-thumb')),
          matching: find.byType(AnimatedPositioned),
        );

        await tester.pumpWidget(buildWidget(currentLevel: 75));
        final double leftAtMin = tester
            .widget<AnimatedPositioned>(thumbPositioned())
            .left!;

        await tester.pumpWidget(buildWidget(currentLevel: 150));
        final double leftAtMax = tester
            .widget<AnimatedPositioned>(thumbPositioned())
            .left!;

        expect(leftAtMax, greaterThan(leftAtMin));
      },
    );
  });

  group("ZoomControl's elements behavior", () {
    testWidgets(
      'dragging to a step and releasing calls onLevelChanged with that step value',
      (tester) async {
        double? changedLevel;
        await tester.pumpWidget(
          buildWidget(onLevelChanged: (double level) => changedLevel = level),
        );

        final Finder trackFinder = find.byKey(const Key('zoom-control-track'));
        final Offset topLeft = tester.getTopLeft(trackFinder);
        final Size size = tester.getSize(trackFinder);
        final Offset start = topLeft + Offset(0, size.height / 2);
        final Offset end = topLeft + Offset(size.width, size.height / 2);

        final TestGesture gesture = await tester.startGesture(start);
        const int steps = 10;
        for (int i = 1; i <= steps; i++) {
          await gesture.moveTo(
            start + Offset((end.dx - start.dx) * i / steps, 0),
          );
          await tester.pump();
        }
        await gesture.up();
        await tester.pump();

        expect(changedLevel, AppZoom.levels.last);
      },
    );

    testWidgets('dragging without releasing does not call onLevelChanged', (
      tester,
    ) async {
      double? changedLevel;
      await tester.pumpWidget(
        buildWidget(onLevelChanged: (double level) => changedLevel = level),
      );

      final Finder trackFinder = find.byKey(const Key('zoom-control-track'));
      final Offset topLeft = tester.getTopLeft(trackFinder);
      final Size size = tester.getSize(trackFinder);
      final Offset start = topLeft + Offset(0, size.height / 2);
      final Offset end = topLeft + Offset(size.width, size.height / 2);

      final TestGesture gesture = await tester.startGesture(start);
      const int steps = 10;
      for (int i = 1; i <= steps; i++) {
        await gesture.moveTo(
          start + Offset((end.dx - start.dx) * i / steps, 0),
        );
        await tester.pump();
      }

      expect(changedLevel, isNull);

      await gesture.up();
    });

    testWidgets(
      'tapping the track calls onLevelChanged with the nearest level',
      (tester) async {
        double? changedLevel;
        await tester.pumpWidget(
          buildWidget(onLevelChanged: (double level) => changedLevel = level),
        );

        final Finder trackFinder = find.byKey(const Key('zoom-control-track'));
        final Offset topLeft = tester.getTopLeft(trackFinder);
        final Size size = tester.getSize(trackFinder);

        await tester.tapAt(topLeft + Offset(size.width - 1, size.height / 2));
        await tester.pumpAndSettle();

        expect(changedLevel, AppZoom.levels.last);
      },
    );
  });

  group("ZoomControl's translations", () {
    testWidgets('ZoomControl displays the correct translations', (
      tester,
    ) async {
      final SemanticsHandle semanticsHandle = tester.ensureSemantics();
      await TestHelper.pumpEachLocale(tester, buildWidget, () async {
        final SemanticsNode trackSemantics = tester.getSemantics(
          find.byKey(const Key('zoom-control-track')),
        );
        expect(
          trackSemantics.label,
          contains(t.settings.appearance.zoomLevelSemantics),
        );
      });
      semanticsHandle.dispose();
    });
  });
}
