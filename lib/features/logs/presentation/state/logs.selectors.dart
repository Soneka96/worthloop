// Project imports:
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/features/logs/presentation/state/logs.state.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// Static selectors over [AppState] for the Logs settings category.
abstract final class LogsSelectors {
  /// The selector extracts [LogsState.entries] from [AppState] and returns it.
  static List<LogEntry> entriesSelector(AppState state) => state.logs.entries;

  /// The selector extracts [LogsState.folderPath] from [AppState] and
  /// returns it.
  static String? folderPathSelector(AppState state) => state.logs.folderPath;
}
