// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/features/fading_scroll_view.widget.dart';

void main() {
  Widget buildWidget({required Widget child}) {
    return MaterialApp(
      home: Scaffold(body: FadingScrollView(child: child)),
    );
  }

  group('FadingScrollView contains widgets', () {
    testWidgets('FadingScrollView renders its child', (tester) async {
      await tester.pumpWidget(buildWidget(child: const Text('content')));

      expect(find.text('content'), findsOneWidget);
    });

    testWidgets(
      'FadingScrollView contains a Scrollbar, FadingEdgeScrollView, and SingleChildScrollView with the correct parameters',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(child: const SizedBox(height: 2000)),
        );

        expect(find.byType(Scrollbar), findsOneWidget);
        expect(find.byType(FadingEdgeScrollView), findsOneWidget);

        final SingleChildScrollView scrollView = tester.widget(
          find.byType(SingleChildScrollView),
        );
        expect(
          scrollView.padding,
          const EdgeInsets.all(ScrollFadeSizes.gutter),
        );
      },
    );
  });

  group("FadingScrollView's elements behavior", () {
    testWidgets('FadingScrollView can be scrolled', (tester) async {
      await tester.pumpWidget(buildWidget(child: const SizedBox(height: 2000)));

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      final ScrollableState scrollable = tester.state(find.byType(Scrollable));
      expect(scrollable.position.pixels, greaterThan(0));
    });
  });
}
