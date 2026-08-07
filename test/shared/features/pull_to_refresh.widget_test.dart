// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/shared/features/pull_to_refresh.widget.dart';
import 'package:worth_loop/shared/state/app.state.dart';

void main() {
  Widget buildWidget({
    String? blockedMessage,
    required Future<void> Function() onRefresh,
    GlobalKey? contentKey,
  }) {
    final Store<AppState> store = Store<AppState>(
      (AppState state, dynamic action) => state,
      initialState: AppState.initial(),
    );
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        home: PullToRefreshWidget(
          blockedMessage: blockedMessage,
          onRefresh: onRefresh,
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) => SizedBox(
              key: index == 0 ? contentKey : null,
              height: 80,
              child: Text('Item $index'),
            ),
          ),
        ),
      ),
    );
  }

  group('PullToRefreshWidget contains widgets', () {
    testWidgets(
      'PullToRefreshWidget contains a RefreshIndicator with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(onRefresh: () async {}));

        expect(find.byType(RefreshIndicator), findsOneWidget);
      },
    );
  });

  group("PullToRefreshWidget's elements behavior", () {
    testWidgets(
      'PullToRefreshWidget calls onRefresh when no refresh is active',
      (WidgetTester tester) async {
        int refreshCount = 0;
        await tester.pumpWidget(
          buildWidget(onRefresh: () async => refreshCount++),
        );

        await tester.fling(find.byType(ListView), const Offset(0, 400), 1000);
        await tester.pumpAndSettle();

        expect(refreshCount, 1);
      },
    );

    testWidgets(
      'PullToRefreshWidget shows blocked text without a popup after a blocked pull',
      (WidgetTester tester) async {
        final GlobalKey contentKey = GlobalKey();
        await tester.pumpWidget(
          buildWidget(
            blockedMessage: 'Another product is being checked',
            onRefresh: () async {},
            contentKey: contentKey,
          ),
        );

        final double initialTop = tester.getTopLeft(find.byKey(contentKey)).dy;
        final TestGesture gesture = await tester.startGesture(
          const Offset(200, 200),
        );
        await gesture.moveBy(const Offset(0, 250));
        await tester.pump();

        expect(find.text('Another product is being checked'), findsOneWidget);
        expect(
          tester.getTopLeft(find.byKey(contentKey)).dy,
          greaterThan(initialTop),
        );
        expect(find.byType(AlertDialog), findsNothing);

        await gesture.up();
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'PullToRefreshWidget resets content when blocked state ends mid-gesture',
      (WidgetTester tester) async {
        final GlobalKey contentKey = GlobalKey();
        await tester.pumpWidget(
          buildWidget(
            blockedMessage: 'Another product is being checked',
            onRefresh: () async {},
            contentKey: contentKey,
          ),
        );

        final double initialTop = tester.getTopLeft(find.byKey(contentKey)).dy;
        await tester.fling(find.byType(ListView), const Offset(0, 400), 1000);
        await tester.pump(const Duration(milliseconds: 300));

        await tester.pumpWidget(
          buildWidget(onRefresh: () async {}, contentKey: contentKey),
        );
        await tester.pump(const Duration(milliseconds: 800));

        expect(tester.getTopLeft(find.byKey(contentKey)).dy, initialTop);
        expect(find.text('Another product is being checked'), findsNothing);
      },
    );

    testWidgets('PullToRefreshWidget resets content after a cancelled pull', (
      WidgetTester tester,
    ) async {
      final GlobalKey contentKey = GlobalKey();
      await tester.pumpWidget(
        buildWidget(
          blockedMessage: 'Another product is being checked',
          onRefresh: () async {},
          contentKey: contentKey,
        ),
      );

      final double initialTop = tester.getTopLeft(find.byKey(contentKey)).dy;
      await tester.dragFrom(const Offset(200, 200), const Offset(200, 250));
      await tester.pumpAndSettle();

      expect(tester.getTopLeft(find.byKey(contentKey)).dy, initialTop);
    });
  });
}
