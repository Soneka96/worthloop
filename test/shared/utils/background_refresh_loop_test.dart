import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:worth_loop/shared/utils/background_refresh_loop.dart';

void main() {
  test('runs immediately and then follows the scheduled delay', () async {
    final List<int> runs = <int>[];
    final Completer<void> completed = Completer<void>();
    final BackgroundRefreshLoop loop = BackgroundRefreshLoop(
      runOnce: () async {
        runs.add(runs.length + 1);
        if (runs.length == 2) {
          completed.complete();
          return null;
        }
        return const Duration(milliseconds: 20);
      },
    );

    unawaited(loop.run());
    await completed.future;

    expect(runs, <int>[1, 2]);
  });

  test('manual refresh interrupts the scheduled delay', () async {
    final List<int> runs = <int>[];
    final Completer<void> firstRun = Completer<void>();
    final Completer<void> secondRun = Completer<void>();
    final BackgroundRefreshLoop loop = BackgroundRefreshLoop(
      runOnce: () async {
        runs.add(runs.length + 1);
        if (runs.length == 1) {
          firstRun.complete();
          return const Duration(hours: 1);
        }
        secondRun.complete();
        return null;
      },
    );

    unawaited(loop.run());
    await firstRun.future;
    loop.requestRefresh();
    await secondRun.future;

    expect(runs, <int>[1, 2]);
  });

  test(
    'manual requests during a refresh are coalesced without overlap',
    () async {
      int activeRuns = 0;
      int maximumActiveRuns = 0;
      int runCount = 0;
      final Completer<void> firstRunStarted = Completer<void>();
      final Completer<void> secondRunCompleted = Completer<void>();
      final Completer<void> releaseFirstRun = Completer<void>();
      final BackgroundRefreshLoop loop = BackgroundRefreshLoop(
        runOnce: () async {
          activeRuns++;
          maximumActiveRuns = activeRuns > maximumActiveRuns
              ? activeRuns
              : maximumActiveRuns;
          runCount++;
          if (runCount == 1) {
            firstRunStarted.complete();
            await releaseFirstRun.future;
          } else {
            secondRunCompleted.complete();
          }
          activeRuns--;
          return runCount == 1 ? const Duration(hours: 1) : null;
        },
      );

      unawaited(loop.run());
      await firstRunStarted.future;
      loop.requestRefresh();
      loop.requestRefresh();
      releaseFirstRun.complete();
      await secondRunCompleted.future;

      expect(runCount, 2);
      expect(maximumActiveRuns, 1);
    },
  );

  test('multiple requests during the scheduled wait do not throw', () async {
    final Completer<void> firstRun = Completer<void>();
    final Completer<void> secondRun = Completer<void>();
    int runCount = 0;
    final BackgroundRefreshLoop loop = BackgroundRefreshLoop(
      runOnce: () async {
        runCount++;
        if (runCount == 1) {
          firstRun.complete();
          return const Duration(hours: 1);
        }
        secondRun.complete();
        return null;
      },
    );

    unawaited(loop.run());
    await firstRun.future;
    loop.requestRefresh();
    loop.requestRefresh();
    await secondRun.future;

    expect(runCount, 2);
  });

  test('uses the manual callback for a queued request', () async {
    final Completer<void> completed = Completer<void>();
    int scheduledRuns = 0;
    int manualRuns = 0;
    final BackgroundRefreshLoop loop = BackgroundRefreshLoop(
      runOnce: () async {
        scheduledRuns++;
        return const Duration(hours: 1);
      },
      runManualOnce: () async {
        manualRuns++;
        completed.complete();
        return null;
      },
    );

    loop.requestRefresh();
    unawaited(loop.run());
    await completed.future;

    expect(scheduledRuns, 0);
    expect(manualRuns, 1);
  });

  test('does not run a second loop concurrently', () async {
    int runCount = 0;
    final Completer<void> release = Completer<void>();
    final BackgroundRefreshLoop loop = BackgroundRefreshLoop(
      runOnce: () async {
        runCount++;
        await release.future;
        return null;
      },
    );

    final Future<void> firstLoop = loop.run();
    final Future<void> secondLoop = loop.run();
    release.complete();
    await Future.wait(<Future<void>>[firstLoop, secondLoop]);

    expect(runCount, 1);
  });
}
