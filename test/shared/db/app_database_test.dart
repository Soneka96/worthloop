// Dart imports:
import 'dart:io';

// Package imports:
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

// Project imports:
import 'package:worth_loop/shared/db/app_database.dart';

class FakePathProviderPlatform extends PathProviderPlatform {
  final String supportPath;

  FakePathProviderPlatform(this.supportPath);

  @override
  Future<String?> getApplicationSupportPath() async => supportPath;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppDatabase — construction', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test('AppDatabase.forTesting opens with schema version 2', () {
      expect(db.schemaVersion, isA<int>());
      expect(db.schemaVersion, 2);
    });

    test(
      'AppDatabase.forTesting exposes a queryable, empty GithubProfileTable',
      () async {
        final List<GithubProfileRow> rows = await db
            .select(db.githubProfileTable)
            .get();

        expect(rows, isA<List<GithubProfileRow>>());
        expect(rows, isEmpty);
      },
    );

    test('AppDatabase.forTesting exposes the WorthLoop tables', () async {
      final List<ProductRow> products = await db.select(db.productTable).get();
      final List<StorePriceRow> prices = await db
          .select(db.storePriceTable)
          .get();
      final List<RefreshSettingsRow> settings = await db
          .select(db.refreshSettingsTable)
          .get();

      expect(products, isEmpty);
      expect(prices, isEmpty);
      expect(settings, isEmpty);
    });
  });

  group('AppDatabase — connection location', () {
    late AppDatabase db;
    late Directory supportDirectory;

    setUp(() {
      supportDirectory = Directory.systemTemp.createTempSync(
        'worth_loop_database_test',
      );
      PathProviderPlatform.instance = FakePathProviderPlatform(
        supportDirectory.path,
      );
      db = AppDatabase();
    });

    tearDown(() async {
      await db.close();
      supportDirectory.deleteSync(recursive: true);
    });

    test(
      'AppDatabase creates app.sqlite in the application support directory',
      () async {
        await db.customSelect('SELECT 1').get();

        final File expectedFile = File(
          p.join(supportDirectory.path, AppDatabase.fileName),
        );
        final bool fileExists = await expectedFile.exists();
        expect(fileExists, isA<bool>());
        expect(fileExists, isTrue);
      },
    );
  });

  group('AppDatabase — migration', () {
    late AppDatabase db;
    late Directory tempDirectory;

    setUp(() {
      tempDirectory = Directory.systemTemp.createTempSync(
        'worth_loop_migration_test',
      );
      final File file = File(p.join(tempDirectory.path, 'legacy.sqlite'));
      final sqlite.Database legacy = sqlite.sqlite3.open(file.path);
      legacy.execute('''
        CREATE TABLE github_profile_table (
          username TEXT NOT NULL PRIMARY KEY,
          avatar_url TEXT NOT NULL,
          name TEXT NULL,
          bio TEXT NULL,
          public_repos INTEGER NOT NULL,
          followers INTEGER NOT NULL,
          repos_json TEXT NOT NULL,
          is_favorite INTEGER NOT NULL DEFAULT 0,
          fetched_at INTEGER NOT NULL
        )
      ''');
      legacy.execute('''
        INSERT INTO github_profile_table (
          username, avatar_url, public_repos, followers, repos_json, fetched_at
        ) VALUES ('octocat', 'https://example.com/avatar.png', 1, 2, '[]', 1)
      ''');
      legacy.execute('PRAGMA user_version = 1');
      legacy.dispose();
      db = AppDatabase.forTesting(NativeDatabase(file));
    });

    tearDown(() async {
      await db.close();
      tempDirectory.deleteSync(recursive: true);
    });

    test('migrates schema version 1 and preserves existing rows', () async {
      final List<ProductRow> products = await db.select(db.productTable).get();
      final List<StorePriceRow> prices = await db
          .select(db.storePriceTable)
          .get();
      final List<RefreshSettingsRow> settings = await db
          .select(db.refreshSettingsTable)
          .get();
      final GithubProfileRow profile = await db
          .select(db.githubProfileTable)
          .getSingle();

      expect(products, isEmpty);
      expect(prices, isEmpty);
      expect(settings, isEmpty);
      expect(profile.username, isA<String>());
      expect(profile.username, 'octocat');
    });
  });
}
