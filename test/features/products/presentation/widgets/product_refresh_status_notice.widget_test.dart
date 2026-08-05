// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/presentation/widgets/product_refresh_status_notice.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/enums.dart';

void main() {
  Widget buildWidget(PriceFetchStatus? status) => TranslationProvider(
    child: MaterialApp(
      home: Scaffold(body: ProductRefreshStatusNotice(status: status)),
    ),
  );

  testWidgets('hides itself when there is no refresh failure', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildWidget(null));

    expect(
      find.byKey(const Key('product-refresh-status-notice')),
      findsNothing,
    );
  });

  testWidgets('explains blocked refreshes', (WidgetTester tester) async {
    await tester.pumpWidget(buildWidget(PriceFetchStatus.blocked));

    expect(
      find.byKey(const Key('product-refresh-status-notice')),
      findsOneWidget,
    );
    expect(find.text(t.productDetails.refreshBlocked), findsOneWidget);
  });
}
