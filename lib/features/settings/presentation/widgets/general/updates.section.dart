// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/screens/general_settings.screen.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// "Updates" group inside [GeneralSettingsScreen] — current version and a
/// manual update check.
class UpdatesSection extends StatelessWidget {
  /// The app's current version, shown to the user.
  final String version;

  /// Called when the user requests a manual update check.
  final VoidCallback onCheckForUpdates;

  const UpdatesSection({
    super.key,
    required this.version,
    required this.onCheckForUpdates,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.settings.general.updates.title, style: textTheme.labelSmall),
        SizedBox(height: context.spacing.xs),
        Text(
          t.settings.general.updates.version(version: version),
          style: textTheme.bodyMedium,
        ),
        SizedBox(height: context.spacing.md),
        Row(
          children: [
            OutlinedButton(
              key: const Key('general-settings-check-for-updates-button'),
              onPressed: onCheckForUpdates,
              child: Text(t.settings.general.updates.checkForUpdates),
            ),
          ],
        ),
        SizedBox(height: context.spacing.sm),
        Text(
          t.settings.general.updates.description,
          style: textTheme.bodySmall,
        ),
      ],
    );
  }
}
