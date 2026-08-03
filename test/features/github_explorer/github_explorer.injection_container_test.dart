// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/data/datasources/github_local.datasource.dart';
import 'package:worth_loop/features/github_explorer/data/datasources/github_remote.datasource.dart';
import 'package:worth_loop/features/github_explorer/domain/repositories/Igithub_explorer.repository.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/load_recent_searches.usecase.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/search_profile.usecase.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/toggle_favorite.usecase.dart';
import 'package:worth_loop/features/github_explorer/github_explorer.injection_container.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/viewmodels/github_explorer_screen.viewmodel.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:dio/dio.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

class MockDio extends Mock implements Dio {}

void main() {
  setUp(() {
    // The GitHub Explorer feature container only needs AppDatabase and Dio
    // registered — mocks keep this test from booting the real shared layer
    // (drift, GoRouter, etc).
    sl.registerSingleton<AppDatabase>(MockAppDatabase());
    sl.registerSingleton<Dio>(MockDio());
    initGithubExplorerDependencies();
  });

  tearDown(() async => sl.reset());

  group(
    'github_explorer.injection_container — github_explorer feature registrations',
    () {
      test('datasources are registered', () {
        expect(
          sl.isRegistered<GithubLocalDatasource>(),
          isTrue,
          reason: 'GithubLocalDatasource should be registered',
        );
        expect(
          sl.isRegistered<GithubRemoteDatasource>(),
          isTrue,
          reason: 'GithubRemoteDatasource should be registered',
        );
      });

      test('repositories are registered', () {
        expect(
          sl.isRegistered<IGithubExplorerRepository>(),
          isTrue,
          reason: 'IGithubExplorerRepository should be registered',
        );
      });

      test('usecases are registered', () {
        expect(
          sl.isRegistered<SearchProfileUseCase>(),
          isTrue,
          reason: 'SearchProfileUseCase should be registered',
        );
        expect(
          sl.isRegistered<LoadRecentSearchesUseCase>(),
          isTrue,
          reason: 'LoadRecentSearchesUseCase should be registered',
        );
        expect(
          sl.isRegistered<ToggleFavoriteUseCase>(),
          isTrue,
          reason: 'ToggleFavoriteUseCase should be registered',
        );
      });

      test('viewmodels are registered', () {
        expect(
          sl.isRegistered<GithubExplorerScreenViewModel>(),
          isTrue,
          reason: 'GithubExplorerScreenViewModel should be registered',
        );
      });
    },
  );
}
