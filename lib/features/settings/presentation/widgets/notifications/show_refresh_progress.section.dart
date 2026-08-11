// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';

/// Opt-in controls and explanation for the background-refresh notification's
/// progress bar.
class ShowRefreshProgressSection extends StatelessWidget {
  final bool enabled;
  final bool isBusy;
  final ValueChanged<bool> onChanged;

  const ShowRefreshProgressSection({
    required this.enabled,
    required this.isBusy,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      key: const Key('show-refresh-progress-switch'),
      contentPadding: EdgeInsets.zero,
      title: Text(t.settings.notifications.showRefreshProgress.title),
      subtitle: Text(t.settings.notifications.showRefreshProgress.description),
      value: enabled,
      onChanged: isBusy ? null : onChanged,
    );
  }
}
