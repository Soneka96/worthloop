// Package imports:
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/db/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async => db.close());

  group('GithubProfileTable — round trip', () {
    test(
      'GithubProfileTable stores and reads back a cached profile row',
      () async {
        await db
            .into(db.githubProfileTable)
            .insert(
              GithubProfileTableCompanion.insert(
                username: 'octocat',
                avatarUrl: 'https://example.com/octocat.png',
                name: const Value('The Octocat'),
                bio: const Value('GitHub mascot'),
                publicRepos: 8,
                followers: 4000,
                reposJson: '[]',
                isFavorite: const Value(true),
                fetchedAt: DateTime(2026, 1, 1, 12),
              ),
            );

        final GithubProfileRow row =
            await (db.select(db.githubProfileTable)
                  ..where((t) => t.username.equals('octocat')))
                .getSingle();

        expect(row.username, 'octocat');
        expect(row.avatarUrl, 'https://example.com/octocat.png');
        expect(row.name, 'The Octocat');
        expect(row.bio, 'GitHub mascot');
        expect(row.publicRepos, 8);
        expect(row.followers, 4000);
        expect(row.reposJson, '[]');
        expect(row.isFavorite, isTrue);
        expect(row.fetchedAt, DateTime(2026, 1, 1, 12));
      },
    );

    test(
      'GithubProfileTable stores and reads back null name/bio columns',
      () async {
        await db
            .into(db.githubProfileTable)
            .insert(
              GithubProfileTableCompanion.insert(
                username: 'octocat',
                avatarUrl: 'https://example.com/octocat.png',
                publicRepos: 8,
                followers: 4000,
                reposJson: '[]',
                fetchedAt: DateTime(2026, 1, 1, 12),
              ),
            );

        final GithubProfileRow row =
            await (db.select(db.githubProfileTable)
                  ..where((t) => t.username.equals('octocat')))
                .getSingle();

        expect(row.name, isNull);
        expect(row.bio, isNull);
        expect(row.isFavorite, isFalse);
      },
    );
  });
}
