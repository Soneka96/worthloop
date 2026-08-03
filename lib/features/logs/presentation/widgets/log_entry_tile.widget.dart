// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// One row in the Logs settings screen's entry list — timestamp, severity
/// icon, and message for a single [LogEntry].
class LogEntryTile extends StatelessWidget {
  /// The entry to render.
  final LogEntry entry;

  const LogEntryTile({super.key, required this.entry});

  String _formattedTime(DateTime timestamp) {
    final String hour = timestamp.hour.toString().padLeft(2, '0');
    final String minute = timestamp.minute.toString().padLeft(2, '0');
    final String second = timestamp.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.spacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formattedTime(entry.timestamp),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(width: context.spacing.sm),
          Icon(
            entry.level.icon,
            size: IconSizes.sm,
            color: entry.level.color(colorScheme),
          ),
          SizedBox(width: context.spacing.sm),
          Expanded(child: Text(entry.message, style: textTheme.bodySmall)),
        ],
      ),
    );
  }
}
