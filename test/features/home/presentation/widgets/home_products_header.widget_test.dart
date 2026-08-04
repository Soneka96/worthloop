// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/widgets/home_products_header.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';

void main() {
  Widget buildWidget({
    int productCount = 2,
    bool isRefreshingAll = false,
    bool isLoading = false,
    VoidCallback? onRefreshAll,
  }) => TranslationProvider(
    child: MaterialApp(
      home: Scaffold(
        body: HomeProductsHeader(
          productCount: productCount,
          isRefreshingAll: isRefreshingAll,
          isLoading: isLoading,
          onRefreshAll: onRefreshAll ?? () {},
        ),
      ),
    ),
  );

  group('HomeProductsHeader contains widgets', () {
    testWidgets(
      'HomeProductsHeader contains product count and enabled refresh button when productCount > 0',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        final FilledButton button = tester.widget(
          find.byKey(const Key('home-refresh-all-button')),
        );

        expect(find.text(t.home.trackedProducts(count: 2)), findsOneWidget);
        expect(button.onPressed, isA<VoidCallback>());
        expect(button.onPressed, isNotNull);
        expect(find.text(t.home.refreshAll), findsOneWidget);
      },
    );

    testWidgets(
      'HomeProductsHeader contains disabled refresh button when isLoading = true',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(isLoading: true));

        final FilledButton button = tester.widget(
          find.byKey(const Key('home-refresh-all-button')),
        );

        expect(button.onPressed, isNull);
      },
    );

    testWidgets(
      'HomeProductsHeader contains disabled refresh button when productCount = 0',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(productCount: 0));

        final FilledButton button = tester.widget(
          find.byKey(const Key('home-refresh-all-button')),
        );

        expect(button.onPressed, isNull);
      },
    );

    testWidgets(
      'HomeProductsHeader contains loading refresh state when isRefreshingAll = true',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(isRefreshingAll: true));

        final FilledButton button = tester.widget(
          find.byKey(const Key('home-refresh-all-button')),
        );

        expect(button.onPressed, isNull);
        expect(find.text(t.home.refreshing), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );
  });

  group("HomeProductsHeader's elements behavior", () {
    testWidgets('HomeProductsHeader calls onRefreshAll when productCount > 0', (
      WidgetTester tester,
    ) async {
      bool wasRefreshed = false;

      await tester.pumpWidget(
        buildWidget(onRefreshAll: () => wasRefreshed = true),
      );

      await tester.tap(find.byKey(const Key('home-refresh-all-button')));

      expect(wasRefreshed, isA<bool>());
      expect(wasRefreshed, isTrue);
    });

    testWidgets(
      'HomeProductsHeader does not call onRefreshAll when isLoading = true',
      (WidgetTester tester) async {
        bool wasRefreshed = false;

        await tester.pumpWidget(
          buildWidget(isLoading: true, onRefreshAll: () => wasRefreshed = true),
        );

        await tester.tap(find.byKey(const Key('home-refresh-all-button')));

        expect(wasRefreshed, isA<bool>());
        expect(wasRefreshed, isFalse);
      },
    );

    testWidgets(
      'HomeProductsHeader does not call onRefreshAll when productCount = 0',
      (WidgetTester tester) async {
        bool wasRefreshed = false;

        await tester.pumpWidget(
          buildWidget(productCount: 0, onRefreshAll: () => wasRefreshed = true),
        );

        await tester.tap(find.byKey(const Key('home-refresh-all-button')));

        expect(wasRefreshed, isA<bool>());
        expect(wasRefreshed, isFalse);
      },
    );

    testWidgets(
      'HomeProductsHeader does not call onRefreshAll when isRefreshingAll = true',
      (WidgetTester tester) async {
        bool wasRefreshed = false;

        await tester.pumpWidget(
          buildWidget(
            isRefreshingAll: true,
            onRefreshAll: () => wasRefreshed = true,
          ),
        );

        await tester.tap(find.byKey(const Key('home-refresh-all-button')));

        expect(wasRefreshed, isA<bool>());
        expect(wasRefreshed, isFalse);
      },
    );
  });

  group("HomeProductsHeader's translations", () {
    testWidgets('HomeProductsHeader displays the Portuguese translations', (
      WidgetTester tester,
    ) async {
      LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.home.trackedProducts(count: 2)), findsOneWidget);
        expect(find.text(t.home.refreshAll), findsOneWidget);
      } finally {
        LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
