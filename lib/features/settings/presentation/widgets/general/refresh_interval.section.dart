// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/app_constants.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Refresh interval preference.
class RefreshIntervalSection extends StatelessWidget {
  /// Selected interval in minutes.
  final int intervalMinutes;

  /// Whether persistence is active.
  final bool isBusy;

  /// Called when a supported interval is selected.
  final ValueChanged<int> onSelected;

  const RefreshIntervalSection({
    required this.intervalMinutes,
    required this.isBusy,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.settings.general.refreshInterval.title,
          style: textTheme.labelSmall,
        ),
        SizedBox(height: context.spacing.xs),
        Text(
          t.settings.general.refreshInterval.description,
          style: textTheme.bodySmall,
        ),
        SizedBox(height: context.spacing.sm),
        DropdownButtonFormField<int>(
          key: const Key('refresh-interval-dropdown'),
          initialValue: intervalMinutes,
          isExpanded: true,
          items: RefreshIntervalConstants.values
              .map(
                (int minutes) => DropdownMenuItem<int>(
                  value: minutes,
                  child: Text(_labelFor(minutes), style: textTheme.bodyLarge),
                ),
              )
              .toList(growable: false),
          onChanged: isBusy
              ? null
              : (int? minutes) {
                  if (minutes != null) {
                    onSelected(minutes);
                  }
                },
        ),
      ],
    );
  }

  String _labelFor(int minutes) => switch (minutes) {
    RefreshIntervalConstants.everyThreeHours =>
      t.settings.general.refreshInterval.everyThreeHours,
    RefreshIntervalConstants.everySixHours =>
      t.settings.general.refreshInterval.everySixHours,
    RefreshIntervalConstants.everyTwelveHours =>
      t.settings.general.refreshInterval.everyTwelveHours,
    _ => t.settings.general.refreshInterval.hourly,
  };
}
