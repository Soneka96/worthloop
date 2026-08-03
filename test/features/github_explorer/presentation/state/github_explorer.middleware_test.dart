// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/load_recent_searches.usecase.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/params/search_profile.params.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/params/toggle_favorite.params.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/search_profile.usecase.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/toggle_favorite.usecase.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.actions.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.middleware.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/navigation/app_routes.dart';
import 'package:worth_loop/shared/navigation/navigator_service.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import '../../fixtures/github_profile.fixture.dart';

class MockStore extends Mock implements Store<AppState> {}

class MockSearchProfileUseCase extends Mock implements SearchProfileUseCase {}

class MockLoadRecentSearchesUseCase extends Mock
    implements LoadRecentSearchesUseCase {}

class MockToggleFavoriteUseCase extends Mock implements ToggleFavoriteUseCase {}

class MockNavigatorService extends Mock implements NavigatorService {}

class FakeSearchProfileParams extends Fake implements SearchProfileParams {}

class FakeToggleFavoriteParams extends Fake implements ToggleFavoriteParams {}

void main() {
  late GithubExplorerMiddleware middleware;
  late MockStore store;
  late MockSearchProfileUseCase mockSearchUseCase;
  late MockLoadRecentSearchesUseCase mockLoadUseCase;
  late MockToggleFavoriteUseCase mockToggleUseCase;
  late MockNavigatorService mockNavigatorService;
  late List<dynamic> actionLog;

  void next(dynamic action) => actionLog.add(action);

  setUpAll(() {
    registerFallbackValue(FakeSearchProfileParams());
    registerFallbackValue(FakeToggleFavoriteParams());
    registerFallbackValue(NoParams());
  });

  setUp(() {
    middleware = GithubExplorerMiddleware();
    store = MockStore();
    mockSearchUseCase = MockSearchProfileUseCase();
    mockLoadUseCase = MockLoadRecentSearchesUseCase();
    mockToggleUseCase = MockToggleFavoriteUseCase();
    mockNavigatorService = MockNavigatorService();
    actionLog = [];

    when(() => store.dispatch(any())).thenAnswer(
      (invocation) => actionLog.add(invocation.positionalArguments[0]),
    );

    sl.registerSingleton<SearchProfileUseCase>(mockSearchUseCase);
    sl.registerSingleton<LoadRecentSearchesUseCase>(mockLoadUseCase);
    sl.registerSingleton<ToggleFavoriteUseCase>(mockToggleUseCase);
    sl.registerSingleton<NavigatorService>(mockNavigatorService);
  });

  tearDown(() => sl.reset());

  group('GithubExplorerMiddleware processes SearchProfileAction', () {
    test(
      'SearchProfileAction dispatches ProfileFoundAction then LoadRecentSearchesAction when the usecase succeeds',
      () async {
        final GithubProfile profile = buildGithubProfile(username: 'octocat');
        when(
          () => mockSearchUseCase(any()),
        ).thenAnswer((_) async => Right(profile));
        when(
          () => mockLoadUseCase(any()),
        ).thenAnswer((_) async => const Right([]));

        middleware.call(store, const SearchProfileAction('octocat'), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[0], isA<SearchProfileAction>());
        expect(actionLog[1], isA<ProfileFoundAction>());
        expect((actionLog[1] as ProfileFoundAction).profile, profile);
        expect(actionLog[2], isA<LoadRecentSearchesAction>());
        verify(
          () =>
              mockSearchUseCase(const SearchProfileParams(username: 'octocat')),
        ).called(1);
      },
    );

    test(
      'SearchProfileAction dispatches SearchFailedAction then LoadRecentSearchesAction when the usecase fails',
      () async {
        const NetworkFailure failure = NetworkFailure('boom');
        when(
          () => mockSearchUseCase(any()),
        ).thenAnswer((_) async => const Left(failure));
        when(
          () => mockLoadUseCase(any()),
        ).thenAnswer((_) async => const Right([]));

        middleware.call(store, const SearchProfileAction('octocat'), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[1], isA<SearchFailedAction>());
        expect((actionLog[1] as SearchFailedAction).message, 'boom');
        expect(actionLog[2], isA<LoadRecentSearchesAction>());
      },
    );
  });

  group('GithubExplorerMiddleware processes LoadRecentSearchesAction', () {
    test(
      'LoadRecentSearchesAction dispatches RecentSearchesLoadedAction with the loaded profiles when the usecase succeeds',
      () async {
        final GithubProfile profile = buildGithubProfile();
        when(
          () => mockLoadUseCase(any()),
        ).thenAnswer((_) async => Right([profile]));

        middleware.call(store, const LoadRecentSearchesAction(), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog.length, 2);
        expect(actionLog[1], isA<RecentSearchesLoadedAction>());
        expect((actionLog[1] as RecentSearchesLoadedAction).profiles, [
          profile,
        ]);
      },
    );

    test(
      'LoadRecentSearchesAction dispatches nothing else when the usecase fails',
      () async {
        const DatabaseFailure failure = DatabaseFailure('boom');
        when(
          () => mockLoadUseCase(any()),
        ).thenAnswer((_) async => const Left(failure));

        middleware.call(store, const LoadRecentSearchesAction(), next);
        await Future<void>.delayed(Duration.zero);

        expect(
          actionLog.length,
          1,
          reason: 'only the original action, no follow-up dispatch',
        );
      },
    );
  });

  group('GithubExplorerMiddleware processes ToggleFavoriteAction', () {
    test(
      'ToggleFavoriteAction calls ToggleFavoriteUseCase then dispatches LoadRecentSearchesAction',
      () async {
        when(
          () => mockToggleUseCase(any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockLoadUseCase(any()),
        ).thenAnswer((_) async => const Right([]));

        middleware.call(store, const ToggleFavoriteAction('octocat'), next);
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockToggleUseCase(
            const ToggleFavoriteParams(username: 'octocat'),
          ),
        ).called(1);
        expect(actionLog[1], isA<LoadRecentSearchesAction>());
      },
    );
  });

  group('GithubExplorerMiddleware processes GoToSettingsAction', () {
    test('GoToSettingsAction calls NavigatorService.push when called', () {
      middleware.call(store, const GoToSettingsAction(), next);

      expect(actionLog.length, 1);
      expect(actionLog[0], isA<GoToSettingsAction>());
      verify(() => mockNavigatorService.push(AppRoutes.appSettings)).called(1);
    });
  });

  group('GithubExplorerMiddleware processes GoToHomeAction', () {
    test('GoToHomeAction calls NavigatorService.pop when called', () {
      middleware.call(store, const GoToHomeAction(), next);

      expect(actionLog.length, 1);
      expect(actionLog[0], isA<GoToHomeAction>());
      verify(() => mockNavigatorService.pop()).called(1);
    });
  });
}
