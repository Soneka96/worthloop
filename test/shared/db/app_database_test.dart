// Dart imports:
import 'dart:io';

// Package imports:
import 'package:drift/drift.dart';
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

    test('AppDatabase.forTesting opens with schema version 8', () {
      expect(db.schemaVersion, isA<int>());
      expect(db.schemaVersion, 8);
    });

    test('AppDatabase.forTesting exposes the WorthLoop tables', () async {
      final List<ProductRow> products = await db.select(db.productTable).get();
      final List<ProductSourceRow> sources = await db
          .select(db.productSourceTable)
          .get();
      final List<RefreshSettingsRow> settings = await db
          .select(db.refreshSettingsTable)
          .get();

      expect(products, isEmpty);
      expect(sources, isEmpty);
      expect(settings, isEmpty);

      final List<QueryRow> productColumns = await db
          .customSelect('PRAGMA table_info(product_table)')
          .get();
      final List<QueryRow> sourceColumns = await db
          .customSelect('PRAGMA table_info(product_source_table)')
          .get();
      expect(
        productColumns.map((QueryRow row) => row.data['name']),
        containsAll([
          'previous_best_price_minor_units',
          'previous_best_price_currency_code',
          'best_price_changed_at',
        ]),
      );
      expect(
        sourceColumns.map((QueryRow row) => row.data['name']),
        containsAll([
          'previous_price_minor_units',
          'previous_price_currency_code',
          'price_changed_at',
          'last_refresh_status',
          'last_refresh_at',
        ]),
      );
      final List<QueryRow> refreshSettingsColumns = await db
          .customSelect('PRAGMA table_info(refresh_settings_table)')
          .get();
      expect(
        refreshSettingsColumns.map((QueryRow row) => row.data['name']),
        containsAll(['browser_refresh_enabled', 'price_alerts_enabled']),
      );
    });

    test('AppDatabase persists price-history columns', () async {
      await db
          .into(db.productTable)
          .insert(
            ProductTableCompanion.insert(
              id: 'product-1',
              name: 'Example Product',
              lastUpdatedAt: DateTime(2026, 1, 1, 12),
              previousBestPriceMinorUnits: const Value(59999),
              previousBestPriceCurrencyCode: const Value('EUR'),
              bestPriceChangedAt: Value(DateTime(2026, 1, 2, 12)),
            ),
          );
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceTableCompanion.insert(
              id: 'source-1',
              productId: 'product-1',
              url: 'https://example.com/products/1',
              merchantDomain: 'example.com',
              createdAt: DateTime(2026, 1, 1, 12),
              previousPriceMinorUnits: const Value(59999),
              previousPriceCurrencyCode: const Value('EUR'),
              priceChangedAt: Value(DateTime(2026, 1, 2, 12)),
              lastRefreshStatus: const Value('networkError'),
              lastRefreshAt: Value(DateTime(2026, 1, 3, 12)),
            ),
          );

      final ProductRow product =
          (await db.select(db.productTable).get()).single;
      final ProductSourceRow source =
          (await db.select(db.productSourceTable).get()).single;

      expect(product.previousBestPriceMinorUnits, 59999);
      expect(product.previousBestPriceCurrencyCode, 'EUR');
      expect(product.bestPriceChangedAt, DateTime(2026, 1, 2, 12));
      expect(source.previousPriceMinorUnits, 59999);
      expect(source.previousPriceCurrencyCode, 'EUR');
      expect(source.priceChangedAt, DateTime(2026, 1, 2, 12));
      expect(source.lastRefreshStatus, 'networkError');
      expect(source.lastRefreshAt, DateTime(2026, 1, 3, 12));
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
      final List<ProductSourceRow> sources = await db
          .select(db.productSourceTable)
          .get();
      final List<RefreshSettingsRow> settings = await db
          .select(db.refreshSettingsTable)
          .get();
      expect(products.length, 1);
      expect(products.single.id, 'legacy-product');
      expect(sources, isEmpty);
      expect(settings, isEmpty);
    });

    test('migrates schema version 5 with refresh metadata columns', () async {
      final File file = File(p.join(tempDirectory.path, 'version5.sqlite'));
      final sqlite.Database legacy = sqlite.sqlite3.open(file.path);
      legacy.execute('''
        CREATE TABLE product_table (
          id TEXT NOT NULL PRIMARY KEY,
          name TEXT NOT NULL,
          image_url TEXT,
          last_updated_at INTEGER NOT NULL,
          previous_best_price_minor_units INTEGER,
          previous_best_price_currency_code TEXT,
          best_price_changed_at INTEGER
        )
      ''');
      legacy.execute('''
        CREATE TABLE product_source_table (
          id TEXT NOT NULL PRIMARY KEY,
          product_id TEXT NOT NULL REFERENCES product_table (id) ON DELETE CASCADE,
          url TEXT NOT NULL,
          merchant_domain TEXT NOT NULL,
          minor_units INTEGER,
          currency_code TEXT,
          previous_price_minor_units INTEGER,
          previous_price_currency_code TEXT,
          is_available INTEGER,
          last_checked_at INTEGER,
          price_changed_at INTEGER,
          created_at INTEGER NOT NULL,
          UNIQUE (product_id, url)
        )
      ''');
      legacy.execute('''
        CREATE TABLE refresh_settings_table (
          id INTEGER NOT NULL DEFAULT 1 PRIMARY KEY,
          interval_minutes INTEGER NOT NULL DEFAULT 60,
          CHECK (id = 1)
        )
      ''');
      legacy.execute('PRAGMA user_version = 5');
      legacy.dispose();

      final AppDatabase migrated = AppDatabase.forTesting(NativeDatabase(file));
      final List<QueryRow> columns = await migrated
          .customSelect('PRAGMA table_info(product_source_table)')
          .get();

      expect(
        columns.map((QueryRow row) => row.data['name']),
        containsAll(['last_refresh_status', 'last_refresh_at']),
      );
      final List<QueryRow> refreshSettingsColumns = await migrated
          .customSelect('PRAGMA table_info(refresh_settings_table)')
          .get();
      expect(
        refreshSettingsColumns.map((QueryRow row) => row.data['name']),
        contains('price_alerts_enabled'),
      );
      await migrated.close();
    });
  });
}
