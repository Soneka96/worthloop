// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/presentation/widgets/product_refresh_indicator.widget.dart';
import 'package:worth_loop/shared/state/app.state.dart';

void main() {
  Widget buildWidget({
    String? blockedMessage,
    required Future<void> Function() onRefresh,
  }) {
    final Store<AppState> store = Store<AppState>(
      (AppState state, dynamic action) => state,
      initialState: AppState.initial(),
    );
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        home: ProductRefreshIndicator(
          blockedMessage: blockedMessage,
          onRefresh: onRefresh,
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) =>
                SizedBox(height: 80, child: Text('Item $index')),
          ),
        ),
      ),
    );
  }

  group('ProductRefreshIndicator contains widgets', () {
    testWidgets(
      'ProductRefreshIndicator contains a RefreshIndicator with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(onRefresh: () async {}));

        expect(find.byType(RefreshIndicator), findsOneWidget);
      },
    );
  });

  group("ProductRefreshIndicator's elements behavior", () {
    testWidgets(
      'ProductRefreshIndicator calls the normal refresh callback when no refresh is active',
      (WidgetTester tester) async {
        int refreshCount = 0;
        await tester.pumpWidget(
          buildWidget(onRefresh: () async => refreshCount++),
        );

        await tester.fling(find.byType(ListView), const Offset(0, 400), 1000);
        await tester.pumpAndSettle();

        expect(refreshCount, 1);
        expect(find.text('Another product is being checked'), findsNothing);
      },
    );

    testWidgets(
      'ProductRefreshIndicator shows blocked feedback after a blocked pull',
      (WidgetTester tester) async {
        int refreshCount = 0;
        await tester.pumpWidget(
          buildWidget(
            blockedMessage: 'Another product is being checked',
            onRefresh: () async => refreshCount++,
          ),
        );

        await tester.fling(find.byType(ListView), const Offset(0, 400), 1000);
        await tester.pump(const Duration(milliseconds: 500));

        expect(refreshCount, 0);
        expect(find.text('Another product is being checked'), findsOneWidget);
      },
    );
  });
}
