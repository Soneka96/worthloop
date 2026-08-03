// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:file_selector/file_selector.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/screens/general_settings.screen.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// "Default save location" group inside [GeneralSettingsScreen] — shows the
/// current folder and lets the user browse for a new one.
class DefaultSaveLocationSection extends StatelessWidget {
  /// The default folder for new projects, or `null` if none has been set.
  final String? path;

  /// The folder queued to become the new data root on next launch, or
  /// `null` if no move is pending.
  final String? pendingPath;

  /// Called with the newly-browsed folder path.
  final ValueChanged<String> onPathSelected;

  /// Called when the user taps "Restart now" to apply a pending data-root
  /// move immediately.
  final VoidCallback onRestartNow;

  const DefaultSaveLocationSection({
    super.key,
    required this.path,
    required this.pendingPath,
    required this.onPathSelected,
    required this.onRestartNow,
  });

  Future<void> _browse() async {
    final String? selected = await getDirectoryPath();
    if (selected != null) {
      onPathSelected(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String? pendingPath = this.pendingPath;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.settings.general.defaultSaveLocation.title,
          style: textTheme.labelSmall,
        ),
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
                child: Text(
                  path ??
                      t.settings.general.defaultSaveLocation.noFolderSelected,
                  style: path == null
                      ? textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        )
                      : textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(width: context.spacing.sm),
            OutlinedButton(
              key: const Key('general-settings-browse-button'),
              onPressed: _browse,
              child: Text(t.settings.general.defaultSaveLocation.browse),
            ),
          ],
        ),
        if (pendingPath != null) ...[
          SizedBox(height: context.spacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  t.settings.general.defaultSaveLocation.pendingMove(
                    path: pendingPath,
                  ),
                  style: textTheme.bodySmall,
                ),
              ),
              SizedBox(width: context.spacing.sm),
              FilledButton(
                key: const Key('general-settings-restart-now-button'),
                onPressed: onRestartNow,
                child: Text(t.settings.general.defaultSaveLocation.restartNow),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
