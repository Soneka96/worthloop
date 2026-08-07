// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductTableTable extends ProductTable
    with TableInfo<$ProductTableTable, ProductRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastUpdatedAtMeta = const VerificationMeta(
    'lastUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdatedAt =
      GeneratedColumn<DateTime>(
        'last_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _previousBestPriceMinorUnitsMeta =
      const VerificationMeta('previousBestPriceMinorUnits');
  @override
  late final GeneratedColumn<int> previousBestPriceMinorUnits =
      GeneratedColumn<int>(
        'previous_best_price_minor_units',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _previousBestPriceCurrencyCodeMeta =
      const VerificationMeta('previousBestPriceCurrencyCode');
  @override
  late final GeneratedColumn<String> previousBestPriceCurrencyCode =
      GeneratedColumn<String>(
        'previous_best_price_currency_code',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _bestPriceChangedAtMeta =
      const VerificationMeta('bestPriceChangedAt');
  @override
  late final GeneratedColumn<DateTime> bestPriceChangedAt =
      GeneratedColumn<DateTime>(
        'best_price_changed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    imageUrl,
    lastUpdatedAt,
    previousBestPriceMinorUnits,
    previousBestPriceCurrencyCode,
    bestPriceChangedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
        _lastUpdatedAtMeta,
        lastUpdatedAt.isAcceptableOrUnknown(
          data['last_updated_at']!,
          _lastUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedAtMeta);
    }
    if (data.containsKey('previous_best_price_minor_units')) {
      context.handle(
        _previousBestPriceMinorUnitsMeta,
        previousBestPriceMinorUnits.isAcceptableOrUnknown(
          data['previous_best_price_minor_units']!,
          _previousBestPriceMinorUnitsMeta,
        ),
      );
    }
    if (data.containsKey('previous_best_price_currency_code')) {
      context.handle(
        _previousBestPriceCurrencyCodeMeta,
        previousBestPriceCurrencyCode.isAcceptableOrUnknown(
          data['previous_best_price_currency_code']!,
          _previousBestPriceCurrencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('best_price_changed_at')) {
      context.handle(
        _bestPriceChangedAtMeta,
        bestPriceChangedAt.isAcceptableOrUnknown(
          data['best_price_changed_at']!,
          _bestPriceChangedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      lastUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated_at'],
      )!,
      previousBestPriceMinorUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}previous_best_price_minor_units'],
      ),
      previousBestPriceCurrencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}previous_best_price_currency_code'],
      ),
      bestPriceChangedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}best_price_changed_at'],
      ),
    );
  }

  @override
  $ProductTableTable createAlias(String alias) {
    return $ProductTableTable(attachedDatabase, alias);
  }
}

class ProductRow extends DataClass implements Insertable<ProductRow> {
  /// Stable product identifier.
  final String id;

  /// Product display name.
  final String name;

  /// Optional product image URL.
  final String? imageUrl;

  /// When any offer for the product was last updated.
  final DateTime lastUpdatedAt;

  /// Previous best price in the currency's minor unit.
  final int? previousBestPriceMinorUnits;

  /// ISO 4217 currency code for the previous best price.
  final String? previousBestPriceCurrencyCode;

  /// When the product's best price last changed.
  final DateTime? bestPriceChangedAt;
  const ProductRow({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.lastUpdatedAt,
    this.previousBestPriceMinorUnits,
    this.previousBestPriceCurrencyCode,
    this.bestPriceChangedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt);
    if (!nullToAbsent || previousBestPriceMinorUnits != null) {
      map['previous_best_price_minor_units'] = Variable<int>(
        previousBestPriceMinorUnits,
      );
    }
    if (!nullToAbsent || previousBestPriceCurrencyCode != null) {
      map['previous_best_price_currency_code'] = Variable<String>(
        previousBestPriceCurrencyCode,
      );
    }
    if (!nullToAbsent || bestPriceChangedAt != null) {
      map['best_price_changed_at'] = Variable<DateTime>(bestPriceChangedAt);
    }
    return map;
  }

  ProductTableCompanion toCompanion(bool nullToAbsent) {
    return ProductTableCompanion(
      id: Value(id),
      name: Value(name),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      lastUpdatedAt: Value(lastUpdatedAt),
      previousBestPriceMinorUnits:
          previousBestPriceMinorUnits == null && nullToAbsent
          ? const Value.absent()
          : Value(previousBestPriceMinorUnits),
      previousBestPriceCurrencyCode:
          previousBestPriceCurrencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(previousBestPriceCurrencyCode),
      bestPriceChangedAt: bestPriceChangedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(bestPriceChangedAt),
    );
  }

  factory ProductRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      lastUpdatedAt: serializer.fromJson<DateTime>(json['lastUpdatedAt']),
      previousBestPriceMinorUnits: serializer.fromJson<int?>(
        json['previousBestPriceMinorUnits'],
      ),
      previousBestPriceCurrencyCode: serializer.fromJson<String?>(
        json['previousBestPriceCurrencyCode'],
      ),
      bestPriceChangedAt: serializer.fromJson<DateTime?>(
        json['bestPriceChangedAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'lastUpdatedAt': serializer.toJson<DateTime>(lastUpdatedAt),
      'previousBestPriceMinorUnits': serializer.toJson<int?>(
        previousBestPriceMinorUnits,
      ),
      'previousBestPriceCurrencyCode': serializer.toJson<String?>(
        previousBestPriceCurrencyCode,
      ),
      'bestPriceChangedAt': serializer.toJson<DateTime?>(bestPriceChangedAt),
    };
  }

  ProductRow copyWith({
    String? id,
    String? name,
    Value<String?> imageUrl = const Value.absent(),
    DateTime? lastUpdatedAt,
    Value<int?> previousBestPriceMinorUnits = const Value.absent(),
    Value<String?> previousBestPriceCurrencyCode = const Value.absent(),
    Value<DateTime?> bestPriceChangedAt = const Value.absent(),
  }) => ProductRow(
    id: id ?? this.id,
    name: name ?? this.name,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    previousBestPriceMinorUnits: previousBestPriceMinorUnits.present
        ? previousBestPriceMinorUnits.value
        : this.previousBestPriceMinorUnits,
    previousBestPriceCurrencyCode: previousBestPriceCurrencyCode.present
        ? previousBestPriceCurrencyCode.value
        : this.previousBestPriceCurrencyCode,
    bestPriceChangedAt: bestPriceChangedAt.present
        ? bestPriceChangedAt.value
        : this.bestPriceChangedAt,
  );
  ProductRow copyWithCompanion(ProductTableCompanion data) {
    return ProductRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
      previousBestPriceMinorUnits: data.previousBestPriceMinorUnits.present
          ? data.previousBestPriceMinorUnits.value
          : this.previousBestPriceMinorUnits,
      previousBestPriceCurrencyCode: data.previousBestPriceCurrencyCode.present
          ? data.previousBestPriceCurrencyCode.value
          : this.previousBestPriceCurrencyCode,
      bestPriceChangedAt: data.bestPriceChangedAt.present
          ? data.bestPriceChangedAt.value
          : this.bestPriceChangedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('previousBestPriceMinorUnits: $previousBestPriceMinorUnits, ')
          ..write(
            'previousBestPriceCurrencyCode: $previousBestPriceCurrencyCode, ',
          )
          ..write('bestPriceChangedAt: $bestPriceChangedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    imageUrl,
    lastUpdatedAt,
    previousBestPriceMinorUnits,
    previousBestPriceCurrencyCode,
    bestPriceChangedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.imageUrl == this.imageUrl &&
          other.lastUpdatedAt == this.lastUpdatedAt &&
          other.previousBestPriceMinorUnits ==
              this.previousBestPriceMinorUnits &&
          other.previousBestPriceCurrencyCode ==
              this.previousBestPriceCurrencyCode &&
          other.bestPriceChangedAt == this.bestPriceChangedAt);
}

class ProductTableCompanion extends UpdateCompanion<ProductRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> imageUrl;
  final Value<DateTime> lastUpdatedAt;
  final Value<int?> previousBestPriceMinorUnits;
  final Value<String?> previousBestPriceCurrencyCode;
  final Value<DateTime?> bestPriceChangedAt;
  final Value<int> rowid;
  const ProductTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.previousBestPriceMinorUnits = const Value.absent(),
    this.previousBestPriceCurrencyCode = const Value.absent(),
    this.bestPriceChangedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductTableCompanion.insert({
    required String id,
    required String name,
    this.imageUrl = const Value.absent(),
    required DateTime lastUpdatedAt,
    this.previousBestPriceMinorUnits = const Value.absent(),
    this.previousBestPriceCurrencyCode = const Value.absent(),
    this.bestPriceChangedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       lastUpdatedAt = Value(lastUpdatedAt);
  static Insertable<ProductRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? imageUrl,
    Expression<DateTime>? lastUpdatedAt,
    Expression<int>? previousBestPriceMinorUnits,
    Expression<String>? previousBestPriceCurrencyCode,
    Expression<DateTime>? bestPriceChangedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (imageUrl != null) 'image_url': imageUrl,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (previousBestPriceMinorUnits != null)
        'previous_best_price_minor_units': previousBestPriceMinorUnits,
      if (previousBestPriceCurrencyCode != null)
        'previous_best_price_currency_code': previousBestPriceCurrencyCode,
      if (bestPriceChangedAt != null)
        'best_price_changed_at': bestPriceChangedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? imageUrl,
    Value<DateTime>? lastUpdatedAt,
    Value<int?>? previousBestPriceMinorUnits,
    Value<String?>? previousBestPriceCurrencyCode,
    Value<DateTime?>? bestPriceChangedAt,
    Value<int>? rowid,
  }) {
    return ProductTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      previousBestPriceMinorUnits:
          previousBestPriceMinorUnits ?? this.previousBestPriceMinorUnits,
      previousBestPriceCurrencyCode:
          previousBestPriceCurrencyCode ?? this.previousBestPriceCurrencyCode,
      bestPriceChangedAt: bestPriceChangedAt ?? this.bestPriceChangedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt.value);
    }
    if (previousBestPriceMinorUnits.present) {
      map['previous_best_price_minor_units'] = Variable<int>(
        previousBestPriceMinorUnits.value,
      );
    }
    if (previousBestPriceCurrencyCode.present) {
      map['previous_best_price_currency_code'] = Variable<String>(
        previousBestPriceCurrencyCode.value,
      );
    }
    if (bestPriceChangedAt.present) {
      map['best_price_changed_at'] = Variable<DateTime>(
        bestPriceChangedAt.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('previousBestPriceMinorUnits: $previousBestPriceMinorUnits, ')
          ..write(
            'previousBestPriceCurrencyCode: $previousBestPriceCurrencyCode, ',
          )
          ..write('bestPriceChangedAt: $bestPriceChangedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductSourceTableTable extends ProductSourceTable
    with TableInfo<$ProductSourceTableTable, ProductSourceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductSourceTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES product_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _merchantDomainMeta = const VerificationMeta(
    'merchantDomain',
  );
  @override
  late final GeneratedColumn<String> merchantDomain = GeneratedColumn<String>(
    'merchant_domain',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minorUnitsMeta = const VerificationMeta(
    'minorUnits',
  );
  @override
  late final GeneratedColumn<int> minorUnits = GeneratedColumn<int>(
    'minor_units',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _previousPriceMinorUnitsMeta =
      const VerificationMeta('previousPriceMinorUnits');
  @override
  late final GeneratedColumn<int> previousPriceMinorUnits =
      GeneratedColumn<int>(
        'previous_price_minor_units',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _previousPriceCurrencyCodeMeta =
      const VerificationMeta('previousPriceCurrencyCode');
  @override
  late final GeneratedColumn<String> previousPriceCurrencyCode =
      GeneratedColumn<String>(
        'previous_price_currency_code',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isAvailableMeta = const VerificationMeta(
    'isAvailable',
  );
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
    'is_available',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_available" IN (0, 1))',
    ),
  );
  static const VerificationMeta _lastCheckedAtMeta = const VerificationMeta(
    'lastCheckedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastCheckedAt =
      GeneratedColumn<DateTime>(
        'last_checked_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _priceChangedAtMeta = const VerificationMeta(
    'priceChangedAt',
  );
  @override
  late final GeneratedColumn<DateTime> priceChangedAt =
      GeneratedColumn<DateTime>(
        'price_changed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastRefreshStatusMeta = const VerificationMeta(
    'lastRefreshStatus',
  );
  @override
  late final GeneratedColumn<String> lastRefreshStatus =
      GeneratedColumn<String>(
        'last_refresh_status',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastRefreshAtMeta = const VerificationMeta(
    'lastRefreshAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastRefreshAt =
      GeneratedColumn<DateTime>(
        'last_refresh_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    url,
    merchantDomain,
    minorUnits,
    currencyCode,
    previousPriceMinorUnits,
    previousPriceCurrencyCode,
    isAvailable,
    lastCheckedAt,
    priceChangedAt,
    lastRefreshStatus,
    lastRefreshAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_source_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductSourceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('merchant_domain')) {
      context.handle(
        _merchantDomainMeta,
        merchantDomain.isAcceptableOrUnknown(
          data['merchant_domain']!,
          _merchantDomainMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_merchantDomainMeta);
    }
    if (data.containsKey('minor_units')) {
      context.handle(
        _minorUnitsMeta,
        minorUnits.isAcceptableOrUnknown(data['minor_units']!, _minorUnitsMeta),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('previous_price_minor_units')) {
      context.handle(
        _previousPriceMinorUnitsMeta,
        previousPriceMinorUnits.isAcceptableOrUnknown(
          data['previous_price_minor_units']!,
          _previousPriceMinorUnitsMeta,
        ),
      );
    }
    if (data.containsKey('previous_price_currency_code')) {
      context.handle(
        _previousPriceCurrencyCodeMeta,
        previousPriceCurrencyCode.isAcceptableOrUnknown(
          data['previous_price_currency_code']!,
          _previousPriceCurrencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('is_available')) {
      context.handle(
        _isAvailableMeta,
        isAvailable.isAcceptableOrUnknown(
          data['is_available']!,
          _isAvailableMeta,
        ),
      );
    }
    if (data.containsKey('last_checked_at')) {
      context.handle(
        _lastCheckedAtMeta,
        lastCheckedAt.isAcceptableOrUnknown(
          data['last_checked_at']!,
          _lastCheckedAtMeta,
        ),
      );
    }
    if (data.containsKey('price_changed_at')) {
      context.handle(
        _priceChangedAtMeta,
        priceChangedAt.isAcceptableOrUnknown(
          data['price_changed_at']!,
          _priceChangedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_refresh_status')) {
      context.handle(
        _lastRefreshStatusMeta,
        lastRefreshStatus.isAcceptableOrUnknown(
          data['last_refresh_status']!,
          _lastRefreshStatusMeta,
        ),
      );
    }
    if (data.containsKey('last_refresh_at')) {
      context.handle(
        _lastRefreshAtMeta,
        lastRefreshAt.isAcceptableOrUnknown(
          data['last_refresh_at']!,
          _lastRefreshAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {productId, url},
  ];
  @override
  ProductSourceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductSourceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      merchantDomain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_domain'],
      )!,
      minorUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minor_units'],
      ),
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      ),
      previousPriceMinorUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}previous_price_minor_units'],
      ),
      previousPriceCurrencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}previous_price_currency_code'],
      ),
      isAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_available'],
      ),
      lastCheckedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_checked_at'],
      ),
      priceChangedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}price_changed_at'],
      ),
      lastRefreshStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_refresh_status'],
      ),
      lastRefreshAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_refresh_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProductSourceTableTable createAlias(String alias) {
    return $ProductSourceTableTable(attachedDatabase, alias);
  }
}

class ProductSourceRow extends DataClass
    implements Insertable<ProductSourceRow> {
  /// Stable source identifier.
  final String id;

  /// Product this source belongs to.
  final String productId;

  /// Website link supplied for the product.
  final String url;

  /// Lower-case merchant domain extracted from [url].
  final String merchantDomain;

  /// Exact price in the currency's minor unit, once an offer is fetched.
  final int? minorUnits;

  /// ISO 4217 currency code, once an offer is fetched.
  final String? currencyCode;

  /// Previous price in the currency's minor unit, after a price change.
  final int? previousPriceMinorUnits;

  /// ISO 4217 currency code for the previous price.
  final String? previousPriceCurrencyCode;

  /// Whether the merchant currently has the product available, once an
  /// offer is fetched.
  final bool? isAvailable;

  /// When this source's offer was last checked, once fetched.
  final DateTime? lastCheckedAt;

  /// When the source price last changed.
  final DateTime? priceChangedAt;

  /// The outcome of the most recently completed refresh attempt.
  final String? lastRefreshStatus;

  /// When the most recently completed refresh attempt finished.
  final DateTime? lastRefreshAt;

  /// When the source was added.
  final DateTime createdAt;
  const ProductSourceRow({
    required this.id,
    required this.productId,
    required this.url,
    required this.merchantDomain,
    this.minorUnits,
    this.currencyCode,
    this.previousPriceMinorUnits,
    this.previousPriceCurrencyCode,
    this.isAvailable,
    this.lastCheckedAt,
    this.priceChangedAt,
    this.lastRefreshStatus,
    this.lastRefreshAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['url'] = Variable<String>(url);
    map['merchant_domain'] = Variable<String>(merchantDomain);
    if (!nullToAbsent || minorUnits != null) {
      map['minor_units'] = Variable<int>(minorUnits);
    }
    if (!nullToAbsent || currencyCode != null) {
      map['currency_code'] = Variable<String>(currencyCode);
    }
    if (!nullToAbsent || previousPriceMinorUnits != null) {
      map['previous_price_minor_units'] = Variable<int>(
        previousPriceMinorUnits,
      );
    }
    if (!nullToAbsent || previousPriceCurrencyCode != null) {
      map['previous_price_currency_code'] = Variable<String>(
        previousPriceCurrencyCode,
      );
    }
    if (!nullToAbsent || isAvailable != null) {
      map['is_available'] = Variable<bool>(isAvailable);
    }
    if (!nullToAbsent || lastCheckedAt != null) {
      map['last_checked_at'] = Variable<DateTime>(lastCheckedAt);
    }
    if (!nullToAbsent || priceChangedAt != null) {
      map['price_changed_at'] = Variable<DateTime>(priceChangedAt);
    }
    if (!nullToAbsent || lastRefreshStatus != null) {
      map['last_refresh_status'] = Variable<String>(lastRefreshStatus);
    }
    if (!nullToAbsent || lastRefreshAt != null) {
      map['last_refresh_at'] = Variable<DateTime>(lastRefreshAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProductSourceTableCompanion toCompanion(bool nullToAbsent) {
    return ProductSourceTableCompanion(
      id: Value(id),
      productId: Value(productId),
      url: Value(url),
      merchantDomain: Value(merchantDomain),
      minorUnits: minorUnits == null && nullToAbsent
          ? const Value.absent()
          : Value(minorUnits),
      currencyCode: currencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(currencyCode),
      previousPriceMinorUnits: previousPriceMinorUnits == null && nullToAbsent
          ? const Value.absent()
          : Value(previousPriceMinorUnits),
      previousPriceCurrencyCode:
          previousPriceCurrencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(previousPriceCurrencyCode),
      isAvailable: isAvailable == null && nullToAbsent
          ? const Value.absent()
          : Value(isAvailable),
      lastCheckedAt: lastCheckedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCheckedAt),
      priceChangedAt: priceChangedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(priceChangedAt),
      lastRefreshStatus: lastRefreshStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRefreshStatus),
      lastRefreshAt: lastRefreshAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRefreshAt),
      createdAt: Value(createdAt),
    );
  }

  factory ProductSourceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductSourceRow(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      url: serializer.fromJson<String>(json['url']),
      merchantDomain: serializer.fromJson<String>(json['merchantDomain']),
      minorUnits: serializer.fromJson<int?>(json['minorUnits']),
      currencyCode: serializer.fromJson<String?>(json['currencyCode']),
      previousPriceMinorUnits: serializer.fromJson<int?>(
        json['previousPriceMinorUnits'],
      ),
      previousPriceCurrencyCode: serializer.fromJson<String?>(
        json['previousPriceCurrencyCode'],
      ),
      isAvailable: serializer.fromJson<bool?>(json['isAvailable']),
      lastCheckedAt: serializer.fromJson<DateTime?>(json['lastCheckedAt']),
      priceChangedAt: serializer.fromJson<DateTime?>(json['priceChangedAt']),
      lastRefreshStatus: serializer.fromJson<String?>(
        json['lastRefreshStatus'],
      ),
      lastRefreshAt: serializer.fromJson<DateTime?>(json['lastRefreshAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'url': serializer.toJson<String>(url),
      'merchantDomain': serializer.toJson<String>(merchantDomain),
      'minorUnits': serializer.toJson<int?>(minorUnits),
      'currencyCode': serializer.toJson<String?>(currencyCode),
      'previousPriceMinorUnits': serializer.toJson<int?>(
        previousPriceMinorUnits,
      ),
      'previousPriceCurrencyCode': serializer.toJson<String?>(
        previousPriceCurrencyCode,
      ),
      'isAvailable': serializer.toJson<bool?>(isAvailable),
      'lastCheckedAt': serializer.toJson<DateTime?>(lastCheckedAt),
      'priceChangedAt': serializer.toJson<DateTime?>(priceChangedAt),
      'lastRefreshStatus': serializer.toJson<String?>(lastRefreshStatus),
      'lastRefreshAt': serializer.toJson<DateTime?>(lastRefreshAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProductSourceRow copyWith({
    String? id,
    String? productId,
    String? url,
    String? merchantDomain,
    Value<int?> minorUnits = const Value.absent(),
    Value<String?> currencyCode = const Value.absent(),
    Value<int?> previousPriceMinorUnits = const Value.absent(),
    Value<String?> previousPriceCurrencyCode = const Value.absent(),
    Value<bool?> isAvailable = const Value.absent(),
    Value<DateTime?> lastCheckedAt = const Value.absent(),
    Value<DateTime?> priceChangedAt = const Value.absent(),
    Value<String?> lastRefreshStatus = const Value.absent(),
    Value<DateTime?> lastRefreshAt = const Value.absent(),
    DateTime? createdAt,
  }) => ProductSourceRow(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    url: url ?? this.url,
    merchantDomain: merchantDomain ?? this.merchantDomain,
    minorUnits: minorUnits.present ? minorUnits.value : this.minorUnits,
    currencyCode: currencyCode.present ? currencyCode.value : this.currencyCode,
    previousPriceMinorUnits: previousPriceMinorUnits.present
        ? previousPriceMinorUnits.value
        : this.previousPriceMinorUnits,
    previousPriceCurrencyCode: previousPriceCurrencyCode.present
        ? previousPriceCurrencyCode.value
        : this.previousPriceCurrencyCode,
    isAvailable: isAvailable.present ? isAvailable.value : this.isAvailable,
    lastCheckedAt: lastCheckedAt.present
        ? lastCheckedAt.value
        : this.lastCheckedAt,
    priceChangedAt: priceChangedAt.present
        ? priceChangedAt.value
        : this.priceChangedAt,
    lastRefreshStatus: lastRefreshStatus.present
        ? lastRefreshStatus.value
        : this.lastRefreshStatus,
    lastRefreshAt: lastRefreshAt.present
        ? lastRefreshAt.value
        : this.lastRefreshAt,
    createdAt: createdAt ?? this.createdAt,
  );
  ProductSourceRow copyWithCompanion(ProductSourceTableCompanion data) {
    return ProductSourceRow(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      url: data.url.present ? data.url.value : this.url,
      merchantDomain: data.merchantDomain.present
          ? data.merchantDomain.value
          : this.merchantDomain,
      minorUnits: data.minorUnits.present
          ? data.minorUnits.value
          : this.minorUnits,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      previousPriceMinorUnits: data.previousPriceMinorUnits.present
          ? data.previousPriceMinorUnits.value
          : this.previousPriceMinorUnits,
      previousPriceCurrencyCode: data.previousPriceCurrencyCode.present
          ? data.previousPriceCurrencyCode.value
          : this.previousPriceCurrencyCode,
      isAvailable: data.isAvailable.present
          ? data.isAvailable.value
          : this.isAvailable,
      lastCheckedAt: data.lastCheckedAt.present
          ? data.lastCheckedAt.value
          : this.lastCheckedAt,
      priceChangedAt: data.priceChangedAt.present
          ? data.priceChangedAt.value
          : this.priceChangedAt,
      lastRefreshStatus: data.lastRefreshStatus.present
          ? data.lastRefreshStatus.value
          : this.lastRefreshStatus,
      lastRefreshAt: data.lastRefreshAt.present
          ? data.lastRefreshAt.value
          : this.lastRefreshAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductSourceRow(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('url: $url, ')
          ..write('merchantDomain: $merchantDomain, ')
          ..write('minorUnits: $minorUnits, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('previousPriceMinorUnits: $previousPriceMinorUnits, ')
          ..write('previousPriceCurrencyCode: $previousPriceCurrencyCode, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('lastCheckedAt: $lastCheckedAt, ')
          ..write('priceChangedAt: $priceChangedAt, ')
          ..write('lastRefreshStatus: $lastRefreshStatus, ')
          ..write('lastRefreshAt: $lastRefreshAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    url,
    merchantDomain,
    minorUnits,
    currencyCode,
    previousPriceMinorUnits,
    previousPriceCurrencyCode,
    isAvailable,
    lastCheckedAt,
    priceChangedAt,
    lastRefreshStatus,
    lastRefreshAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductSourceRow &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.url == this.url &&
          other.merchantDomain == this.merchantDomain &&
          other.minorUnits == this.minorUnits &&
          other.currencyCode == this.currencyCode &&
          other.previousPriceMinorUnits == this.previousPriceMinorUnits &&
          other.previousPriceCurrencyCode == this.previousPriceCurrencyCode &&
          other.isAvailable == this.isAvailable &&
          other.lastCheckedAt == this.lastCheckedAt &&
          other.priceChangedAt == this.priceChangedAt &&
          other.lastRefreshStatus == this.lastRefreshStatus &&
          other.lastRefreshAt == this.lastRefreshAt &&
          other.createdAt == this.createdAt);
}

class ProductSourceTableCompanion extends UpdateCompanion<ProductSourceRow> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> url;
  final Value<String> merchantDomain;
  final Value<int?> minorUnits;
  final Value<String?> currencyCode;
  final Value<int?> previousPriceMinorUnits;
  final Value<String?> previousPriceCurrencyCode;
  final Value<bool?> isAvailable;
  final Value<DateTime?> lastCheckedAt;
  final Value<DateTime?> priceChangedAt;
  final Value<String?> lastRefreshStatus;
  final Value<DateTime?> lastRefreshAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProductSourceTableCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.url = const Value.absent(),
    this.merchantDomain = const Value.absent(),
    this.minorUnits = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.previousPriceMinorUnits = const Value.absent(),
    this.previousPriceCurrencyCode = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.lastCheckedAt = const Value.absent(),
    this.priceChangedAt = const Value.absent(),
    this.lastRefreshStatus = const Value.absent(),
    this.lastRefreshAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductSourceTableCompanion.insert({
    required String id,
    required String productId,
    required String url,
    required String merchantDomain,
    this.minorUnits = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.previousPriceMinorUnits = const Value.absent(),
    this.previousPriceCurrencyCode = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.lastCheckedAt = const Value.absent(),
    this.priceChangedAt = const Value.absent(),
    this.lastRefreshStatus = const Value.absent(),
    this.lastRefreshAt = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       url = Value(url),
       merchantDomain = Value(merchantDomain),
       createdAt = Value(createdAt);
  static Insertable<ProductSourceRow> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? url,
    Expression<String>? merchantDomain,
    Expression<int>? minorUnits,
    Expression<String>? currencyCode,
    Expression<int>? previousPriceMinorUnits,
    Expression<String>? previousPriceCurrencyCode,
    Expression<bool>? isAvailable,
    Expression<DateTime>? lastCheckedAt,
    Expression<DateTime>? priceChangedAt,
    Expression<String>? lastRefreshStatus,
    Expression<DateTime>? lastRefreshAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (url != null) 'url': url,
      if (merchantDomain != null) 'merchant_domain': merchantDomain,
      if (minorUnits != null) 'minor_units': minorUnits,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (previousPriceMinorUnits != null)
        'previous_price_minor_units': previousPriceMinorUnits,
      if (previousPriceCurrencyCode != null)
        'previous_price_currency_code': previousPriceCurrencyCode,
      if (isAvailable != null) 'is_available': isAvailable,
      if (lastCheckedAt != null) 'last_checked_at': lastCheckedAt,
      if (priceChangedAt != null) 'price_changed_at': priceChangedAt,
      if (lastRefreshStatus != null) 'last_refresh_status': lastRefreshStatus,
      if (lastRefreshAt != null) 'last_refresh_at': lastRefreshAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductSourceTableCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String>? url,
    Value<String>? merchantDomain,
    Value<int?>? minorUnits,
    Value<String?>? currencyCode,
    Value<int?>? previousPriceMinorUnits,
    Value<String?>? previousPriceCurrencyCode,
    Value<bool?>? isAvailable,
    Value<DateTime?>? lastCheckedAt,
    Value<DateTime?>? priceChangedAt,
    Value<String?>? lastRefreshStatus,
    Value<DateTime?>? lastRefreshAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ProductSourceTableCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      url: url ?? this.url,
      merchantDomain: merchantDomain ?? this.merchantDomain,
      minorUnits: minorUnits ?? this.minorUnits,
      currencyCode: currencyCode ?? this.currencyCode,
      previousPriceMinorUnits:
          previousPriceMinorUnits ?? this.previousPriceMinorUnits,
      previousPriceCurrencyCode:
          previousPriceCurrencyCode ?? this.previousPriceCurrencyCode,
      isAvailable: isAvailable ?? this.isAvailable,
      lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
      priceChangedAt: priceChangedAt ?? this.priceChangedAt,
      lastRefreshStatus: lastRefreshStatus ?? this.lastRefreshStatus,
      lastRefreshAt: lastRefreshAt ?? this.lastRefreshAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (merchantDomain.present) {
      map['merchant_domain'] = Variable<String>(merchantDomain.value);
    }
    if (minorUnits.present) {
      map['minor_units'] = Variable<int>(minorUnits.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (previousPriceMinorUnits.present) {
      map['previous_price_minor_units'] = Variable<int>(
        previousPriceMinorUnits.value,
      );
    }
    if (previousPriceCurrencyCode.present) {
      map['previous_price_currency_code'] = Variable<String>(
        previousPriceCurrencyCode.value,
      );
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (lastCheckedAt.present) {
      map['last_checked_at'] = Variable<DateTime>(lastCheckedAt.value);
    }
    if (priceChangedAt.present) {
      map['price_changed_at'] = Variable<DateTime>(priceChangedAt.value);
    }
    if (lastRefreshStatus.present) {
      map['last_refresh_status'] = Variable<String>(lastRefreshStatus.value);
    }
    if (lastRefreshAt.present) {
      map['last_refresh_at'] = Variable<DateTime>(lastRefreshAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductSourceTableCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('url: $url, ')
          ..write('merchantDomain: $merchantDomain, ')
          ..write('minorUnits: $minorUnits, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('previousPriceMinorUnits: $previousPriceMinorUnits, ')
          ..write('previousPriceCurrencyCode: $previousPriceCurrencyCode, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('lastCheckedAt: $lastCheckedAt, ')
          ..write('priceChangedAt: $priceChangedAt, ')
          ..write('lastRefreshStatus: $lastRefreshStatus, ')
          ..write('lastRefreshAt: $lastRefreshAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RefreshSettingsTableTable extends RefreshSettingsTable
    with TableInfo<$RefreshSettingsTableTable, RefreshSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RefreshSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _intervalMinutesMeta = const VerificationMeta(
    'intervalMinutes',
  );
  @override
  late final GeneratedColumn<int> intervalMinutes = GeneratedColumn<int>(
    'interval_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  static const VerificationMeta _browserRefreshEnabledMeta =
      const VerificationMeta('browserRefreshEnabled');
  @override
  late final GeneratedColumn<bool> browserRefreshEnabled =
      GeneratedColumn<bool>(
        'browser_refresh_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("browser_refresh_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _priceAlertsEnabledMeta =
      const VerificationMeta('priceAlertsEnabled');
  @override
  late final GeneratedColumn<bool> priceAlertsEnabled = GeneratedColumn<bool>(
    'price_alerts_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("price_alerts_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    intervalMinutes,
    browserRefreshEnabled,
    priceAlertsEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'refresh_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RefreshSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('interval_minutes')) {
      context.handle(
        _intervalMinutesMeta,
        intervalMinutes.isAcceptableOrUnknown(
          data['interval_minutes']!,
          _intervalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('browser_refresh_enabled')) {
      context.handle(
        _browserRefreshEnabledMeta,
        browserRefreshEnabled.isAcceptableOrUnknown(
          data['browser_refresh_enabled']!,
          _browserRefreshEnabledMeta,
        ),
      );
    }
    if (data.containsKey('price_alerts_enabled')) {
      context.handle(
        _priceAlertsEnabledMeta,
        priceAlertsEnabled.isAcceptableOrUnknown(
          data['price_alerts_enabled']!,
          _priceAlertsEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RefreshSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RefreshSettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      intervalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_minutes'],
      )!,
      browserRefreshEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}browser_refresh_enabled'],
      )!,
      priceAlertsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}price_alerts_enabled'],
      )!,
    );
  }

  @override
  $RefreshSettingsTableTable createAlias(String alias) {
    return $RefreshSettingsTableTable(attachedDatabase, alias);
  }
}

class RefreshSettingsRow extends DataClass
    implements Insertable<RefreshSettingsRow> {
  /// Singleton row identifier.
  final int id;

  /// Preferred refresh interval in minutes.
  final int intervalMinutes;

  /// Whether browser-backed background refresh is enabled.
  final bool browserRefreshEnabled;

  /// Whether product price-drop notifications are enabled.
  final bool priceAlertsEnabled;
  const RefreshSettingsRow({
    required this.id,
    required this.intervalMinutes,
    required this.browserRefreshEnabled,
    required this.priceAlertsEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['interval_minutes'] = Variable<int>(intervalMinutes);
    map['browser_refresh_enabled'] = Variable<bool>(browserRefreshEnabled);
    map['price_alerts_enabled'] = Variable<bool>(priceAlertsEnabled);
    return map;
  }

  RefreshSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return RefreshSettingsTableCompanion(
      id: Value(id),
      intervalMinutes: Value(intervalMinutes),
      browserRefreshEnabled: Value(browserRefreshEnabled),
      priceAlertsEnabled: Value(priceAlertsEnabled),
    );
  }

  factory RefreshSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RefreshSettingsRow(
      id: serializer.fromJson<int>(json['id']),
      intervalMinutes: serializer.fromJson<int>(json['intervalMinutes']),
      browserRefreshEnabled: serializer.fromJson<bool>(
        json['browserRefreshEnabled'],
      ),
      priceAlertsEnabled: serializer.fromJson<bool>(json['priceAlertsEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'intervalMinutes': serializer.toJson<int>(intervalMinutes),
      'browserRefreshEnabled': serializer.toJson<bool>(browserRefreshEnabled),
      'priceAlertsEnabled': serializer.toJson<bool>(priceAlertsEnabled),
    };
  }

  RefreshSettingsRow copyWith({
    int? id,
    int? intervalMinutes,
    bool? browserRefreshEnabled,
    bool? priceAlertsEnabled,
  }) => RefreshSettingsRow(
    id: id ?? this.id,
    intervalMinutes: intervalMinutes ?? this.intervalMinutes,
    browserRefreshEnabled: browserRefreshEnabled ?? this.browserRefreshEnabled,
    priceAlertsEnabled: priceAlertsEnabled ?? this.priceAlertsEnabled,
  );
  RefreshSettingsRow copyWithCompanion(RefreshSettingsTableCompanion data) {
    return RefreshSettingsRow(
      id: data.id.present ? data.id.value : this.id,
      intervalMinutes: data.intervalMinutes.present
          ? data.intervalMinutes.value
          : this.intervalMinutes,
      browserRefreshEnabled: data.browserRefreshEnabled.present
          ? data.browserRefreshEnabled.value
          : this.browserRefreshEnabled,
      priceAlertsEnabled: data.priceAlertsEnabled.present
          ? data.priceAlertsEnabled.value
          : this.priceAlertsEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RefreshSettingsRow(')
          ..write('id: $id, ')
          ..write('intervalMinutes: $intervalMinutes, ')
          ..write('browserRefreshEnabled: $browserRefreshEnabled, ')
          ..write('priceAlertsEnabled: $priceAlertsEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    intervalMinutes,
    browserRefreshEnabled,
    priceAlertsEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RefreshSettingsRow &&
          other.id == this.id &&
          other.intervalMinutes == this.intervalMinutes &&
          other.browserRefreshEnabled == this.browserRefreshEnabled &&
          other.priceAlertsEnabled == this.priceAlertsEnabled);
}

class RefreshSettingsTableCompanion
    extends UpdateCompanion<RefreshSettingsRow> {
  final Value<int> id;
  final Value<int> intervalMinutes;
  final Value<bool> browserRefreshEnabled;
  final Value<bool> priceAlertsEnabled;
  const RefreshSettingsTableCompanion({
    this.id = const Value.absent(),
    this.intervalMinutes = const Value.absent(),
    this.browserRefreshEnabled = const Value.absent(),
    this.priceAlertsEnabled = const Value.absent(),
  });
  RefreshSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.intervalMinutes = const Value.absent(),
    this.browserRefreshEnabled = const Value.absent(),
    this.priceAlertsEnabled = const Value.absent(),
  });
  static Insertable<RefreshSettingsRow> custom({
    Expression<int>? id,
    Expression<int>? intervalMinutes,
    Expression<bool>? browserRefreshEnabled,
    Expression<bool>? priceAlertsEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (intervalMinutes != null) 'interval_minutes': intervalMinutes,
      if (browserRefreshEnabled != null)
        'browser_refresh_enabled': browserRefreshEnabled,
      if (priceAlertsEnabled != null)
        'price_alerts_enabled': priceAlertsEnabled,
    });
  }

  RefreshSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? intervalMinutes,
    Value<bool>? browserRefreshEnabled,
    Value<bool>? priceAlertsEnabled,
  }) {
    return RefreshSettingsTableCompanion(
      id: id ?? this.id,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      browserRefreshEnabled:
          browserRefreshEnabled ?? this.browserRefreshEnabled,
      priceAlertsEnabled: priceAlertsEnabled ?? this.priceAlertsEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (intervalMinutes.present) {
      map['interval_minutes'] = Variable<int>(intervalMinutes.value);
    }
    if (browserRefreshEnabled.present) {
      map['browser_refresh_enabled'] = Variable<bool>(
        browserRefreshEnabled.value,
      );
    }
    if (priceAlertsEnabled.present) {
      map['price_alerts_enabled'] = Variable<bool>(priceAlertsEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RefreshSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('intervalMinutes: $intervalMinutes, ')
          ..write('browserRefreshEnabled: $browserRefreshEnabled, ')
          ..write('priceAlertsEnabled: $priceAlertsEnabled')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductTableTable productTable = $ProductTableTable(this);
  late final $ProductSourceTableTable productSourceTable =
      $ProductSourceTableTable(this);
  late final $RefreshSettingsTableTable refreshSettingsTable =
      $RefreshSettingsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    productTable,
    productSourceTable,
    refreshSettingsTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'product_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('product_source_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProductTableTableCreateCompanionBuilder =
    ProductTableCompanion Function({
      required String id,
      required String name,
      Value<String?> imageUrl,
      required DateTime lastUpdatedAt,
      Value<int?> previousBestPriceMinorUnits,
      Value<String?> previousBestPriceCurrencyCode,
      Value<DateTime?> bestPriceChangedAt,
      Value<int> rowid,
    });
typedef $$ProductTableTableUpdateCompanionBuilder =
    ProductTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> imageUrl,
      Value<DateTime> lastUpdatedAt,
      Value<int?> previousBestPriceMinorUnits,
      Value<String?> previousBestPriceCurrencyCode,
      Value<DateTime?> bestPriceChangedAt,
      Value<int> rowid,
    });

final class $$ProductTableTableReferences
    extends BaseReferences<_$AppDatabase, $ProductTableTable, ProductRow> {
  $$ProductTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductSourceTableTable, List<ProductSourceRow>>
  _productSourceTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.productSourceTable,
        aliasName: $_aliasNameGenerator(
          db.productTable.id,
          db.productSourceTable.productId,
        ),
      );

  $$ProductSourceTableTableProcessedTableManager get productSourceTableRefs {
    final manager = $$ProductSourceTableTableTableManager(
      $_db,
      $_db.productSourceTable,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _productSourceTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProductTableTable> {
  $$ProductTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get previousBestPriceMinorUnits => $composableBuilder(
    column: $table.previousBestPriceMinorUnits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previousBestPriceCurrencyCode => $composableBuilder(
    column: $table.previousBestPriceCurrencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get bestPriceChangedAt => $composableBuilder(
    column: $table.bestPriceChangedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productSourceTableRefs(
    Expression<bool> Function($$ProductSourceTableTableFilterComposer f) f,
  ) {
    final $$ProductSourceTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productSourceTable,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductSourceTableTableFilterComposer(
            $db: $db,
            $table: $db.productSourceTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductTableTable> {
  $$ProductTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get previousBestPriceMinorUnits => $composableBuilder(
    column: $table.previousBestPriceMinorUnits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previousBestPriceCurrencyCode =>
      $composableBuilder(
        column: $table.previousBestPriceCurrencyCode,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<DateTime> get bestPriceChangedAt => $composableBuilder(
    column: $table.bestPriceChangedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductTableTable> {
  $$ProductTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get previousBestPriceMinorUnits => $composableBuilder(
    column: $table.previousBestPriceMinorUnits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get previousBestPriceCurrencyCode =>
      $composableBuilder(
        column: $table.previousBestPriceCurrencyCode,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get bestPriceChangedAt => $composableBuilder(
    column: $table.bestPriceChangedAt,
    builder: (column) => column,
  );

  Expression<T> productSourceTableRefs<T extends Object>(
    Expression<T> Function($$ProductSourceTableTableAnnotationComposer a) f,
  ) {
    final $$ProductSourceTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.productSourceTable,
          getReferencedColumn: (t) => t.productId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProductSourceTableTableAnnotationComposer(
                $db: $db,
                $table: $db.productSourceTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProductTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductTableTable,
          ProductRow,
          $$ProductTableTableFilterComposer,
          $$ProductTableTableOrderingComposer,
          $$ProductTableTableAnnotationComposer,
          $$ProductTableTableCreateCompanionBuilder,
          $$ProductTableTableUpdateCompanionBuilder,
          (ProductRow, $$ProductTableTableReferences),
          ProductRow,
          PrefetchHooks Function({bool productSourceTableRefs})
        > {
  $$ProductTableTableTableManager(_$AppDatabase db, $ProductTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<DateTime> lastUpdatedAt = const Value.absent(),
                Value<int?> previousBestPriceMinorUnits = const Value.absent(),
                Value<String?> previousBestPriceCurrencyCode =
                    const Value.absent(),
                Value<DateTime?> bestPriceChangedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductTableCompanion(
                id: id,
                name: name,
                imageUrl: imageUrl,
                lastUpdatedAt: lastUpdatedAt,
                previousBestPriceMinorUnits: previousBestPriceMinorUnits,
                previousBestPriceCurrencyCode: previousBestPriceCurrencyCode,
                bestPriceChangedAt: bestPriceChangedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> imageUrl = const Value.absent(),
                required DateTime lastUpdatedAt,
                Value<int?> previousBestPriceMinorUnits = const Value.absent(),
                Value<String?> previousBestPriceCurrencyCode =
                    const Value.absent(),
                Value<DateTime?> bestPriceChangedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductTableCompanion.insert(
                id: id,
                name: name,
                imageUrl: imageUrl,
                lastUpdatedAt: lastUpdatedAt,
                previousBestPriceMinorUnits: previousBestPriceMinorUnits,
                previousBestPriceCurrencyCode: previousBestPriceCurrencyCode,
                bestPriceChangedAt: bestPriceChangedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productSourceTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productSourceTableRefs) db.productSourceTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productSourceTableRefs)
                    await $_getPrefetchedData<
                      ProductRow,
                      $ProductTableTable,
                      ProductSourceRow
                    >(
                      currentTable: table,
                      referencedTable: $$ProductTableTableReferences
                          ._productSourceTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProductTableTableReferences(
                            db,
                            table,
                            p0,
                          ).productSourceTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.productId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductTableTable,
      ProductRow,
      $$ProductTableTableFilterComposer,
      $$ProductTableTableOrderingComposer,
      $$ProductTableTableAnnotationComposer,
      $$ProductTableTableCreateCompanionBuilder,
      $$ProductTableTableUpdateCompanionBuilder,
      (ProductRow, $$ProductTableTableReferences),
      ProductRow,
      PrefetchHooks Function({bool productSourceTableRefs})
    >;
typedef $$ProductSourceTableTableCreateCompanionBuilder =
    ProductSourceTableCompanion Function({
      required String id,
      required String productId,
      required String url,
      required String merchantDomain,
      Value<int?> minorUnits,
      Value<String?> currencyCode,
      Value<int?> previousPriceMinorUnits,
      Value<String?> previousPriceCurrencyCode,
      Value<bool?> isAvailable,
      Value<DateTime?> lastCheckedAt,
      Value<DateTime?> priceChangedAt,
      Value<String?> lastRefreshStatus,
      Value<DateTime?> lastRefreshAt,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ProductSourceTableTableUpdateCompanionBuilder =
    ProductSourceTableCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String> url,
      Value<String> merchantDomain,
      Value<int?> minorUnits,
      Value<String?> currencyCode,
      Value<int?> previousPriceMinorUnits,
      Value<String?> previousPriceCurrencyCode,
      Value<bool?> isAvailable,
      Value<DateTime?> lastCheckedAt,
      Value<DateTime?> priceChangedAt,
      Value<String?> lastRefreshStatus,
      Value<DateTime?> lastRefreshAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ProductSourceTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProductSourceTableTable,
          ProductSourceRow
        > {
  $$ProductSourceTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductTableTable _productIdTable(_$AppDatabase db) =>
      db.productTable.createAlias(
        $_aliasNameGenerator(
          db.productSourceTable.productId,
          db.productTable.id,
        ),
      );

  $$ProductTableTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductTableTableTableManager(
      $_db,
      $_db.productTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProductSourceTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProductSourceTableTable> {
  $$ProductSourceTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantDomain => $composableBuilder(
    column: $table.merchantDomain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minorUnits => $composableBuilder(
    column: $table.minorUnits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get previousPriceMinorUnits => $composableBuilder(
    column: $table.previousPriceMinorUnits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previousPriceCurrencyCode => $composableBuilder(
    column: $table.previousPriceCurrencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCheckedAt => $composableBuilder(
    column: $table.lastCheckedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get priceChangedAt => $composableBuilder(
    column: $table.priceChangedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastRefreshStatus => $composableBuilder(
    column: $table.lastRefreshStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastRefreshAt => $composableBuilder(
    column: $table.lastRefreshAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductTableTableFilterComposer get productId {
    final $$ProductTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductTableTableFilterComposer(
            $db: $db,
            $table: $db.productTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductSourceTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductSourceTableTable> {
  $$ProductSourceTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantDomain => $composableBuilder(
    column: $table.merchantDomain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minorUnits => $composableBuilder(
    column: $table.minorUnits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get previousPriceMinorUnits => $composableBuilder(
    column: $table.previousPriceMinorUnits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previousPriceCurrencyCode => $composableBuilder(
    column: $table.previousPriceCurrencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCheckedAt => $composableBuilder(
    column: $table.lastCheckedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get priceChangedAt => $composableBuilder(
    column: $table.priceChangedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastRefreshStatus => $composableBuilder(
    column: $table.lastRefreshStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastRefreshAt => $composableBuilder(
    column: $table.lastRefreshAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductTableTableOrderingComposer get productId {
    final $$ProductTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductTableTableOrderingComposer(
            $db: $db,
            $table: $db.productTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductSourceTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductSourceTableTable> {
  $$ProductSourceTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get merchantDomain => $composableBuilder(
    column: $table.merchantDomain,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minorUnits => $composableBuilder(
    column: $table.minorUnits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get previousPriceMinorUnits => $composableBuilder(
    column: $table.previousPriceMinorUnits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get previousPriceCurrencyCode => $composableBuilder(
    column: $table.previousPriceCurrencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastCheckedAt => $composableBuilder(
    column: $table.lastCheckedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get priceChangedAt => $composableBuilder(
    column: $table.priceChangedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastRefreshStatus => $composableBuilder(
    column: $table.lastRefreshStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastRefreshAt => $composableBuilder(
    column: $table.lastRefreshAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProductTableTableAnnotationComposer get productId {
    final $$ProductTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductTableTableAnnotationComposer(
            $db: $db,
            $table: $db.productTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductSourceTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductSourceTableTable,
          ProductSourceRow,
          $$ProductSourceTableTableFilterComposer,
          $$ProductSourceTableTableOrderingComposer,
          $$ProductSourceTableTableAnnotationComposer,
          $$ProductSourceTableTableCreateCompanionBuilder,
          $$ProductSourceTableTableUpdateCompanionBuilder,
          (ProductSourceRow, $$ProductSourceTableTableReferences),
          ProductSourceRow,
          PrefetchHooks Function({bool productId})
        > {
  $$ProductSourceTableTableTableManager(
    _$AppDatabase db,
    $ProductSourceTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductSourceTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductSourceTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductSourceTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> merchantDomain = const Value.absent(),
                Value<int?> minorUnits = const Value.absent(),
                Value<String?> currencyCode = const Value.absent(),
                Value<int?> previousPriceMinorUnits = const Value.absent(),
                Value<String?> previousPriceCurrencyCode = const Value.absent(),
                Value<bool?> isAvailable = const Value.absent(),
                Value<DateTime?> lastCheckedAt = const Value.absent(),
                Value<DateTime?> priceChangedAt = const Value.absent(),
                Value<String?> lastRefreshStatus = const Value.absent(),
                Value<DateTime?> lastRefreshAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductSourceTableCompanion(
                id: id,
                productId: productId,
                url: url,
                merchantDomain: merchantDomain,
                minorUnits: minorUnits,
                currencyCode: currencyCode,
                previousPriceMinorUnits: previousPriceMinorUnits,
                previousPriceCurrencyCode: previousPriceCurrencyCode,
                isAvailable: isAvailable,
                lastCheckedAt: lastCheckedAt,
                priceChangedAt: priceChangedAt,
                lastRefreshStatus: lastRefreshStatus,
                lastRefreshAt: lastRefreshAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required String url,
                required String merchantDomain,
                Value<int?> minorUnits = const Value.absent(),
                Value<String?> currencyCode = const Value.absent(),
                Value<int?> previousPriceMinorUnits = const Value.absent(),
                Value<String?> previousPriceCurrencyCode = const Value.absent(),
                Value<bool?> isAvailable = const Value.absent(),
                Value<DateTime?> lastCheckedAt = const Value.absent(),
                Value<DateTime?> priceChangedAt = const Value.absent(),
                Value<String?> lastRefreshStatus = const Value.absent(),
                Value<DateTime?> lastRefreshAt = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ProductSourceTableCompanion.insert(
                id: id,
                productId: productId,
                url: url,
                merchantDomain: merchantDomain,
                minorUnits: minorUnits,
                currencyCode: currencyCode,
                previousPriceMinorUnits: previousPriceMinorUnits,
                previousPriceCurrencyCode: previousPriceCurrencyCode,
                isAvailable: isAvailable,
                lastCheckedAt: lastCheckedAt,
                priceChangedAt: priceChangedAt,
                lastRefreshStatus: lastRefreshStatus,
                lastRefreshAt: lastRefreshAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductSourceTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable:
                                    $$ProductSourceTableTableReferences
                                        ._productIdTable(db),
                                referencedColumn:
                                    $$ProductSourceTableTableReferences
                                        ._productIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProductSourceTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductSourceTableTable,
      ProductSourceRow,
      $$ProductSourceTableTableFilterComposer,
      $$ProductSourceTableTableOrderingComposer,
      $$ProductSourceTableTableAnnotationComposer,
      $$ProductSourceTableTableCreateCompanionBuilder,
      $$ProductSourceTableTableUpdateCompanionBuilder,
      (ProductSourceRow, $$ProductSourceTableTableReferences),
      ProductSourceRow,
      PrefetchHooks Function({bool productId})
    >;
typedef $$RefreshSettingsTableTableCreateCompanionBuilder =
    RefreshSettingsTableCompanion Function({
      Value<int> id,
      Value<int> intervalMinutes,
      Value<bool> browserRefreshEnabled,
      Value<bool> priceAlertsEnabled,
    });
typedef $$RefreshSettingsTableTableUpdateCompanionBuilder =
    RefreshSettingsTableCompanion Function({
      Value<int> id,
      Value<int> intervalMinutes,
      Value<bool> browserRefreshEnabled,
      Value<bool> priceAlertsEnabled,
    });

class $$RefreshSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RefreshSettingsTableTable> {
  $$RefreshSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalMinutes => $composableBuilder(
    column: $table.intervalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get browserRefreshEnabled => $composableBuilder(
    column: $table.browserRefreshEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get priceAlertsEnabled => $composableBuilder(
    column: $table.priceAlertsEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RefreshSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RefreshSettingsTableTable> {
  $$RefreshSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalMinutes => $composableBuilder(
    column: $table.intervalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get browserRefreshEnabled => $composableBuilder(
    column: $table.browserRefreshEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get priceAlertsEnabled => $composableBuilder(
    column: $table.priceAlertsEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RefreshSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RefreshSettingsTableTable> {
  $$RefreshSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get intervalMinutes => $composableBuilder(
    column: $table.intervalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get browserRefreshEnabled => $composableBuilder(
    column: $table.browserRefreshEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get priceAlertsEnabled => $composableBuilder(
    column: $table.priceAlertsEnabled,
    builder: (column) => column,
  );
}

class $$RefreshSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RefreshSettingsTableTable,
          RefreshSettingsRow,
          $$RefreshSettingsTableTableFilterComposer,
          $$RefreshSettingsTableTableOrderingComposer,
          $$RefreshSettingsTableTableAnnotationComposer,
          $$RefreshSettingsTableTableCreateCompanionBuilder,
          $$RefreshSettingsTableTableUpdateCompanionBuilder,
          (
            RefreshSettingsRow,
            BaseReferences<
              _$AppDatabase,
              $RefreshSettingsTableTable,
              RefreshSettingsRow
            >,
          ),
          RefreshSettingsRow,
          PrefetchHooks Function()
        > {
  $$RefreshSettingsTableTableTableManager(
    _$AppDatabase db,
    $RefreshSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RefreshSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RefreshSettingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RefreshSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> intervalMinutes = const Value.absent(),
                Value<bool> browserRefreshEnabled = const Value.absent(),
                Value<bool> priceAlertsEnabled = const Value.absent(),
              }) => RefreshSettingsTableCompanion(
                id: id,
                intervalMinutes: intervalMinutes,
                browserRefreshEnabled: browserRefreshEnabled,
                priceAlertsEnabled: priceAlertsEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> intervalMinutes = const Value.absent(),
                Value<bool> browserRefreshEnabled = const Value.absent(),
                Value<bool> priceAlertsEnabled = const Value.absent(),
              }) => RefreshSettingsTableCompanion.insert(
                id: id,
                intervalMinutes: intervalMinutes,
                browserRefreshEnabled: browserRefreshEnabled,
                priceAlertsEnabled: priceAlertsEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RefreshSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RefreshSettingsTableTable,
      RefreshSettingsRow,
      $$RefreshSettingsTableTableFilterComposer,
      $$RefreshSettingsTableTableOrderingComposer,
      $$RefreshSettingsTableTableAnnotationComposer,
      $$RefreshSettingsTableTableCreateCompanionBuilder,
      $$RefreshSettingsTableTableUpdateCompanionBuilder,
      (
        RefreshSettingsRow,
        BaseReferences<
          _$AppDatabase,
          $RefreshSettingsTableTable,
          RefreshSettingsRow
        >,
      ),
      RefreshSettingsRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductTableTableTableManager get productTable =>
      $$ProductTableTableTableManager(_db, _db.productTable);
  $$ProductSourceTableTableTableManager get productSourceTable =>
      $$ProductSourceTableTableTableManager(_db, _db.productSourceTable);
  $$RefreshSettingsTableTableTableManager get refreshSettingsTable =>
      $$RefreshSettingsTableTableTableManager(_db, _db.refreshSettingsTable);
}
