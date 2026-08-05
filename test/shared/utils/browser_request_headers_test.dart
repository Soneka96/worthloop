import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:worth_loop/shared/utils/browser_request_headers.dart';

void main() {
  group('BrowserRequestHeaders behaves correctly', () {
    test('builds an Android User-Agent from device data', () {
      final String userAgent = BrowserRequestHeaders.androidUserAgent(
        release: '15',
        model: 'SM-S938B',
      );

      expect(
        userAgent,
        'Mozilla/5.0 (Linux; Android 15; SM-S938B) '
        'AppleWebKit/537.36 (KHTML, like Gecko) Mobile Safari/537.36',
      );
    });

    test('builds an iOS User-Agent from device data', () {
      final String userAgent = BrowserRequestHeaders.iosUserAgent(
        'iPhone OS',
        '18.5',
      );

      expect(
        userAgent,
        'Mozilla/5.0 (iPhone; CPU iPhone OS 18.5 like Mac OS X) '
        'AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148',
      );
    });

    test('builds Accept-Language from a locale with a country', () {
      expect(
        BrowserRequestHeaders.acceptLanguage(const Locale('pt', 'PT')),
        'pt-PT,pt;q=0.9',
      );
    });

    test('builds Accept-Language from a locale without a country', () {
      expect(
        BrowserRequestHeaders.acceptLanguage(const Locale('en')),
        'en,en;q=0.9',
      );
    });
  });
}
