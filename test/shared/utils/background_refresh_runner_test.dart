// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/shared/constants/refresh_interval_constants.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/background_refresh_runner.dart';

void main() {
  group('BackgroundRefreshRunner behaves correctly', () {
    test('refreshes enabled settings and returns their interval', () async {
      int refreshCalls = 0;
      final BackgroundRefreshRunner runner = BackgroundRefreshRunner(
        loadSettings: () async => const Right(
          RefreshSettings(intervalMinutes: 180, browserRefreshEnabled: true),
        ),
        refreshAllProducts: () async {
          refreshCalls++;
          return const Right(unit);
        },
      );

      final Duration? nextDelay = await runner.runOnce();

      expect(nextDelay, const Duration(minutes: 180));
      expect(refreshCalls, 1);
    });

    test('reports whether the refresh use case succeeded', () async {
      bool? succeeded;
      final BackgroundRefreshRunner runner = BackgroundRefreshRunner(
        loadSettings: () async => const Right(
          RefreshSettings(intervalMinutes: 60, browserRefreshEnabled: true),
        ),
        refreshAllProducts: () async =>
            const Left(DatabaseFailure('fetch failed')),
      );

      await runner.runOnce(
        onRefreshOutcome: (bool value) async => succeeded = value,
      );

      expect(succeeded, isFalse);
    });

    test('reports start and successful outcome around a refresh', () async {
      bool started = false;
      bool? succeeded;
      final BackgroundRefreshRunner runner = BackgroundRefreshRunner(
        loadSettings: () async => const Right(
          RefreshSettings(intervalMinutes: 60, browserRefreshEnabled: true),
        ),
        refreshAllProducts: () async => const Right(unit),
      );

      await runner.runOnce(
        onRefreshStarted: () async => started = true,
        onRefreshOutcome: (bool value) async => succeeded = value,
      );

      expect(started, isTrue);
      expect(succeeded, isTrue);
    });

    test(
      'reports start and successful outcome when settings fail to load',
      () async {
        bool started = false;
        bool? succeeded;
        final BackgroundRefreshRunner runner = BackgroundRefreshRunner(
          loadSettings: () async => const Left(DatabaseFailure('failed')),
          refreshAllProducts: () async => const Right(unit),
        );

        await runner.runOnce(
          onRefreshStarted: () async => started = true,
          onRefreshOutcome: (bool value) async => succeeded = value,
        );

        expect(started, isTrue);
        expect(succeeded, isTrue);
      },
    );

    test('stops without refreshing when browser refresh is disabled', () async {
      int refreshCalls = 0;
      bool started = false;
      final BackgroundRefreshRunner runner = BackgroundRefreshRunner(
        loadSettings: () async =>
            const Right(RefreshSettings(intervalMinutes: 60)),
        refreshAllProducts: () async {
          refreshCalls++;
          return const Right(unit);
        },
      );

      final Duration? nextDelay = await runner.runOnce(
        onRefreshStarted: () async => started = true,
      );

      expect(nextDelay, isNull);
      expect(refreshCalls, 0);
      expect(started, isFalse);
    });

    test('forced refresh ignores the automatic refresh setting once', () async {
      int refreshCalls = 0;
      final BackgroundRefreshRunner runner = BackgroundRefreshRunner(
        loadSettings: () async =>
            const Right(RefreshSettings(intervalMinutes: 60)),
        refreshAllProducts: () async {
          refreshCalls++;
          return const Right(unit);
        },
      );

      final Duration? nextDelay = await runner.runOnce(force: true);

      expect(nextDelay, const Duration(minutes: 60));
      expect(refreshCalls, 1);
    });

    test('uses the hourly retry interval when settings cannot load', () async {
      int refreshCalls = 0;
      final BackgroundRefreshRunner runner = BackgroundRefreshRunner(
        loadSettings: () async => const Left(DatabaseFailure('failed')),
        refreshAllProducts: () async {
          refreshCalls++;
          return const Right(unit);
        },
      );

      final Duration? nextDelay = await runner.runOnce();

      expect(
        nextDelay,
        const Duration(minutes: RefreshIntervalConstants.hourly),
      );
      expect(refreshCalls, 1);
    });

    test(
      'uses the hourly interval when settings contain an invalid interval',
      () async {
        final BackgroundRefreshRunner runner = BackgroundRefreshRunner(
          loadSettings: () async => const Right(
            RefreshSettings(intervalMinutes: 0, browserRefreshEnabled: true),
          ),
          refreshAllProducts: () async => const Right(unit),
        );

        expect(
          await runner.runOnce(),
          const Duration(minutes: RefreshIntervalConstants.hourly),
        );
      },
    );
  });
}
