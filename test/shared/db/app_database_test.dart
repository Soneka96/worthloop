// Dart imports:
import 'dart:io';

// Package imports:
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

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

    test('AppDatabase.forTesting opens with schema version 1', () {
      expect(db.schemaVersion, isA<int>());
      expect(db.schemaVersion, 1);
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
}
