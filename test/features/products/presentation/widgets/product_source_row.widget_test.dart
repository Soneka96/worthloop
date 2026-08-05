// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/presentation/widgets/product_source_row.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import '../../fixtures/product_source.fixture.dart';

void main() {
  Widget buildWidget({
    bool isDeleting = false,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) => TranslationProvider(
    child: MaterialApp(
      home: Scaffold(
        body: ProductSourceRow(
          source: buildProductSource(
            id: 'source-1',
            url: 'https://example.com/products/1',
          ),
          isDeleting: isDeleting,
          onEdit: onEdit ?? () {},
          onDelete: onDelete ?? () {},
        ),
      ),
    ),
  );

  group('ProductSourceRow contains widgets', () {
    testWidgets(
      'ProductSourceRow contains the merchant domain and url with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('product-source-source-1')),
          findsOneWidget,
        );
        expect(find.text('example.com'), findsOneWidget);
        expect(find.text('https://example.com/products/1'), findsOneWidget);
        expect(
          find.byKey(const Key('product-source-source-1-edit-button')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('product-source-source-1-delete-button')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'ProductSourceRow contains a CircularProgressIndicator with the correct parameters when isDeleting = true',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(isDeleting: true));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(
          find.byKey(const Key('product-source-source-1-delete-button')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'ProductSourceRow contains a disabled "product-source-source-1-edit-button" IconButton when isDeleting = true',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(isDeleting: true));

        final IconButton editButton = tester.widget(
          find.byKey(const Key('product-source-source-1-edit-button')),
        );

        expect(editButton.onPressed, isNull);
      },
    );
  });

  group("ProductSourceRow's elements behavior", () {
    testWidgets(
      'ProductSourceRow contains a "product-source-source-1-edit-button" IconButton with the correct behavior',
      (WidgetTester tester) async {
        bool edited = false;
        await tester.pumpWidget(buildWidget(onEdit: () => edited = true));

        await tester.tap(
          find.byKey(const Key('product-source-source-1-edit-button')),
        );

        expect(edited, isA<bool>());
        expect(edited, isTrue);
      },
    );

    testWidgets(
      'ProductSourceRow does not call onEdit when isDeleting = true',
      (WidgetTester tester) async {
        bool edited = false;
        await tester.pumpWidget(
          buildWidget(isDeleting: true, onEdit: () => edited = true),
        );

        await tester.tap(
          find.byKey(const Key('product-source-source-1-edit-button')),
        );

        expect(edited, isA<bool>());
        expect(edited, isFalse);
      },
    );

    testWidgets(
      'ProductSourceRow contains a "product-source-source-1-delete-button" IconButton with the correct behavior',
      (WidgetTester tester) async {
        bool deleted = false;
        await tester.pumpWidget(buildWidget(onDelete: () => deleted = true));

        await tester.tap(
          find.byKey(const Key('product-source-source-1-delete-button')),
        );

        expect(deleted, isA<bool>());
        expect(deleted, isTrue);
      },
    );
  });

  group("ProductSourceRow's translations", () {
    testWidgets('ProductSourceRow displays the Portuguese translations', (
      WidgetTester tester,
    ) async {
      LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byTooltip(t.productDetails.editSourceTooltip),
          findsOneWidget,
        );
        expect(
          find.byTooltip(t.productDetails.deleteSourceTooltip),
          findsOneWidget,
        );
      } finally {
        LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
