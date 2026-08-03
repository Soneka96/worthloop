// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/state/home.actions.dart';
import 'package:worth_loop/features/home/presentation/state/home.middleware.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/navigation/app_routes.dart';
import 'package:worth_loop/shared/navigation/navigator_service.dart';
import 'package:worth_loop/shared/state/app.state.dart';

class MockStore extends Mock implements Store<AppState> {}

class MockNavigatorService extends Mock implements NavigatorService {}

void main() {
  late HomeMiddleware middleware;
  late MockStore store;
  late MockNavigatorService mockNavigatorService;
  late List<dynamic> actionLog;

  void next(dynamic action) => actionLog.add(action);

  setUp(() {
    middleware = HomeMiddleware();
    store = MockStore();
    mockNavigatorService = MockNavigatorService();
    actionLog = [];

    when(() => store.dispatch(any())).thenAnswer(
      (invocation) => actionLog.add(invocation.positionalArguments[0]),
    );

    sl.registerSingleton<NavigatorService>(mockNavigatorService);
  });

  tearDown(() => sl.reset());

  group('HomeMiddleware processes GoToGithubExplorerAction', () {
    test('GoToGithubExplorerAction calls NavigatorService.push when called', () {
      middleware.call(store, const GoToGithubExplorerAction(), next);

      expect(actionLog.length, 1);
      expect(actionLog[0], isA<GoToGithubExplorerAction>());
      verify(
        () => mockNavigatorService.push(AppRoutes.githubExplorer),
      ).called(1);
    });
  });

  group('HomeMiddleware processes GoToSettingsAction', () {
    test('GoToSettingsAction calls NavigatorService.push when called', () {
      middleware.call(store, const GoToSettingsAction(), next);

      expect(actionLog.length, 1);
      expect(actionLog[0], isA<GoToSettingsAction>());
      verify(() => mockNavigatorService.push(AppRoutes.appSettings)).called(1);
    });
  });
}
