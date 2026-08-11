// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';

/// Opt-in controls and explanation for a notification on every completed
/// background refresh.
class RefreshCompletedAlertsSection extends StatelessWidget {
  final bool enabled;
  final bool isBusy;
  final ValueChanged<bool> onChanged;

  const RefreshCompletedAlertsSection({
    required this.enabled,
    required this.isBusy,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      key: const Key('refresh-completed-alerts-switch'),
      contentPadding: EdgeInsets.zero,
      title: Text(t.settings.notifications.refreshCompletedAlerts.title),
      subtitle: Text(
        enabled
            ? t.settings.notifications.refreshCompletedAlerts.enabledDescription
            : t.settings.notifications.refreshCompletedAlerts.description,
      ),
      value: enabled,
      onChanged: isBusy ? null : onChanged,
    );
  }
}
