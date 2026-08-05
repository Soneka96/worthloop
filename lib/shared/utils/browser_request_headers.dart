// Dart imports:
import 'dart:io';
import 'dart:ui' show Locale, PlatformDispatcher;

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';

/// Builds browser-like request headers from the current device and locale.
abstract final class BrowserRequestHeaders {
  /// Returns headers appropriate for the current mobile platform.
  static Future<Map<String, String>> build({
    DeviceInfoPlugin? deviceInfo,
    Locale? locale,
  }) async {
    final DeviceInfoPlugin plugin = deviceInfo ?? DeviceInfoPlugin();
    final String userAgent;

    if (Platform.isAndroid) {
      final AndroidDeviceInfo info = await plugin.androidInfo;
      userAgent = androidUserAgent(
        release: info.version.release,
        model: info.model,
      );
    } else if (Platform.isIOS) {
      final IosDeviceInfo info = await plugin.iosInfo;
      userAgent = iosUserAgent(info.systemName, info.systemVersion);
    } else {
      userAgent = 'Mozilla/5.0 (${Platform.operatingSystem})';
    }

    return {
      'User-Agent': userAgent,
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
      'Accept-Language': acceptLanguage(
        locale ?? PlatformDispatcher.instance.locale,
      ),
    };
  }

  /// Builds an Android mobile User-Agent from runtime device information.
  @visibleForTesting
  static String androidUserAgent({
    required String release,
    required String model,
  }) =>
      'Mozilla/5.0 (Linux; Android $release; $model) '
      'AppleWebKit/537.36 (KHTML, like Gecko) Mobile Safari/537.36';

  /// Builds an iOS mobile User-Agent from runtime device information.
  @visibleForTesting
  static String iosUserAgent(String systemName, String systemVersion) =>
      'Mozilla/5.0 (iPhone; CPU $systemName $systemVersion like Mac OS X) '
      'AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148';

  /// Formats the current locale without hardcoded language choices.
  @visibleForTesting
  static String acceptLanguage(Locale locale) {
    final String language = locale.languageCode;
    final String? country = locale.countryCode;
    final String primary = country == null ? language : '$language-$country';
    return '$primary,$language;q=0.9';
  }
}
