// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';

/// General-purpose static helpers shared across widget tests.
class TestHelper {
  /// Pumps [buildWidget] fresh under every supported [AppLocale] in turn,
  /// calling [verify] after each pump — the one place that knows Flutter's
  /// element diffing treats two consecutive pumps of an unchanged widget as
  /// a no-op, so a real rebuild needs an unrelated widget pumped in between.
  /// Restores [AppLocale.en] once done, regardless of how [verify] exits.
  static Future<void> pumpEachLocale(
    WidgetTester tester,
    Widget Function() buildWidget,
    Future<void> Function() verify,
  ) async {
    try {
      for (final AppLocale locale in AppLocale.values) {
        LocaleSettings.setLocale(locale);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpWidget(buildWidget());
        await verify();
      }
    } finally {
      LocaleSettings.setLocale(AppLocale.en);
    }
  }
}
