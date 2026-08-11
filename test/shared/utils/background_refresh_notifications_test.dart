// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/background_refresh_notifications.dart';

void main() {
  group('BackgroundRefreshNotifications behaves correctly', () {
    test(
      'notifyProgress() calls notifyEngine() with the completed and total counts when showRefreshProgress = true',
      () async {
        String? notifiedMethod;
        Object? notifiedArguments;
        final BackgroundRefreshNotifications notifications =
            BackgroundRefreshNotifications(
              loadSettings: () async => const Right(
                RefreshSettings(intervalMinutes: 60, showRefreshProgress: true),
              ),
              notifyEngine: (String method, {Object? arguments}) async {
                notifiedMethod = method;
                notifiedArguments = arguments;
              },
            );

        await notifications.notifyProgress(2, 5);

        expect(notifiedMethod, isA<String>());
        expect(notifiedMethod, 'updateProgress');
        expect(notifiedArguments, <String, int>{'completed': 2, 'total': 5});
      },
    );

    test(
      'notifyProgress() does not call notifyEngine() when showRefreshProgress = false',
      () async {
        bool notifyEngineCalled = false;
        final BackgroundRefreshNotifications notifications =
            BackgroundRefreshNotifications(
              loadSettings: () async => const Right(
                RefreshSettings(
                  intervalMinutes: 60,
                  showRefreshProgress: false,
                ),
              ),
              notifyEngine: (String method, {Object? arguments}) async {
                notifyEngineCalled = true;
              },
            );

        await notifications.notifyProgress(2, 5);

        expect(notifyEngineCalled, isFalse);
      },
    );

    test(
      'notifyProgress() does not call notifyEngine() when loadSettings() fails',
      () async {
        bool notifyEngineCalled = false;
        final BackgroundRefreshNotifications notifications =
            BackgroundRefreshNotifications(
              loadSettings: () async =>
                  const Left(DatabaseFailure('database failed')),
              notifyEngine: (String method, {Object? arguments}) async {
                notifyEngineCalled = true;
              },
            );

        await notifications.notifyProgress(2, 5);

        expect(notifyEngineCalled, isFalse);
      },
    );

    test(
      'notifyOutcome(true) calls notifyEngine() with refreshCompleted and showResult = true when refreshCompletedAlertsEnabled = true',
      () async {
        String? notifiedMethod;
        Object? notifiedArguments;
        final BackgroundRefreshNotifications notifications =
            BackgroundRefreshNotifications(
              loadSettings: () async => const Right(
                RefreshSettings(
                  intervalMinutes: 60,
                  refreshCompletedAlertsEnabled: true,
                ),
              ),
              notifyEngine: (String method, {Object? arguments}) async {
                notifiedMethod = method;
                notifiedArguments = arguments;
              },
            );

        await notifications.notifyOutcome(true);

        expect(notifiedMethod, isA<String>());
        expect(notifiedMethod, 'refreshCompleted');
        expect(notifiedArguments, <String, bool>{'showResult': true});
      },
    );

    test(
      'notifyOutcome(true) calls notifyEngine() with refreshCompleted and showResult = false when refreshCompletedAlertsEnabled = false',
      () async {
        Object? notifiedArguments;
        final BackgroundRefreshNotifications notifications =
            BackgroundRefreshNotifications(
              loadSettings: () async => const Right(
                RefreshSettings(
                  intervalMinutes: 60,
                  refreshCompletedAlertsEnabled: false,
                ),
              ),
              notifyEngine: (String method, {Object? arguments}) async {
                notifiedArguments = arguments;
              },
            );

        await notifications.notifyOutcome(true);

        expect(notifiedArguments, <String, bool>{'showResult': false});
      },
    );

    test(
      'notifyOutcome(false) calls notifyEngine() with refreshFailed and the current showResult',
      () async {
        String? notifiedMethod;
        Object? notifiedArguments;
        final BackgroundRefreshNotifications notifications =
            BackgroundRefreshNotifications(
              loadSettings: () async => const Right(
                RefreshSettings(
                  intervalMinutes: 60,
                  refreshCompletedAlertsEnabled: true,
                ),
              ),
              notifyEngine: (String method, {Object? arguments}) async {
                notifiedMethod = method;
                notifiedArguments = arguments;
              },
            );

        await notifications.notifyOutcome(false);

        expect(notifiedMethod, 'refreshFailed');
        expect(notifiedArguments, <String, bool>{'showResult': true});
      },
    );

    test(
      'notifyOutcome(true) defaults showResult to false when loadSettings() fails',
      () async {
        Object? notifiedArguments;
        final BackgroundRefreshNotifications notifications =
            BackgroundRefreshNotifications(
              loadSettings: () async =>
                  const Left(DatabaseFailure('database failed')),
              notifyEngine: (String method, {Object? arguments}) async {
                notifiedArguments = arguments;
              },
            );

        await notifications.notifyOutcome(true);

        expect(notifiedArguments, <String, bool>{'showResult': false});
      },
    );

    test(
      'notifyOutcome(false) defaults showResult to false when loadSettings() fails',
      () async {
        String? notifiedMethod;
        Object? notifiedArguments;
        final BackgroundRefreshNotifications notifications =
            BackgroundRefreshNotifications(
              loadSettings: () async =>
                  const Left(DatabaseFailure('database failed')),
              notifyEngine: (String method, {Object? arguments}) async {
                notifiedMethod = method;
                notifiedArguments = arguments;
              },
            );

        await notifications.notifyOutcome(false);

        expect(notifiedMethod, 'refreshFailed');
        expect(notifiedArguments, <String, bool>{'showResult': false});
      },
    );
  });
}
