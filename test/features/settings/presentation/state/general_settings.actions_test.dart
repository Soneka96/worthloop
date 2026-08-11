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

  group('General settings price-alert actions', () {
    test('SavePriceAlertsEnabledAction includes enabled', () {
      expect(const SavePriceAlertsEnabledAction(true).props, [true]);
      expect(
        const SavePriceAlertsEnabledAction(true),
        isNot(const SavePriceAlertsEnabledAction(false)),
      );
    });

    test('PriceAlertsEnabledSavedAction includes enabled', () {
      expect(const PriceAlertsEnabledSavedAction(true).props, [true]);
    });

    test('PriceAlertsSaveFailedAction includes message', () {
      expect(const PriceAlertsSaveFailedAction('failed').props, ['failed']);
    });
  });

  group('General settings price-increase-alert actions', () {
    test('SavePriceIncreaseAlertsEnabledAction includes enabled', () {
      expect(const SavePriceIncreaseAlertsEnabledAction(true).props, [true]);
      expect(
        const SavePriceIncreaseAlertsEnabledAction(true),
        isNot(const SavePriceIncreaseAlertsEnabledAction(false)),
      );
    });

    test('PriceIncreaseAlertsEnabledSavedAction includes enabled', () {
      expect(const PriceIncreaseAlertsEnabledSavedAction(true).props, [true]);
    });

    test('PriceIncreaseAlertsSaveFailedAction includes message', () {
      expect(const PriceIncreaseAlertsSaveFailedAction('failed').props, [
        'failed',
      ]);
    });
  });

  group('General settings refresh-completed-alert actions', () {
    test('SaveRefreshCompletedAlertsEnabledAction includes enabled', () {
      expect(const SaveRefreshCompletedAlertsEnabledAction(true).props, [true]);
      expect(
        const SaveRefreshCompletedAlertsEnabledAction(true),
        isNot(const SaveRefreshCompletedAlertsEnabledAction(false)),
      );
    });

    test('RefreshCompletedAlertsEnabledSavedAction includes enabled', () {
      expect(const RefreshCompletedAlertsEnabledSavedAction(true).props, [
        true,
      ]);
    });

    test('RefreshCompletedAlertsSaveFailedAction includes message', () {
      expect(const RefreshCompletedAlertsSaveFailedAction('failed').props, [
        'failed',
      ]);
    });
  });

  group('General settings show-refresh-progress actions', () {
    test('SaveShowRefreshProgressAction includes enabled', () {
      expect(const SaveShowRefreshProgressAction(true).props, [true]);
      expect(
        const SaveShowRefreshProgressAction(true),
        isNot(const SaveShowRefreshProgressAction(false)),
      );
    });

    test('ShowRefreshProgressSavedAction includes enabled', () {
      expect(const ShowRefreshProgressSavedAction(true).props, [true]);
    });

    test('ShowRefreshProgressSaveFailedAction includes message', () {
      expect(const ShowRefreshProgressSaveFailedAction('failed').props, [
        'failed',
      ]);
    });
  });
}
