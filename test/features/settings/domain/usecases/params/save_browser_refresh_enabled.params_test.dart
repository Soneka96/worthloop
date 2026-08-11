// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/usecases/params/save_browser_refresh_enabled.params.dart';

void main() {
  group('SaveBrowserRefreshEnabledParams equality', () {
    test('includes enabled', () {
      const SaveBrowserRefreshEnabledParams enabled =
          SaveBrowserRefreshEnabledParams(enabled: true);

      expect(enabled.props, [true]);
      expect(enabled, const SaveBrowserRefreshEnabledParams(enabled: true));
      expect(
        enabled,
        isNot(const SaveBrowserRefreshEnabledParams(enabled: false)),
      );
    });
  });
}
