// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/density_preview_rows.widget.dart';

void main() {
  Widget buildWidget({int itemCount = 3}) {
    return MaterialApp(
      home: Scaffold(body: DensityPreviewRows(itemCount: itemCount)),
    );
  }

  group('DensityPreviewRows contains widgets', () {
    testWidgets('DensityPreviewRows renders itemCount row Containers', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(itemCount: 5));

      expect(find.byType(Container), findsNWidgets(5));
    });

    testWidgets(
      'DensityPreviewRows renders a different number of rows for a different itemCount',
      (tester) async {
        await tester.pumpWidget(buildWidget(itemCount: 3));

        expect(find.byType(Container), findsNWidgets(3));
      },
    );
  });
}
