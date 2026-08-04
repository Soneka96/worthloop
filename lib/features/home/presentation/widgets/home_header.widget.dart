// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Displays the Home title, subtitle, and settings action.
class HomeHeader extends StatelessWidget {
  /// Opens application settings.
  final VoidCallback onOpenSettings;

  const HomeHeader({required this.onOpenSettings, super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(t.appTitle, style: textTheme.headlineSmall)),
            IconButton(
              key: const Key('home-settings-button'),
              onPressed: onOpenSettings,
              tooltip: t.settings.title,
              icon: Icon(
                Icons.settings_outlined,
                size: IconSizes.md,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Text(t.home.subtitle, style: textTheme.bodyMedium),
        SizedBox(height: context.spacing.sm),
      ],
    );
  }
}
