// Package imports:
import 'package:dio/dio.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/data/datasources/github_local.datasource.dart';
import 'package:worth_loop/features/github_explorer/data/datasources/github_remote.datasource.dart';
import 'package:worth_loop/features/github_explorer/data/repositories/github_explorer.repository.dart';
import 'package:worth_loop/features/github_explorer/domain/repositories/Igithub_explorer.repository.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/load_recent_searches.usecase.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/search_profile.usecase.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/toggle_favorite.usecase.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/viewmodels/github_explorer_screen.viewmodel.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// Registers the GitHub Explorer feature's dependencies. Called from the
/// root [initDependencies].
void initGithubExplorerDependencies() {
  sl.registerLazySingleton<GithubLocalDatasource>(
    () => GithubLocalDatasource(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<GithubRemoteDatasource>(
    () => GithubRemoteDatasource(sl<Dio>()),
  );
  sl.registerLazySingleton<IGithubExplorerRepository>(
    () => GithubExplorerRepository(
      sl<GithubLocalDatasource>(),
      sl<GithubRemoteDatasource>(),
    ),
  );
  sl.registerLazySingleton<SearchProfileUseCase>(
    () => SearchProfileUseCase(sl<IGithubExplorerRepository>()),
  );
  sl.registerLazySingleton<LoadRecentSearchesUseCase>(
    () => LoadRecentSearchesUseCase(sl<IGithubExplorerRepository>()),
  );
  sl.registerLazySingleton<ToggleFavoriteUseCase>(
    () => ToggleFavoriteUseCase(sl<IGithubExplorerRepository>()),
  );
  sl.registerFactoryParam<GithubExplorerScreenViewModel, Store<AppState>, void>(
    (store, _) => GithubExplorerScreenViewModel.fromStore(store),
  );
}
