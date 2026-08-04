// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String applicationId = 'io.github.soneka96.worthloop';

  group('Android application identity', () {
    test('Gradle uses the final namespace and application ID', () async {
      final String buildConfig = await File(
        'android/app/build.gradle.kts',
      ).readAsString();

      expect(buildConfig, contains('namespace = "$applicationId"'));
      expect(buildConfig, contains('applicationId = "$applicationId"'));
      expect(buildConfig, isNot(contains('com.worthloop.worth_loop')));
    });

    test('MainActivity uses the final package path and declaration', () async {
      final File mainActivity = File(
        'android/app/src/main/kotlin/io/github/soneka96/worthloop/MainActivity.kt',
      );
      final File legacyMainActivity = File(
        'android/app/src/main/kotlin/com/worthloop/worth_loop/MainActivity.kt',
      );
      final bool mainActivityExists = await mainActivity.exists();
      final bool legacyMainActivityExists = await legacyMainActivity.exists();

      expect(mainActivityExists, isA<bool>());
      expect(mainActivityExists, isTrue);
      expect(legacyMainActivityExists, isA<bool>());
      expect(legacyMainActivityExists, isFalse);
      expect(
        await mainActivity.readAsString(),
        contains('package $applicationId'),
      );
    });

    test('Android manifest uses the WorthLoop launcher label', () async {
      final String manifest = await File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsString();

      expect(manifest, contains('android:label="WorthLoop"'));
    });

    test('Product documentation records the final application ID', () async {
      final String readme = await File('README.md').readAsString();
      final String product = await File('PRODUCT.md').readAsString();

      expect(readme, contains(applicationId));
      expect(readme, isNot(contains('temporary **Home** launcher')));
      expect(product, contains(applicationId));
      expect(product, isNot(contains('owner prefix is undecided')));
    });
  });
}
