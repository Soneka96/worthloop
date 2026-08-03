// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/data/datasources/github_local.datasource.dart';
import 'package:worth_loop/features/github_explorer/data/datasources/github_remote.datasource.dart';
import 'package:worth_loop/features/github_explorer/data/models/github_profile.model.dart';
import 'package:worth_loop/features/github_explorer/data/repositories/github_explorer.repository.dart';
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/features/github_explorer/domain/repositories/Igithub_explorer.repository.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/github_profile_model.fixture.dart';

class MockGithubLocalDatasource extends Mock implements GithubLocalDatasource {}

class MockGithubRemoteDatasource extends Mock
    implements GithubRemoteDatasource {}

void main() {
  late MockGithubLocalDatasource mockLocal;
  late MockGithubRemoteDatasource mockRemote;
  late GithubExplorerRepository repository;

  const failure = NetworkFailure('boom');

  setUpAll(() {
    registerFallbackValue(buildGithubProfileModel());
  });

  setUp(() {
    mockLocal = MockGithubLocalDatasource();
    mockRemote = MockGithubRemoteDatasource();
    repository = GithubExplorerRepository(mockLocal, mockRemote);
  });

  group(
    'GithubExplorerRepository implements the appropriate repository interface',
    () {
      test(
        'GithubExplorerRepository is an implementation of IGithubExplorerRepository',
        () {
          expect(repository, isA<IGithubExplorerRepository>());
        },
      );
    },
  );

  group('GithubExplorerRepository implements searchProfile() correctly', () {
    test(
      'Method searchProfile() returns Right(GithubProfile) and caches it when the remote datasource returns Right',
      () async {
        final GithubProfileModel profile = buildGithubProfileModel(
          username: 'octocat',
        );
        when(
          () => mockRemote.fetchProfile('octocat'),
        ).thenAnswer((_) async => Right(profile));
        when(
          () => mockLocal.cacheProfile(any()),
        ).thenAnswer((_) async => const Right(unit));

        final Either<Failure, GithubProfile> result = await repository
            .searchProfile('octocat');

        expect(result, Right(profile));
        verify(() => mockLocal.cacheProfile(profile)).called(1);
      },
    );

    test(
      'Method searchProfile() falls back to the cached profile when the remote datasource returns Left and a cached copy exists',
      () async {
        final GithubProfileModel cached = buildGithubProfileModel(
          username: 'octocat',
        );
        when(
          () => mockRemote.fetchProfile('octocat'),
        ).thenAnswer((_) async => const Left(failure));
        when(
          () => mockLocal.getCachedProfile('octocat'),
        ).thenAnswer((_) async => Right(cached));

        final Either<Failure, GithubProfile> result = await repository
            .searchProfile('octocat');

        expect(result, Right(cached));
      },
    );

    test(
      'Method searchProfile() returns Left(NetworkFailure) when the remote datasource returns Left and no cached copy exists',
      () async {
        when(
          () => mockRemote.fetchProfile('octocat'),
        ).thenAnswer((_) async => const Left(failure));
        when(
          () => mockLocal.getCachedProfile('octocat'),
        ).thenAnswer((_) async => const Right(null));

        final Either<Failure, GithubProfile> result = await repository
            .searchProfile('octocat');

        expect(result, const Left(failure));
      },
    );

    test(
      'Method searchProfile() returns Left(NetworkFailure) when the remote datasource returns Left and the cache read itself fails',
      () async {
        when(
          () => mockRemote.fetchProfile('octocat'),
        ).thenAnswer((_) async => const Left(failure));
        when(
          () => mockLocal.getCachedProfile('octocat'),
        ).thenAnswer((_) async => const Left(DatabaseFailure('cache boom')));

        final Either<Failure, GithubProfile> result = await repository
            .searchProfile('octocat');

        expect(
          result,
          const Left(failure),
          reason: 'the original network failure surfaces, not the cache failure',
        );
      },
    );
  });

  group(
    'GithubExplorerRepository implements loadRecentSearches() correctly',
    () {
      test(
        'Method loadRecentSearches() returns whatever the local datasource returns',
        () async {
          final GithubProfileModel profile = buildGithubProfileModel();
          when(
            () => mockLocal.loadRecentSearches(),
          ).thenAnswer((_) async => Right([profile]));

          final Either<Failure, List<GithubProfile>> result = await repository
              .loadRecentSearches();

          expect(result.isRight(), isTrue);
          result.match(
            (f) => fail('expected Right, got Left($f)'),
            (profiles) => expect(profiles, [profile]),
          );
          verify(() => mockLocal.loadRecentSearches()).called(1);
        },
      );
    },
  );

  group('GithubExplorerRepository implements toggleFavorite() correctly', () {
    test(
      'Method toggleFavorite() calls GithubLocalDatasource.toggleFavorite() when called',
      () async {
        when(
          () => mockLocal.toggleFavorite('octocat'),
        ).thenAnswer((_) async => const Right(unit));

        final Either<Failure, Unit> result = await repository.toggleFavorite(
          'octocat',
        );

        expect(result, const Right(unit));
        verify(() => mockLocal.toggleFavorite('octocat')).called(1);
      },
    );
  });
}
