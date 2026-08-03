// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/shared/navigation/navigator_service.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('NavigatorService behaves correctly', () {
    late MockGoRouter mockRouter;
    late NavigatorService navigatorService;

    setUp(() {
      mockRouter = MockGoRouter();
      when(() => mockRouter.push(any())).thenAnswer((_) async => null);
      when(() => mockRouter.replace(any())).thenAnswer((_) async => null);
      navigatorService = NavigatorService(mockRouter);
    });

    test('go calls GoRouter.go() with the given path', () {
      navigatorService.go('/settings');

      verify(() => mockRouter.go('/settings')).called(1);
    });

    test('push calls GoRouter.push() with the given path', () {
      navigatorService.push('/settings');

      verify(() => mockRouter.push('/settings')).called(1);
    });

    test('replace calls GoRouter.replace() with the given path', () {
      navigatorService.replace('/settings');

      verify(() => mockRouter.replace('/settings')).called(1);
    });

    test('pop calls GoRouter.pop()', () {
      navigatorService.pop();

      verify(() => mockRouter.pop<Object?>()).called(1);
    });
  });
}
