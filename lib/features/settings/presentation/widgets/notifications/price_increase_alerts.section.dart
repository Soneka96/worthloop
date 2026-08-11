// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';

/// Opt-in controls and explanation for product price-increase notifications.
class PriceIncreaseAlertsSection extends StatelessWidget {
  final bool enabled;
  final bool isBusy;
  final ValueChanged<bool> onChanged;

  const PriceIncreaseAlertsSection({
    required this.enabled,
    required this.isBusy,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      key: const Key('price-increase-alerts-switch'),
      contentPadding: EdgeInsets.zero,
      title: Text(t.settings.notifications.priceIncreaseAlerts.title),
      subtitle: Text(
        enabled
            ? t.settings.notifications.priceIncreaseAlerts.enabledDescription
            : t.settings.notifications.priceIncreaseAlerts.description,
      ),
      value: enabled,
      onChanged: isBusy ? null : onChanged,
    );
  }
}
