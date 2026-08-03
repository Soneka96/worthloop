// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/logs/presentation/screens/logs_settings.screen.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// "Location" group inside [LogsSettingsScreen] — the log file folder path
/// and a button to open it.
class LogLocationSection extends StatelessWidget {
  /// The log folder's path.
  final String path;

  /// Called when the user taps the open-folder button.
  final VoidCallback onOpenFolder;

  const LogLocationSection({
    super.key,
    required this.path,
    required this.onOpenFolder,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.settings.logs.location.title, style: textTheme.labelSmall),
        SizedBox(height: context.spacing.xs),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.spacing.md,
                  vertical: context.spacing.sm,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  borderRadius: BorderRadius.circular(
                    context.resolvedCornerRadius,
                  ),
                ),
                child: Text(path, style: textTheme.bodyMedium),
              ),
            ),
            SizedBox(width: context.spacing.sm),
            IconButton(
              key: const Key('logs-settings-open-folder-button'),
              icon: const Icon(Icons.folder_open),
              tooltip: t.settings.logs.location.openFolder,
              onPressed: onOpenFolder,
            ),
          ],
        ),
      ],
    );
  }
}
