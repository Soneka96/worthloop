// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';

/// Opt-in controls and explanation for product price-drop notifications.
class PriceDropAlertsSection extends StatelessWidget {
  final bool enabled;
  final bool isBusy;
  final ValueChanged<bool> onChanged;

  const PriceDropAlertsSection({
    required this.enabled,
    required this.isBusy,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      key: const Key('price-drop-alerts-switch'),
      contentPadding: EdgeInsets.zero,
      title: Text(t.settings.notifications.priceAlerts.title),
      subtitle: Text(
        enabled
            ? t.settings.notifications.priceAlerts.enabledDescription
            : t.settings.notifications.priceAlerts.description,
      ),
      value: enabled,
      onChanged: isBusy ? null : onChanged,
    );
  }
}
