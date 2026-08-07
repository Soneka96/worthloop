// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';

void main() {
  group('General settings browser-refresh actions', () {
    test('SaveBrowserRefreshEnabledAction includes enabled', () {
      expect(const SaveBrowserRefreshEnabledAction(true).props, [true]);
      expect(
        const SaveBrowserRefreshEnabledAction(true),
        isNot(const SaveBrowserRefreshEnabledAction(false)),
      );
    });

    test('BrowserRefreshEnabledSavedAction includes enabled', () {
      expect(const BrowserRefreshEnabledSavedAction(true).props, [true]);
    });

    test('BrowserRefreshSaveFailedAction includes message', () {
      expect(const BrowserRefreshSaveFailedAction('failed').props, ['failed']);
    });
  });
}
