// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/features/logs/presentation/state/logs.actions.dart';
import 'package:worth_loop/features/logs/presentation/state/viewmodels/logs_screen.viewmodel.dart';
import 'package:worth_loop/features/logs/presentation/widgets/log_entry_tile.widget.dart';
import 'package:worth_loop/features/logs/presentation/widgets/log_filter_bar.section.dart';
import 'package:worth_loop/features/logs/presentation/widgets/log_location.section.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// App settings' "Logs" category — log file location, a search/level
/// filter bar, and the matching entries.
class LogsSettingsScreen extends StatefulWidget {
  const LogsSettingsScreen({super.key});

  @override
  State<LogsSettingsScreen> createState() => _LogsSettingsScreenState();
}

class _LogsSettingsScreenState extends State<LogsSettingsScreen> {
  String _searchQuery = '';
  LogLevel? _selectedLevel;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return StoreConnector<AppState, LogsScreenViewModel>(
      distinct: true,
      onInit: (store) => store.dispatch(const LoadLogEntriesAction()),
      converter: (store) => sl<LogsScreenViewModel>(param1: store),
      builder: (context, viewmodel) {
        final List<LogEntry> visibleEntries = viewmodel.entries.where((entry) {
          final bool matchesLevel =
              _selectedLevel == null || entry.level == _selectedLevel;
          final bool matchesSearch =
              _searchQuery.isEmpty ||
              entry.message.toLowerCase().contains(_searchQuery.toLowerCase());
          return matchesLevel && matchesSearch;
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.settings.logs.title, style: textTheme.headlineSmall),
            SizedBox(height: context.spacing.md),
            LogLocationSection(
              path: viewmodel.folderPath,
              onOpenFolder: viewmodel.onOpenFolder,
            ),
            SizedBox(height: context.spacing.md),
            LogFilterBarSection(
              searchQuery: _searchQuery,
              onSearchChanged: (value) => setState(() => _searchQuery = value),
              selectedLevel: _selectedLevel,
              onLevelSelected: (level) =>
                  setState(() => _selectedLevel = level),
              onExport: viewmodel.onExport,
              onClear: viewmodel.onClear,
            ),
            SizedBox(height: context.spacing.md),
            if (visibleEntries.isEmpty)
              Text(t.settings.logs.empty, style: textTheme.bodySmall)
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visibleEntries.length,
                itemBuilder: (context, index) =>
                    LogEntryTile(entry: visibleEntries[index]),
              ),
          ],
        );
      },
    );
  }
}
