// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/widgets/home_products_header.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';

void main() {
  Widget buildWidget({
    int productCount = 2,
    bool isRefreshing = false,
    int refreshCompletedCount = 0,
    int refreshTotalCount = 0,
    DateTime? latestUpdatedAt,
    bool omitUpdatedAt = false,
  }) => TranslationProvider(
    child: MaterialApp(
      home: Scaffold(
        body: HomeProductsHeader(
          productCount: productCount,
          isRefreshing: isRefreshing,
          refreshCompletedCount: refreshCompletedCount,
          refreshTotalCount: refreshTotalCount,
          latestUpdatedAt: omitUpdatedAt
              ? null
              : latestUpdatedAt ?? DateTime(2026, 8, 7, 21, 51),
        ),
      ),
    ),
  );

  testWidgets('HomeProductsHeader shows count and last updated time', (
    tester,
  ) async {
    await tester.pumpWidget(buildWidget());

    expect(
      find.textContaining(t.home.trackedProducts(count: 2)),
      findsOneWidget,
    );
    expect(find.textContaining(t.home.updatedAt(time: '')), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets('HomeProductsHeader shows compact refresh progress', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildWidget(
        isRefreshing: true,
        refreshCompletedCount: 18,
        refreshTotalCount: 42,
      ),
    );

    expect(
      find.text(t.home.refreshProgress(completed: 18, total: 42)),
      findsOneWidget,
    );
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets(
    'HomeProductsHeader omits update time when there are no products',
    (tester) async {
      await tester.pumpWidget(
        buildWidget(productCount: 0, omitUpdatedAt: true),
      );

      expect(find.text(t.home.trackedProducts(count: 0)), findsOneWidget);
      expect(find.textContaining(t.home.updatedAt(time: '')), findsNothing);
    },
  );

  testWidgets('HomeProductsHeader displays Portuguese translations', (
    tester,
  ) async {
    LocaleSettings.setLocale(AppLocale.pt);

    try {
      await tester.pumpWidget(buildWidget());
      expect(
        find.textContaining(t.home.trackedProducts(count: 2)),
        findsOneWidget,
      );
      expect(find.textContaining(t.home.updatedAt(time: '')), findsOneWidget);

      await tester.pumpWidget(
        buildWidget(
          isRefreshing: true,
          refreshCompletedCount: 18,
          refreshTotalCount: 42,
        ),
      );
      expect(
        find.text(t.home.refreshProgress(completed: 18, total: 42)),
        findsOneWidget,
      );
    } finally {
      LocaleSettings.setLocale(AppLocale.en);
    }
  });
}
