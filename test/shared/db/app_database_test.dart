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

    test('AppDatabase.forTesting opens with schema version 3', () {
      expect(db.schemaVersion, isA<int>());
      expect(db.schemaVersion, 3);
    });

    test('AppDatabase.forTesting exposes the WorthLoop tables', () async {
      final List<ProductRow> products = await db.select(db.productTable).get();
      final List<StorePriceRow> prices = await db
          .select(db.storePriceTable)
          .get();
      final List<ProductSourceRow> sources = await db
          .select(db.productSourceTable)
          .get();
      final List<RefreshSettingsRow> settings = await db
          .select(db.refreshSettingsTable)
          .get();

      expect(products, isEmpty);
      expect(prices, isEmpty);
      expect(sources, isEmpty);
      expect(settings, isEmpty);
    });
  });

  group('AppDatabase — connection location', () {
    late AppDatabase db;
    late Directory supportDirectory;
    late PathProviderPlatform previousPathProviderPlatform;

    setUp(() {
      previousPathProviderPlatform = PathProviderPlatform.instance;
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
      PathProviderPlatform.instance = previousPathProviderPlatform;
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
        CREATE TABLE product_table (
          id TEXT NOT NULL PRIMARY KEY,
          name TEXT NOT NULL,
          image_url TEXT,
          last_updated_at INTEGER NOT NULL
        )
      ''');
      legacy.execute('''
        INSERT INTO product_table
          (id, name, image_url, last_updated_at)
        VALUES ('legacy-product', 'Legacy Product', NULL, 1767268800000)
      ''');
      legacy.execute('''
        CREATE TABLE store_price_table (
          product_id TEXT NOT NULL REFERENCES product_table (id) ON DELETE CASCADE,
          store_name TEXT NOT NULL,
          product_url TEXT NOT NULL,
          minor_units INTEGER NOT NULL,
          currency_code TEXT NOT NULL,
          is_available INTEGER NOT NULL,
          last_checked_at INTEGER NOT NULL,
          PRIMARY KEY (product_id, store_name)
        )
      ''');
      legacy.execute('''
        CREATE TABLE refresh_settings_table (
          id INTEGER NOT NULL DEFAULT 1 PRIMARY KEY,
          interval_minutes INTEGER NOT NULL DEFAULT 60,
          CHECK (id = 1)
        )
      ''');
      legacy.execute('PRAGMA user_version = 2');
      legacy.dispose();
      db = AppDatabase.forTesting(NativeDatabase(file));
    });

    tearDown(() async {
      await db.close();
      tempDirectory.deleteSync(recursive: true);
    });

    test('migrates schema version 2 and preserves existing rows', () async {
      final List<ProductRow> products = await db.select(db.productTable).get();
      final List<StorePriceRow> prices = await db
          .select(db.storePriceTable)
          .get();
      final List<ProductSourceRow> sources = await db
          .select(db.productSourceTable)
          .get();
      final List<RefreshSettingsRow> settings = await db
          .select(db.refreshSettingsTable)
          .get();
      expect(products.length, 1);
      expect(products.single.id, 'legacy-product');
      expect(prices, isEmpty);
      expect(sources, isEmpty);
      expect(settings, isEmpty);
    });
  });
}
