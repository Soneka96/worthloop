// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Opt-in controls and guidance for browser-backed background refresh.
class BrowserRefreshSection extends StatelessWidget {
  /// Whether browser-backed background refresh is enabled.
  final bool enabled;

  /// Whether refresh settings are currently being saved.
  final bool isBusy;

  /// Called when the user changes the opt-in state.
  final ValueChanged<bool> onChanged;

  /// Called when the user wants to repair Android background restrictions.
  final VoidCallback onOpenBackgroundRestrictions;

  const BrowserRefreshSection({
    required this.enabled,
    required this.isBusy,
    required this.onChanged,
    required this.onOpenBackgroundRestrictions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile.adaptive(
          key: const Key('browser-refresh-switch'),
          contentPadding: EdgeInsets.zero,
          title: Text(
            t.settings.general.browserRefresh.title,
            style: textTheme.titleMedium,
          ),
          subtitle: Text(
            enabled
                ? t.settings.general.browserRefresh.enabledDescription
                : t.settings.general.browserRefresh.description,
          ),
          value: enabled,
          onChanged: isBusy ? null : onChanged,
        ),
        if (enabled) ...[
          SizedBox(height: context.spacing.xs),
          Text(
            t.settings.general.browserRefresh.status,
            style: textTheme.bodySmall,
          ),
          SizedBox(height: context.spacing.sm),
          OutlinedButton.icon(
            key: const Key('browser-refresh-fix-button'),
            onPressed: isBusy ? null : onOpenBackgroundRestrictions,
            icon: const Icon(Icons.battery_saver_outlined),
            label: Text(t.settings.general.browserRefresh.fixRestrictions),
          ),
        ],
      ],
    );
  }
}
