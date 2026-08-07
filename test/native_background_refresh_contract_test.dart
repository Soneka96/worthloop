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
    expect(
      backgroundService,
      contains('intent?.action == ACTION_REQUEST_REFRESH'),
    );
    expect(backgroundService, contains('pendingRefreshRequest.set(true)'));
    expect(backgroundService, contains('getAndSet(false)'));
    expect(backgroundService, contains('consumePendingRefreshRequest'));
  });
}
