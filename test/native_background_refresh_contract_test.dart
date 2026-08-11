import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('background refresh bridge exposes the request command', () {
    final mainActivity = File(
      'android/app/src/main/kotlin/io/github/soneka96/worthloop/MainActivity.kt',
    ).readAsStringSync();
    final backgroundService = File(
      'android/app/src/main/kotlin/io/github/soneka96/worthloop/BackgroundRefreshService.kt',
    ).readAsStringSync();

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
  });

  test('background entrypoint reports refresh lifecycle status', () {
    final entrypoint = File(
      'lib/shared/background_refresh_entrypoint.dart',
    ).readAsStringSync();

    expect(entrypoint, contains("'refreshStarted'"));
    expect(entrypoint, contains("'refreshCompleted'"));
    expect(entrypoint, contains("'refreshFailed'"));
    expect(entrypoint, contains('runRefresh(force: false)'));
    expect(entrypoint, contains('runRefresh(force: true)'));
  });
}
