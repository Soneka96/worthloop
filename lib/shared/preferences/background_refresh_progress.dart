/// Lifecycle of a background product refresh.
enum BackgroundRefreshStatus { starting, running, completed, failed }

/// Snapshot shared by the UI and the background Flutter engine.
class BackgroundRefreshProgress {
  const BackgroundRefreshProgress({
    required this.status,
    required this.totalSources,
    required this.completedSources,
    required this.currentSourceId,
    required this.startedAt,
    required this.lastProgressAt,
    required this.errorMessage,
  });

  final BackgroundRefreshStatus status;
  final int totalSources;
  final int completedSources;
  final String? currentSourceId;
  final DateTime startedAt;
  final DateTime lastProgressAt;
  final String? errorMessage;

  Map<String, Object?> toJson() => <String, Object?>{
    'status': status.name,
    'totalSources': totalSources,
    'completedSources': completedSources,
    'currentSourceId': currentSourceId,
    'startedAt': startedAt.toIso8601String(),
    'lastProgressAt': lastProgressAt.toIso8601String(),
    'errorMessage': errorMessage,
  };

  /// Parses persisted data, returning `null` when it is incomplete or invalid.
  static BackgroundRefreshProgress? fromJson(Object? value) {
    if (value is! Map<String, dynamic>) {
      return null;
    }
    final Object? statusValue = value['status'];
    final Object? startedAtValue = value['startedAt'];
    final Object? lastProgressAtValue = value['lastProgressAt'];
    final int? totalSources = _readInt(value['totalSources']);
    final int? completedSources = _readInt(value['completedSources']);
    if (statusValue is! String ||
        startedAtValue is! String ||
        lastProgressAtValue is! String ||
        totalSources == null ||
        completedSources == null) {
      return null;
    }
    final BackgroundRefreshStatus status;
    final DateTime startedAt;
    final DateTime lastProgressAt;
    try {
      status = BackgroundRefreshStatus.values.byName(statusValue);
      startedAt = DateTime.parse(startedAtValue);
      lastProgressAt = DateTime.parse(lastProgressAtValue);
    } on ArgumentError {
      return null;
    } on FormatException {
      return null;
    }
    final Object? currentSourceValue = value['currentSourceId'];
    final Object? errorValue = value['errorMessage'];
    return BackgroundRefreshProgress(
      status: status,
      totalSources: totalSources,
      completedSources: completedSources,
      currentSourceId: currentSourceValue is String ? currentSourceValue : null,
      startedAt: startedAt,
      lastProgressAt: lastProgressAt,
      errorMessage: errorValue is String ? errorValue : null,
    );
  }

  static int? _readInt(Object? value) => value is int
      ? value
      : value is num
      ? value.toInt()
      : null;
}
