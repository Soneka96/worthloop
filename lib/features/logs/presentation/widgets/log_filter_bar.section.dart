// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/logs/presentation/screens/logs_settings.screen.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// "Search + filter" bar inside [LogsSettingsScreen] — a keyword search, a
/// severity filter, and the export/clear actions.
class LogFilterBarSection extends StatelessWidget {
  /// The current search text.
  final String searchQuery;

  /// Called with the new search text as the user types.
  final ValueChanged<String> onSearchChanged;

  /// The currently-selected severity filter, or `null` for "All".
  final LogLevel? selectedLevel;

  /// Called with the newly-selected severity filter (`null` for "All").
  final ValueChanged<LogLevel?> onLevelSelected;

  /// Called when the user taps "Export logs".
  final VoidCallback onExport;

  /// Called when the user taps "Clear logs".
  final VoidCallback onClear;

  static const List<LogLevel?> _levels = [
    null,
    LogLevel.info,
    LogLevel.warning,
    LogLevel.error,
  ];

  const LogFilterBarSection({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.selectedLevel,
    required this.onLevelSelected,
    required this.onExport,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const Key('logs-settings-search-field'),
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: t.settings.logs.search.hint,
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        SizedBox(height: context.spacing.sm),
        Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: context.spacing.xs,
                children: [
                  for (final LogLevel? level in _levels)
                    ChoiceChip(
                      key: Key('logs-settings-filter-${level?.name ?? "all"}'),
                      label: Text(level?.label ?? t.settings.logs.filterAll),
                      selected: selectedLevel == level,
                      onSelected: (_) => onLevelSelected(level),
                    ),
                ],
              ),
            ),
            OutlinedButton(
              key: const Key('logs-settings-export-button'),
              onPressed: onExport,
              child: Text(t.settings.logs.export),
            ),
            SizedBox(width: context.spacing.sm),
            OutlinedButton(
              key: const Key('logs-settings-clear-button'),
              onPressed: onClear,
              child: Text(t.settings.logs.clear),
            ),
          ],
        ),
      ],
    );
  }
}
