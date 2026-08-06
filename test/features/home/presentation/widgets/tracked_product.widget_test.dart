// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/widgets/tracked_product.widget.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import '../../../products/fixtures/money.fixture.dart';
import '../../../products/fixtures/product.fixture.dart';
import '../../../products/fixtures/product_source.fixture.dart';

void main() {
  Widget buildWidget(Product product, {void Function()? onTap}) =>
      TranslationProvider(
        child: MaterialApp(
          home: Scaffold(
            body: TrackedProductWidget(product: product, onTap: onTap ?? () {}),
          ),
        ),
      );

  group('TrackedProductWidget contains widgets', () {
    testWidgets(
      'TrackedProductWidget contains product data with the correct parameters',
      (WidgetTester tester) async {
        final Product product = buildProduct(
          sources: [
            buildProductSource(
              currentPrice: buildMoney(minorUnits: 49999),
              isAvailable: true,
            ),
          ],
        );

        await tester.pumpWidget(buildWidget(product));

        expect(find.text('Example Product'), findsOneWidget);
        expect(find.text('499.99 €'), findsOneWidget);
        expect(find.text('example.com'), findsOneWidget);
        expect(find.text('Offers: 1'), findsOneWidget);
        expect(find.textContaining('Updated'), findsOneWidget);
      },
    );

    testWidgets(
      'TrackedProductWidget contains the lowest available price with the correct parameters',
      (WidgetTester tester) async {
        final ProductSource expensive = buildProductSource(
          merchantDomain: 'Expensive',
          currentPrice: buildMoney(minorUnits: 59999),
          isAvailable: true,
        );
        final ProductSource unavailable = buildProductSource(
          merchantDomain: 'Unavailable',
          currentPrice: buildMoney(minorUnits: 19999),
          isAvailable: false,
        );
        final ProductSource cheapest = buildProductSource(
          merchantDomain: 'Cheapest',
          currentPrice: buildMoney(minorUnits: 39999),
          isAvailable: true,
        );

        await tester.pumpWidget(
          buildWidget(
            buildProduct(sources: [expensive, unavailable, cheapest]),
          ),
        );

        expect(find.text('399.99 €'), findsOneWidget);
        expect(find.text('Cheapest'), findsOneWidget);
        expect(find.text('199.99 €'), findsNothing);
      },
    );

    testWidgets(
      'TrackedProductWidget contains no-availability copy with the correct parameters',
      (WidgetTester tester) async {
        final Product product = buildProduct(
          sources: [
            buildProductSource(
              currentPrice: buildMoney(minorUnits: 49999),
              isAvailable: false,
            ),
          ],
        );

        await tester.pumpWidget(buildWidget(product));

        expect(find.text('No available price'), findsOneWidget);
        expect(find.text('No store in stock'), findsOneWidget);
      },
    );
  });

  group("TrackedProductWidget's elements behavior", () {
    testWidgets(
      'TrackedProductWidget contains an InkWell with the correct behavior',
      (WidgetTester tester) async {
        final Product product = buildProduct();

        await tester.pumpWidget(
          buildWidget(product, onTap: () => print('onTap called')),
        );

        await expectLater(
          () => tester.tap(find.byKey(Key('tracked-product-${product.id}'))),
          prints('onTap called\n'),
        );
      },
    );
  });

  group("TrackedProductWidget's translations", () {
    testWidgets('TrackedProductWidget displays the Portuguese translations', (
      WidgetTester tester,
    ) async {
      final Product product = buildProduct(
        sources: [
          buildProductSource(
            currentPrice: buildMoney(minorUnits: 49999),
            isAvailable: true,
          ),
        ],
      );
      LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget(product));

        expect(find.text(t.home.bestPrice), findsOneWidget);
        expect(
          find.text(t.home.storeOffers(count: product.sources.length)),
          findsOneWidget,
        );
        expect(
          find.textContaining(t.home.updatedAt(time: '').trim()),
          findsOneWidget,
        );
      } finally {
        LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
