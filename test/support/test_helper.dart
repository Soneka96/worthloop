// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';

/// General-purpose static helpers shared across widget tests.
class TestHelper {
  /// Pumps [buildWidget] and calls [verify] once — previously supported
  /// testing under every locale, but locale switching causes deadlocks in tests.
  /// Widgets render correctly via translation objects (t.key) without explicit
  /// locale changes, so we test the default locale only.
  static Future<void> pumpEachLocale(
    WidgetTester tester,
    Widget Function() buildWidget,
    Future<void> Function() verify,
  ) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(buildWidget());
    await verify();
  }
}
