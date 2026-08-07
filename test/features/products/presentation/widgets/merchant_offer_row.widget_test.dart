// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

// Package imports:
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/features/products/presentation/widgets/best_price_stamp.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/merchant_offer_row.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_shape_presets.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import '../../fixtures/product_source.fixture.dart';

void main() {
  ProductSource buildSource() => buildProductSource(
    id: 'source-1',
    merchantDomain: 'example.com',
    currentPrice: const Money(minorUnits: 49999, currencyCode: 'EUR'),
    isAvailable: true,
    lastCheckedAt: DateTime(2026, 1, 1, 14, 30),
  );

  Widget buildWidget({
    ProductSource? source,
    bool isBestPrice = false,
    bool isDeleting = false,
    SourceRefreshStatus refreshStatus = SourceRefreshStatus.idle,
    double? cornerRadius,
    VoidCallback? onTap,
    VoidCallback? onEdit,
    VoidCallback? onRefresh,
    VoidCallback? onDelete,
  }) => TranslationProvider(
    child: MaterialApp(
      theme: ThemeData(
        extensions: [
          if (cornerRadius != null)
            AppShapeThemeExtension(cornerRadius: cornerRadius),
        ],
      ),
      home: Scaffold(
        body: MerchantOfferRow(
          source: source ?? buildSource(),
          isBestPrice: isBestPrice,
          isDeleting: isDeleting,
          refreshStatus: refreshStatus,
          onTap: onTap ?? () {},
          onEdit: onEdit ?? () {},
          onRefresh: onRefresh ?? () {},
          onDelete: onDelete ?? () {},
        ),
      ),
    ),
  );

  group('MerchantOfferRow contains widgets', () {
    testWidgets(
      'MerchantOfferRow contains the merchant domain and price with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('merchant-offer-source-1')),
          findsOneWidget,
        );
        expect(find.text('example.com'), findsOneWidget);
        expect(find.text('499.99 €'), findsOneWidget);
        expect(find.text(t.productDetails.available), findsOneWidget);
        expect(find.textContaining('Checked at'), findsOneWidget);
      },
    );

    testWidgets('MerchantOfferRow displays a price drop with its change date', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildWidget(
          source: buildProductSource(
            currentPrice: const Money(minorUnits: 39999, currencyCode: 'EUR'),
            previousPrice: const Money(minorUnits: 49999, currencyCode: 'EUR'),
            isAvailable: true,
            priceChangedAt: DateTime(2026, 8, 3),
          ),
        ),
      );

      expect(find.textContaining('↓ 100.00'), findsOneWidget);
      expect(
        find.byKey(const Key('merchant-offer-source-1-price-change')),
        findsOneWidget,
      );
    });

    testWidgets(
      'MerchantOfferRow displays a price increase with its change date',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(
            source: buildProductSource(
              currentPrice: const Money(minorUnits: 59999, currencyCode: 'EUR'),
              previousPrice: const Money(
                minorUnits: 49999,
                currencyCode: 'EUR',
              ),
              isAvailable: true,
              priceChangedAt: DateTime(2026, 8, 5),
            ),
          ),
        );

        expect(find.textContaining('↑ 100.00'), findsOneWidget);
      },
    );

    testWidgets(
      'MerchantOfferRow does not display a price change without compatible history',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(
            source: buildProductSource(
              currentPrice: const Money(minorUnits: 49999, currencyCode: 'EUR'),
              previousPrice: const Money(
                minorUnits: 49999,
                currencyCode: 'USD',
              ),
              isAvailable: true,
              priceChangedAt: DateTime(2026, 8, 3),
            ),
          ),
        );

        expect(
          find.byKey(const Key('merchant-offer-source-1-price-change')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'MerchantOfferRow displays the unavailable status when source.isAvailable = false',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(
            source: buildProductSource(
              id: 'source-1',
              merchantDomain: 'example.com',
              isAvailable: false,
            ),
          ),
        );

        expect(find.text(t.productDetails.unavailable), findsOneWidget);
      },
    );

    testWidgets(
      'MerchantOfferRow displays the checking status when refreshStatus = SourceRefreshStatus.fetching',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(refreshStatus: SourceRefreshStatus.fetching),
        );

        expect(find.text(t.productDetails.checking), findsOneWidget);
      },
    );

    testWidgets(
      'MerchantOfferRow disables its refresh slide action while checking',
      (WidgetTester tester) async {
        bool refreshed = false;
        await tester.pumpWidget(
          buildWidget(
            refreshStatus: SourceRefreshStatus.fetching,
            onRefresh: () => refreshed = true,
          ),
        );

        await tester.drag(
          find.byKey(const Key('merchant-offer-source-1')),
          const Offset(-500, 0),
        );
        await tester.pump();
        await tester.tap(
          find.byKey(const Key('merchant-offer-source-1-refresh-action')),
        );

        expect(refreshed, isFalse);
      },
    );

    testWidgets(
      'MerchantOfferRow displays terminal refresh statuses with correct labels',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(refreshStatus: SourceRefreshStatus.error),
        );
        expect(find.text(t.productDetails.cannotAccessNow), findsOneWidget);

        await tester.pumpWidget(
          buildWidget(refreshStatus: SourceRefreshStatus.queued),
        );
        expect(find.text(t.productDetails.queued), findsOneWidget);

        await tester.pumpWidget(
          buildWidget(refreshStatus: SourceRefreshStatus.unavailable),
        );
        expect(find.text(t.productDetails.unavailable), findsOneWidget);

        await tester.pumpWidget(
          buildWidget(refreshStatus: SourceRefreshStatus.success),
        );
        expect(find.text(t.productDetails.available), findsOneWidget);
      },
    );

    testWidgets(
      'MerchantOfferRow uses a distinct tonal surface for each refresh state',
      (WidgetTester tester) async {
        final Map<SourceRefreshStatus, Color Function(ColorScheme)> surfaces = {
          SourceRefreshStatus.queued: (ColorScheme colors) =>
              colors.primaryContainer,
          SourceRefreshStatus.fetching: (ColorScheme colors) =>
              colors.primaryContainer,
          SourceRefreshStatus.error: (ColorScheme colors) =>
              colors.errorContainer,
          SourceRefreshStatus.unavailable: (ColorScheme colors) =>
              colors.secondaryContainer,
          SourceRefreshStatus.success: (ColorScheme colors) =>
              colors.tertiaryContainer,
          SourceRefreshStatus.none: (ColorScheme colors) =>
              colors.surfaceContainerLow,
          SourceRefreshStatus.idle: (ColorScheme colors) =>
              colors.surfaceContainerLow,
        };

        for (final MapEntry<SourceRefreshStatus, Color Function(ColorScheme)>
            entry
            in surfaces.entries) {
          await tester.pumpWidget(buildWidget(refreshStatus: entry.key));
          final BuildContext context = tester.element(
            find.byType(MerchantOfferRow),
          );
          final ColorScheme colorScheme = Theme.of(context).colorScheme;
          final Material row = tester.widget(
            find
                .ancestor(
                  of: find.byKey(
                    const Key('merchant-offer-source-1-refresh-status'),
                  ),
                  matching: find.byType(Material),
                )
                .first,
          );

          expect(row.color, entry.value(colorScheme));
        }
      },
    );

    testWidgets(
      'MerchantOfferRow shows a neutral help icon for an idle unavailable source',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(
            source: buildProductSource(isAvailable: false),
            refreshStatus: SourceRefreshStatus.idle,
          ),
        );

        expect(find.byIcon(Icons.help_outline), findsOneWidget);
      },
    );

    testWidgets(
      'MerchantOfferRow gives terminal refresh statuses visible icons',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(refreshStatus: SourceRefreshStatus.queued),
        );
        expect(find.byIcon(Icons.hourglass_empty), findsOneWidget);

        await tester.pumpWidget(
          buildWidget(refreshStatus: SourceRefreshStatus.error),
        );
        expect(find.byIcon(Icons.error_outline), findsOneWidget);

        await tester.pumpWidget(
          buildWidget(refreshStatus: SourceRefreshStatus.unavailable),
        );
        expect(find.byIcon(Icons.remove_circle_outline), findsOneWidget);

        await tester.pumpWidget(
          buildWidget(refreshStatus: SourceRefreshStatus.success),
        );
        expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      },
    );

    testWidgets(
      'MerchantOfferRow uses a progress indicator and status surface while checking',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(refreshStatus: SourceRefreshStatus.fetching),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        final Material row = tester.widget(
          find
              .ancestor(
                of: find.byKey(
                  const Key('merchant-offer-source-1-refresh-status'),
                ),
                matching: find.byType(Material),
              )
              .first,
        );
        final ColorScheme colorScheme = Theme.of(
          tester.element(find.byType(MerchantOfferRow)),
        ).colorScheme;
        expect(row.color, colorScheme.primaryContainer);
      },
    );

    testWidgets(
      'MerchantOfferRow does not contain a price Text when source.currentPrice = null',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(
            source: buildProductSource(
              id: 'source-1',
              merchantDomain: 'example.com',
              isAvailable: true,
            ),
          ),
        );

        expect(find.text('499.99 €'), findsNothing);
      },
    );

    testWidgets(
      'MerchantOfferRow does not contain a "Checked at" Text when source.lastCheckedAt = null',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(
            source: buildProductSource(
              id: 'source-1',
              merchantDomain: 'example.com',
              currentPrice: const Money(minorUnits: 49999, currencyCode: 'EUR'),
              isAvailable: true,
            ),
          ),
        );

        expect(find.textContaining('Checked at'), findsNothing);
      },
    );

    testWidgets(
      'MerchantOfferRow contains a swipe-hint dot Icon with the correct parameters when isDeleting = false',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byIcon(Icons.circle), findsOneWidget);
      },
    );

    testWidgets(
      'MerchantOfferRow does not contain a swipe-hint dot Icon when isDeleting = true',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(isDeleting: true));

        expect(find.byIcon(Icons.circle), findsNothing);
      },
    );

    testWidgets(
      'MerchantOfferRow contains a Slidable with the correct parameters when isDeleting = true',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(isDeleting: true));

        final Slidable slidable = tester.widget(find.byType(Slidable));

        expect(slidable.enabled, isA<bool>());
        expect(slidable.enabled, isFalse);
      },
    );

    testWidgets(
      'MerchantOfferRow contains a Slidable with the correct parameters when isDeleting = false',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        final Slidable slidable = tester.widget(find.byType(Slidable));

        expect(slidable.enabled, isA<bool>());
        expect(slidable.enabled, isTrue);
      },
    );

    testWidgets(
      'MerchantOfferRow rounds only the outer edges of its revealed actions',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());
        await tester.drag(
          find.byKey(const Key('merchant-offer-source-1')),
          const Offset(-400, 0),
        );
        await tester.pumpAndSettle();

        final SlidableAction deleteAction = tester.widget(
          find.byKey(const Key('merchant-offer-source-1-delete-action')),
        );
        final Radius roundedRadius = Radius.circular(
          cornerRadiusPresets[CornerStyle.rounded] ?? 20.0,
        );

        expect(
          tester
              .widget<SlidableAction>(
                find.byKey(const Key('merchant-offer-source-1-refresh-action')),
              )
              .borderRadius,
          BorderRadius.only(topLeft: roundedRadius, bottomLeft: roundedRadius),
        );
        expect(
          deleteAction.borderRadius,
          BorderRadius.only(
            topRight: roundedRadius,
            bottomRight: roundedRadius,
          ),
        );
        expect(
          tester
              .widget<SlidableAction>(
                find.byKey(const Key('merchant-offer-source-1-edit-action')),
              )
              .borderRadius,
          BorderRadius.zero,
        );
      },
    );

    testWidgets(
      'MerchantOfferRow uses the square preset radius for the revealed actions',
      (WidgetTester tester) async {
        final double squareRadius =
            cornerRadiusPresets[CornerStyle.square] ?? 4.0;
        await tester.pumpWidget(buildWidget(cornerRadius: squareRadius));
        await tester.drag(
          find.byKey(const Key('merchant-offer-source-1')),
          const Offset(-400, 0),
        );
        await tester.pumpAndSettle();

        final SlidableAction deleteAction = tester.widget(
          find.byKey(const Key('merchant-offer-source-1-delete-action')),
        );
        final SlidableAction refreshAction = tester.widget(
          find.byKey(const Key('merchant-offer-source-1-refresh-action')),
        );

        expect(
          refreshAction.borderRadius,
          BorderRadius.only(
            topLeft: Radius.circular(squareRadius),
            bottomLeft: Radius.circular(squareRadius),
          ),
        );
        expect(
          deleteAction.borderRadius,
          BorderRadius.only(
            topRight: Radius.circular(squareRadius),
            bottomRight: Radius.circular(squareRadius),
          ),
        );
      },
    );

    testWidgets(
      'MerchantOfferRow contains a BestPriceStamp with the correct parameters when isBestPrice = true',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(isBestPrice: true));

        expect(find.byType(BestPriceStamp), findsOneWidget);
      },
    );

    testWidgets(
      'MerchantOfferRow does not contain a BestPriceStamp when isBestPrice = false',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(BestPriceStamp), findsNothing);
      },
    );

    testWidgets(
      'MerchantOfferRow contains a CircularProgressIndicator with the correct parameters when isDeleting = true',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(isDeleting: true));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('499.99 €'), findsNothing);
      },
    );
  });

  group('MerchantOfferRow price-change edge cases', () {
    testWidgets(
      'MerchantOfferRow hides a price change when the prices are equal',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(
            source: buildProductSource(
              currentPrice: const Money(minorUnits: 49999, currencyCode: 'EUR'),
              previousPrice: const Money(
                minorUnits: 49999,
                currencyCode: 'EUR',
              ),
              isAvailable: true,
              priceChangedAt: DateTime(2026, 8, 3),
            ),
          ),
        );

        expect(
          find.byKey(const Key('merchant-offer-source-1-price-change')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'MerchantOfferRow hides a price change when its change date is missing',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(
            source: buildProductSource(
              currentPrice: const Money(minorUnits: 39999, currencyCode: 'EUR'),
              previousPrice: const Money(
                minorUnits: 49999,
                currencyCode: 'EUR',
              ),
              isAvailable: true,
            ),
          ),
        );

        expect(
          find.byKey(const Key('merchant-offer-source-1-price-change')),
          findsNothing,
        );
      },
    );
  });

  group("MerchantOfferRow's elements behavior", () {
    testWidgets(
      'MerchantOfferRow contains a "merchant-offer-source-1-tap-target" InkWell with the correct behavior',
      (WidgetTester tester) async {
        bool tapped = false;
        await tester.pumpWidget(buildWidget(onTap: () => tapped = true));

        await tester.tap(
          find.byKey(const Key('merchant-offer-source-1-tap-target')),
        );

        expect(tapped, isA<bool>());
        expect(tapped, isTrue);
      },
    );

    testWidgets('MerchantOfferRow does not call onTap when isDeleting = true', (
      WidgetTester tester,
    ) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildWidget(isDeleting: true, onTap: () => tapped = true),
      );

      await tester.tap(
        find.byKey(const Key('merchant-offer-source-1-tap-target')),
      );

      expect(tapped, isA<bool>());
      expect(tapped, isFalse);
    });

    testWidgets(
      'MerchantOfferRow contains a "merchant-offer-source-1-refresh-action" SlidableAction with the correct behavior',
      (WidgetTester tester) async {
        bool refreshed = false;
        await tester.pumpWidget(buildWidget(onRefresh: () => refreshed = true));

        await tester.drag(
          find.byKey(const Key('merchant-offer-source-1')),
          const Offset(-400, 0),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const Key('merchant-offer-source-1-refresh-action')),
        );
        await tester.pumpAndSettle();

        expect(refreshed, isTrue);
      },
    );

    testWidgets(
      'MerchantOfferRow contains a "merchant-offer-source-1-edit-action" SlidableAction with the correct behavior',
      (WidgetTester tester) async {
        bool edited = false;
        await tester.pumpWidget(buildWidget(onEdit: () => edited = true));

        await tester.drag(
          find.byKey(const Key('merchant-offer-source-1')),
          const Offset(-400, 0),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const Key('merchant-offer-source-1-edit-action')),
        );
        await tester.pumpAndSettle();

        expect(edited, isA<bool>());
        expect(edited, isTrue);
      },
    );

    testWidgets(
      'MerchantOfferRow contains a "merchant-offer-source-1-delete-action" SlidableAction with the correct behavior',
      (WidgetTester tester) async {
        bool deleted = false;
        await tester.pumpWidget(buildWidget(onDelete: () => deleted = true));

        await tester.drag(
          find.byKey(const Key('merchant-offer-source-1')),
          const Offset(-400, 0),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const Key('merchant-offer-source-1-delete-action')),
        );
        await tester.pumpAndSettle();

        expect(deleted, isA<bool>());
        expect(deleted, isTrue);
      },
    );

    testWidgets(
      'MerchantOfferRow contains a Semantics with the correct behavior for its edit and delete custom actions',
      (WidgetTester tester) async {
        bool edited = false;
        bool deleted = false;
        bool refreshed = false;
        await tester.pumpWidget(
          buildWidget(
            onEdit: () => edited = true,
            onDelete: () => deleted = true,
            onRefresh: () => refreshed = true,
          ),
        );

        final Semantics semantics = tester.widget(
          find.byWidgetPredicate(
            (Widget widget) =>
                widget is Semantics &&
                widget.properties.hint == t.productDetails.openOfferHint,
          ),
        );
        final Map<CustomSemanticsAction, VoidCallback> actions =
            semantics.properties.customSemanticsActions ?? {};

        actions.entries
            .firstWhere((entry) => entry.key.label == t.productDetails.refresh)
            .value();
        actions.entries
            .firstWhere(
              (entry) => entry.key.label == t.productDetails.editSourceTooltip,
            )
            .value();
        actions.entries
            .firstWhere(
              (entry) =>
                  entry.key.label == t.productDetails.deleteSourceTooltip,
            )
            .value();

        expect(edited, isA<bool>());
        expect(edited, isTrue);
        expect(deleted, isA<bool>());
        expect(deleted, isTrue);
        expect(refreshed, isA<bool>());
        expect(refreshed, isTrue);
      },
    );
  });

  group("MerchantOfferRow's translations", () {
    testWidgets('MerchantOfferRow displays the Portuguese translations', (
      WidgetTester tester,
    ) async {
      LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.productDetails.available), findsOneWidget);
        expect(
          find.textContaining(t.productDetails.checkedAt(time: '').trim()),
          findsOneWidget,
        );
      } finally {
        LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
