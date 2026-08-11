import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('background refresh bridge exposes the request command', () {
    final mainActivity = File(
      'android/app/src/main/kotlin/io/github/soneka96/worthloop/MainActivity.kt',
    ).readAsStringSync().replaceAll('\r\n', '\n');
    final backgroundService = File(
      'android/app/src/main/kotlin/io/github/soneka96/worthloop/BackgroundRefreshService.kt',
    ).readAsStringSync().replaceAll('\r\n', '\n');

    expect(mainActivity, contains('"requestRefresh"'));
    expect(
      mainActivity,
      contains('Intent(this, BackgroundRefreshService::class.java)'),
    );
    expect(mainActivity, contains('ACTION_REQUEST_REFRESH'));
    expect(backgroundService, contains('ACTION_REQUEST_REFRESH'));
    expect(backgroundService, contains('ENGINE_CHANNEL'));
    expect(backgroundService, contains('"refreshNow"'));
    expect(backgroundService, contains('"stopService"'));
    expect(backgroundService, contains('"refreshStarted"'));
    expect(backgroundService, contains('"refreshCompleted"'));
    expect(backgroundService, contains('"refreshFailed"'));
    expect(backgroundService, contains('RESULT_CHANNEL_ID'));
    expect(backgroundService, contains('consumePendingSourceIds'));
    expect(
      backgroundService,
      contains('intent?.action == ACTION_REQUEST_REFRESH'),
    );
    expect(backgroundService, contains('pendingSourceIds'));
    expect(backgroundService, contains('addAll'));
    expect(backgroundService, contains('if (!engineStarted)'));
    expect(backgroundService, contains('startFlutterEngine()'));
    expect(backgroundService, contains('import android.app.PendingIntent'));
    expect(
      backgroundService,
      contains(
        'PendingIntent.getActivity(\n            this,\n            NOTIFICATION_ID,',
      ),
    );
    expect(
      'setContentIntent(contentPendingIntent())'
          .allMatches(backgroundService)
          .length,
      3,
    );
    expect(
      'updateForegroundNotification("Refreshing prices…")'
          .allMatches(backgroundService)
          .length,
      2,
    );
    expect(
      backgroundService,
      contains('engineChannel?.invokeMethod("rescheduleRefresh", null)'),
    );
    expect(backgroundService, contains('sourceIds.isEmpty()'));
  });

  test('background entrypoint reports refresh lifecycle status', () {
    final entrypoint = File(
      'lib/shared/background_refresh_entrypoint.dart',
    ).readAsStringSync();
    final notifications = File(
      'lib/shared/utils/background_refresh_notifications.dart',
    ).readAsStringSync();

    expect(entrypoint, contains("'refreshStarted'"));
    expect(entrypoint, contains('runRefresh(force: false)'));
    expect(entrypoint, contains('runRefresh(force: true)'));
    expect(entrypoint, contains("'rescheduleRefresh'"));
    expect(entrypoint, contains('loop.requestRefresh()'));
    expect(notifications, contains("'refreshCompleted'"));
    expect(notifications, contains("'refreshFailed'"));
  });
}
