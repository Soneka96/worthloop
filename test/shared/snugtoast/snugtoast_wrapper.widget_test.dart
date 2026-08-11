// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/snugtoast/snugtoast_config.dart';
import 'package:worth_loop/shared/snugtoast/snugtoast_manager.dart';
import 'package:worth_loop/shared/snugtoast/snugtoast_wrapper.widget.dart';

void main() {
  testWidgets('SnugToastWrapper keeps the toast layer below the top inset', (
    WidgetTester tester,
  ) async {
    final SnugToastManager manager = SnugToastManager();
    manager.show(
      const SnugToastConfig(
        message: 'Refresh complete',
        duration: Duration(minutes: 1),
      ),
    );

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          padding: EdgeInsets.only(top: 24, bottom: 32),
        ),
        child: SnugToastWrapper(
          manager: manager,
          child: const Material(
            child: SizedBox.expand(key: Key('snugtoast-wrapper-content')),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 250));

    final SafeArea safeArea = tester.widget(find.byType(SafeArea));
    expect(safeArea.top, isFalse);
    expect(safeArea.bottom, isTrue);
    expect(find.byKey(const Key('snugtoast-bubble')), findsOneWidget);
    expect(find.byKey(const Key('snugtoast-wrapper-content')), findsOneWidget);

    final Rect wrapperRect = tester.getRect(find.byType(SnugToastWrapper));
    final Rect toastRect = tester.getRect(
      find.byKey(const Key('snugtoast-bubble')),
    );
    expect(toastRect.bottom, lessThanOrEqualTo(wrapperRect.bottom - 32));
  });
}
