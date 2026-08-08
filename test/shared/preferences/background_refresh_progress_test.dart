// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/preferences/background_refresh_progress.dart';

void main() {
  final DateTime startedAt = DateTime(2026, 8, 8, 12);
  final DateTime lastProgressAt = DateTime(2026, 8, 8, 12, 1);

  test('serializes and parses a progress snapshot', () {
    const String sourceId = 'source-1';
    final BackgroundRefreshProgress progress = BackgroundRefreshProgress(
      status: BackgroundRefreshStatus.running,
      totalSources: 10,
      completedSources: 3,
      currentSourceId: sourceId,
      startedAt: startedAt,
      lastProgressAt: lastProgressAt,
      errorMessage: null,
    );

    final BackgroundRefreshProgress? parsed =
        BackgroundRefreshProgress.fromJson(progress.toJson());

    expect(parsed?.status, BackgroundRefreshStatus.running);
    expect(parsed?.totalSources, 10);
    expect(parsed?.completedSources, 3);
    expect(parsed?.currentSourceId, sourceId);
    expect(parsed?.startedAt, startedAt);
    expect(parsed?.lastProgressAt, lastProgressAt);
  });

  test('round-trips optional source and error values', () {
    final BackgroundRefreshProgress progress = BackgroundRefreshProgress(
      status: BackgroundRefreshStatus.failed,
      totalSources: 2,
      completedSources: 1,
      currentSourceId: 'source-2',
      startedAt: startedAt,
      lastProgressAt: lastProgressAt,
      errorMessage: 'Request timed out',
    );

    final BackgroundRefreshProgress? parsed =
        BackgroundRefreshProgress.fromJson(progress.toJson());

    expect(parsed?.currentSourceId, 'source-2');
    expect(parsed?.errorMessage, 'Request timed out');
  });

  test('accepts numeric counts decoded as JSON numbers', () {
    final BackgroundRefreshProgress? parsed =
        BackgroundRefreshProgress.fromJson(<String, dynamic>{
          'status': 'completed',
          'totalSources': 4.0,
          'completedSources': 4.0,
          'startedAt': startedAt.toIso8601String(),
          'lastProgressAt': lastProgressAt.toIso8601String(),
        });

    expect(parsed?.status, BackgroundRefreshStatus.completed);
    expect(parsed?.totalSources, 4);
    expect(parsed?.completedSources, 4);
  });

  test('rejects incomplete or invalid persisted data', () {
    expect(BackgroundRefreshProgress.fromJson(null), isNull);
    expect(BackgroundRefreshProgress.fromJson(<Object, Object>{}), isNull);
    expect(
      BackgroundRefreshProgress.fromJson(<String, dynamic>{
        'status': 'unknown',
        'totalSources': 1,
        'completedSources': 0,
        'startedAt': startedAt.toIso8601String(),
        'lastProgressAt': lastProgressAt.toIso8601String(),
      }),
      isNull,
    );
    expect(
      BackgroundRefreshProgress.fromJson(<String, dynamic>{
        'status': 'running',
        'totalSources': 1,
        'completedSources': 0,
        'startedAt': 'not-a-date',
        'lastProgressAt': lastProgressAt.toIso8601String(),
      }),
      isNull,
    );
    expect(
      BackgroundRefreshProgress.fromJson(<String, dynamic>{
        'status': 'running',
        'totalSources': 1,
        'completedSources': 0,
        'startedAt': startedAt.toIso8601String(),
        'lastProgressAt': 'not-a-date',
      }),
      isNull,
    );
  });
}
