// Package imports:
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/data/datasources/github_local.datasource.dart';
import 'package:worth_loop/features/github_explorer/data/models/github_profile.model.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/github_profile_model.fixture.dart';

void main() {
  late AppDatabase db;
  late GithubLocalDatasource datasource;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    datasource = GithubLocalDatasource(db);
  });

  tearDown(() async => db.close());

  group('Method cacheProfile() returns the correct value', () {
    test(
      'cacheProfile() persists the profile so a subsequent getCachedProfile() returns it',
      () async {
        final GithubProfileModel profile = buildGithubProfileModel(
          username: 'octocat',
        );

        final Either<Failure, Unit> result = await datasource.cacheProfile(
          profile,
        );

        expect(result.isRight(), isTrue);
        final GithubProfileModel? cached = (await datasource.getCachedProfile(
          'octocat',
        )).getOrElse((_) => null);
        expect(cached?.username, 'octocat');
      },
    );

    test(
      'cacheProfile() overwrites the existing row for the same username',
      () async {
        await datasource.cacheProfile(
          buildGithubProfileModel(username: 'octocat', followers: 1),
        );

        await datasource.cacheProfile(
          buildGithubProfileModel(username: 'octocat', followers: 2),
        );

        final GithubProfileModel? cached = (await datasource.getCachedProfile(
          'octocat',
        )).getOrElse((_) => null);
        expect(cached?.followers, 2);
      },
    );

    test(
      'cacheProfile() returns a Left(DatabaseFailure) when the table is missing',
      () async {
        await db.customStatement('DROP TABLE github_profile_table');

        final Either<Failure, Unit> result = await datasource.cacheProfile(
          buildGithubProfileModel(),
        );

        expect(result.isLeft(), isTrue);
        result.match(
          (failure) => expect(failure, isA<DatabaseFailure>()),
          (_) => fail('expected Left, got Right(unit)'),
        );
      },
    );
  });

  group('Method getCachedProfile() returns the correct value', () {
    test(
      'getCachedProfile() returns Right(null) when username is not cached',
      () async {
        final Either<Failure, GithubProfileModel?> result = await datasource
            .getCachedProfile('nobody');

        expect(result.isRight(), isTrue);
        expect(result.getOrElse((_) => buildGithubProfileModel()), isNull);
      },
    );

    test(
      'getCachedProfile() returns a Left(DatabaseFailure) when the table is missing',
      () async {
        await db.customStatement('DROP TABLE github_profile_table');

        final Either<Failure, GithubProfileModel?> result = await datasource
            .getCachedProfile('octocat');

        expect(result.isLeft(), isTrue);
      },
    );
  });

  group('Method loadRecentSearches() returns the correct value', () {
    test(
      'loadRecentSearches() returns a Right(empty list) when nothing is cached',
      () async {
        final Either<Failure, List<GithubProfileModel>> result = await datasource
            .loadRecentSearches();

        expect(result.isRight(), isTrue);
        expect(result.getOrElse((_) => []), isEmpty);
      },
    );

    test('loadRecentSearches() orders by fetchedAt descending', () async {
      await datasource.cacheProfile(
        buildGithubProfileModel(
          username: 'older',
          fetchedAt: DateTime(2026, 1, 1),
        ),
      );
      await datasource.cacheProfile(
        buildGithubProfileModel(
          username: 'newer',
          fetchedAt: DateTime(2026, 1, 2),
        ),
      );

      final List<GithubProfileModel> profiles = (await datasource
              .loadRecentSearches())
          .getOrElse((_) => []);

      expect(profiles.first.username, 'newer');
      expect(profiles.last.username, 'older');
    });

    test(
      'loadRecentSearches() returns a Left(DatabaseFailure) when the table is missing',
      () async {
        await db.customStatement('DROP TABLE github_profile_table');

        final Either<Failure, List<GithubProfileModel>> result = await datasource
            .loadRecentSearches();

        expect(result.isLeft(), isTrue);
      },
    );
  });

  group('Method toggleFavorite() returns the correct value', () {
    test(
      'toggleFavorite() flips isFavorite from false to true',
      () async {
        await datasource.cacheProfile(
          buildGithubProfileModel(username: 'octocat', isFavorite: false),
        );

        await datasource.toggleFavorite('octocat');

        final GithubProfileModel? cached = (await datasource.getCachedProfile(
          'octocat',
        )).getOrElse((_) => null);
        expect(cached?.isFavorite, isTrue);
      },
    );

    test(
      'toggleFavorite() flips isFavorite from true to false',
      () async {
        await datasource.cacheProfile(
          buildGithubProfileModel(username: 'octocat', isFavorite: true),
        );

        await datasource.toggleFavorite('octocat');

        final GithubProfileModel? cached = (await datasource.getCachedProfile(
          'octocat',
        )).getOrElse((_) => null);
        expect(cached?.isFavorite, isFalse);
      },
    );

    test(
      'toggleFavorite() returns Right(unit) without writing when username is not cached',
      () async {
        final Either<Failure, Unit> result = await datasource.toggleFavorite(
          'nobody',
        );

        expect(result, const Right(unit));
      },
    );

    test(
      'toggleFavorite() returns a Left(DatabaseFailure) when the table is missing',
      () async {
        await db.customStatement('DROP TABLE github_profile_table');

        final Either<Failure, Unit> result = await datasource.toggleFavorite(
          'octocat',
        );

        expect(result.isLeft(), isTrue);
      },
    );
  });
}
