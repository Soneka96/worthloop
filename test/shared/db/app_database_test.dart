// Dart imports:
import 'dart:io';

// Package imports:
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

// Project imports:
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';

class FakePathProviderPlatform extends PathProviderPlatform {
  FakePathProviderPlatform({
    required this.supportPath,
    required this.documentsPath,
  });

  final String supportPath;
  final String documentsPath;

  @override
  Future<String?> getApplicationSupportPath() async => supportPath;

  @override
  Future<String?> getApplicationDocumentsPath() async => documentsPath;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppDatabase — construction', () {
    test('AppDatabase.forTesting opens with schema version 1', () async {
      final AppDatabase db = AppDatabase.forTesting(NativeDatabase.memory());
      expect(db.schemaVersion, 1);
      await db.close();
    });

    test('AppDatabase.forTesting exposes a queryable, empty LogEntryTable', () async {
      final AppDatabase db = AppDatabase.forTesting(NativeDatabase.memory());
      final List<LogEntryRow> rows = await db.select(db.logEntryTable).get();

      expect(rows, isEmpty);
      await db.close();
    });
  });

  group('AppDatabase — connection location', () {
    late Directory supportDirectory;
    late Directory documentsDirectory;

    setUp(() {
      supportDirectory = Directory.systemTemp.createTempSync(
        'app_database_support_test',
      );
      documentsDirectory = Directory.systemTemp.createTempSync(
        'app_database_documents_test',
      );
      PathProviderPlatform.instance = FakePathProviderPlatform(
        supportPath: supportDirectory.path,
        documentsPath: documentsDirectory.path,
      );
    });

    tearDown(() {
      supportDirectory.deleteSync(recursive: true);
      documentsDirectory.deleteSync(recursive: true);
    });

    test(
      'AppDatabase() creates its sqlite file in this app\'s dedicated subfolder under the platform documents directory when no defaultSaveLocation was persisted',
      () async {
        final AppDatabase db = AppDatabase();
        await db.customSelect('SELECT 1').get();

        final File expectedFile = File(
          p.join(
            documentsDirectory.path,
            'Clean Architecture Starter',
            AppDatabase.fileName,
          ),
        );
        expect(await expectedFile.exists(), isTrue);

        await db.close();
      },
    );

    test(
      'AppDatabase() creates its sqlite file at the persisted defaultSaveLocation when one was set',
      () async {
        final Directory customRoot = Directory.systemTemp.createTempSync(
          'app_database_custom_root_test',
        );
        await AppPreferencesStore(
          directory: supportDirectory,
        ).writeDefaultSaveLocation(customRoot.path);

        final AppDatabase db = AppDatabase();
        await db.customSelect('SELECT 1').get();

        final File expectedFile = File(
          p.join(customRoot.path, AppDatabase.fileName),
        );
        expect(await expectedFile.exists(), isTrue);

        await db.close();
        customRoot.deleteSync(recursive: true);
      },
    );
  });
}
