// Package imports:
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/data/models/github_profile.model.dart';
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import '../../fixtures/github_profile_model.fixture.dart';
import '../../fixtures/github_repo.fixture.dart';

void main() {
  group('GithubProfileModel is an implementation of GithubProfile', () {
    test('GithubProfileModel is a GithubProfile', () {
      final GithubProfileModel model = buildGithubProfileModel();

      expect(model, isA<GithubProfile>());
    });
  });

  group("GithubProfileModel's methods return the correct value", () {
    final Map<String, dynamic> profileJson = {
      'login': 'octocat',
      'avatar_url': 'https://example.com/octocat.png',
      'name': 'The Octocat',
      'bio': 'GitHub mascot',
      'public_repos': 8,
      'followers': 4000,
    };
    final List<dynamic> reposJson = [
      {
        'name': 'Hello-World',
        'stargazers_count': 100,
        'description': 'My first repository',
        'language': 'Dart',
      },
    ];

    test('Method fromRemote() should return a GithubProfileModel', () {
      final GithubProfileModel model = GithubProfileModel.fromRemote(
        profileJson: profileJson,
        reposJson: reposJson,
      );

      expect(model, isA<GithubProfileModel>());
      expect(model.username, 'octocat');
      expect(model.avatarUrl, 'https://example.com/octocat.png');
      expect(model.name, 'The Octocat');
      expect(model.bio, 'GitHub mascot');
      expect(model.publicRepos, 8);
      expect(model.followers, 4000);
      expect(model.repos, hasLength(1));
      expect(model.repos.single.name, 'Hello-World');
      expect(model.repos.single.stars, 100);
      expect(model.repos.single.description, 'My first repository');
      expect(model.repos.single.language, 'Dart');
      expect(model.isFavorite, isFalse);
    });

    test(
      'Method fromRemote() should return a GithubProfileModel when name = null',
      () {
        final Map<String, dynamic> jsonWithoutName = {...profileJson}
          ..['name'] = null;

        final GithubProfileModel model = GithubProfileModel.fromRemote(
          profileJson: jsonWithoutName,
          reposJson: reposJson,
        );

        expect(model.name, isNull);
      },
    );

    test(
      'Method fromRemote() should return a GithubProfileModel when bio = null',
      () {
        final Map<String, dynamic> jsonWithoutBio = {...profileJson}
          ..['bio'] = null;

        final GithubProfileModel model = GithubProfileModel.fromRemote(
          profileJson: jsonWithoutBio,
          reposJson: reposJson,
        );

        expect(model.bio, isNull);
      },
    );

    test(
      'Method fromRemote() throws FormatException when profileJson is not a Map',
      () {
        expect(
          () => GithubProfileModel.fromRemote(
            profileJson: 'not a map',
            reposJson: reposJson,
          ),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test(
      'Method fromRemote() throws FormatException when a required profile field is missing',
      () {
        final Map<String, dynamic> missingField = {...profileJson}
          ..remove('login');

        expect(
          () => GithubProfileModel.fromRemote(
            profileJson: missingField,
            reposJson: reposJson,
          ),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test(
      'Method fromRemote() throws FormatException when reposJson is not a List',
      () {
        expect(
          () => GithubProfileModel.fromRemote(
            profileJson: profileJson,
            reposJson: 'not a list',
          ),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test(
      'Method fromRemote() throws FormatException when a repo entry is not a Map',
      () {
        expect(
          () => GithubProfileModel.fromRemote(
            profileJson: profileJson,
            reposJson: ['not a map'],
          ),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test(
      'Method fromRemote() throws FormatException when a repo entry is missing a required field',
      () {
        expect(
          () => GithubProfileModel.fromRemote(
            profileJson: profileJson,
            reposJson: [
              {'name': 'Hello-World'},
            ],
          ),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test('Method fromRow() should return a GithubProfileModel', () {
      final GithubProfileRow row = GithubProfileRow(
        username: 'octocat',
        avatarUrl: 'https://example.com/octocat.png',
        name: 'The Octocat',
        bio: 'GitHub mascot',
        publicRepos: 8,
        followers: 4000,
        reposJson:
            '[{"name":"Hello-World","stars":100,"description":"My first repository","language":"Dart"}]',
        isFavorite: true,
        fetchedAt: DateTime(2026, 1, 1, 12),
      );

      final GithubProfileModel model = GithubProfileModel.fromRow(row);

      expect(model.username, 'octocat');
      expect(model.repos, hasLength(1));
      expect(model.repos.single.name, 'Hello-World');
      expect(model.repos.single.stars, 100);
      expect(model.isFavorite, isTrue);
      expect(model.fetchedAt, DateTime(2026, 1, 1, 12));
    });

    test(
      'Method fromRow() throws FormatException when reposJson is corrupted JSON',
      () {
        final GithubProfileRow row = GithubProfileRow(
          username: 'octocat',
          avatarUrl: 'https://example.com/octocat.png',
          publicRepos: 8,
          followers: 4000,
          reposJson: '{not valid json',
          isFavorite: false,
          fetchedAt: DateTime(2026, 1, 1, 12),
        );

        expect(
          () => GithubProfileModel.fromRow(row),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test(
      'Method fromRow() throws FormatException when reposJson decodes to something other than a List',
      () {
        final GithubProfileRow row = GithubProfileRow(
          username: 'octocat',
          avatarUrl: 'https://example.com/octocat.png',
          publicRepos: 8,
          followers: 4000,
          reposJson: '{"not": "a list"}',
          isFavorite: false,
          fetchedAt: DateTime(2026, 1, 1, 12),
        );

        expect(
          () => GithubProfileModel.fromRow(row),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test('Method toCompanion() should return the correct companion', () {
      final GithubProfileModel model = buildGithubProfileModel(
        username: 'octocat',
        avatarUrl: 'https://example.com/octocat.png',
        name: 'The Octocat',
        bio: 'GitHub mascot',
        publicRepos: 8,
        followers: 4000,
        repos: [buildGithubRepo(name: 'Hello-World', stars: 100)],
        isFavorite: true,
        fetchedAt: DateTime(2026, 1, 1, 12),
      );

      final GithubProfileTableCompanion companion = model.toCompanion();

      expect(companion.username.value, 'octocat');
      expect(companion.avatarUrl.value, 'https://example.com/octocat.png');
      expect(companion.name, const Value('The Octocat'));
      expect(companion.bio, const Value('GitHub mascot'));
      expect(companion.publicRepos.value, 8);
      expect(companion.followers.value, 4000);
      expect(companion.reposJson.value, contains('Hello-World'));
      expect(companion.isFavorite, const Value(true));
      expect(companion.fetchedAt.value, DateTime(2026, 1, 1, 12));
    });
  });
}
