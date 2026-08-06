// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

// Project imports:
import 'package:worth_loop/shared/utils/url_launcher_service.dart';

class MockUrlLauncherPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

void main() {
  late MockUrlLauncherPlatform mockPlatform;
  late UrlLauncherService service;

  Matcher isExternalApplicationMode() => predicate<LaunchOptions>(
    (LaunchOptions options) =>
        options.mode == PreferredLaunchMode.externalApplication,
  );

  setUp(() {
    mockPlatform = MockUrlLauncherPlatform();
    UrlLauncherPlatform.instance = mockPlatform;
    service = UrlLauncherService();
    registerFallbackValue(const LaunchOptions());
  });

  group('UrlLauncherService behaves correctly', () {
    test('delegates to the platform and returns true on success', () async {
      when(
        () => mockPlatform.launchUrl(
          any(),
          any(that: isExternalApplicationMode()),
        ),
      ).thenAnswer((_) async => true);

      final bool result = await service.open('https://example.com/product');

      expect(result, isA<bool>());
      expect(result, isTrue);
      verify(
        () => mockPlatform.launchUrl(
          'https://example.com/product',
          any(that: isExternalApplicationMode()),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockPlatform);
    });

    test('returns false when the platform reports failure', () async {
      when(
        () => mockPlatform.launchUrl(
          any(),
          any(that: isExternalApplicationMode()),
        ),
      ).thenAnswer((_) async => false);

      final bool result = await service.open('https://example.com/product');

      expect(result, isA<bool>());
      expect(result, isFalse);
      verify(
        () => mockPlatform.launchUrl(
          'https://example.com/product',
          any(that: isExternalApplicationMode()),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockPlatform);
    });

    test('returns false when the platform throws an Exception', () async {
      when(
        () => mockPlatform.launchUrl(
          any(),
          any(that: isExternalApplicationMode()),
        ),
      ).thenThrow(Exception('platform failure'));

      final bool result = await service.open('https://example.com/product');

      expect(result, isA<bool>());
      expect(result, isFalse);
      verify(
        () => mockPlatform.launchUrl(
          'https://example.com/product',
          any(that: isExternalApplicationMode()),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockPlatform);
    });

    test('lets a thrown Error propagate uncaught', () async {
      when(
        () => mockPlatform.launchUrl(
          any(),
          any(that: isExternalApplicationMode()),
        ),
      ).thenThrow(StateError('platform crashed'));

      expect(
        () => service.open('https://example.com/product'),
        throwsA(isA<StateError>()),
      );
    });

    test(
      'delegates an empty URL to the platform instead of treating it as malformed',
      () async {
        when(
          () => mockPlatform.launchUrl(
            any(),
            any(that: isExternalApplicationMode()),
          ),
        ).thenAnswer((_) async => true);

        final bool result = await service.open('');

        expect(result, isA<bool>());
        expect(result, isTrue);
        verify(
          () => mockPlatform.launchUrl(
            '',
            any(that: isExternalApplicationMode()),
          ),
        ).called(1);
      },
    );

    test(
      'returns false for a malformed URL without calling the platform',
      () async {
        final bool result = await service.open('https://[invalid');

        expect(result, isA<bool>());
        expect(result, isFalse);
        verifyZeroInteractions(mockPlatform);
      },
    );
  });
}
