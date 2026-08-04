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
  @override
  List<GeneratedColumn> get $columns => [id, name, imageUrl, lastUpdatedAt];
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
  const ProductRow({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.lastUpdatedAt,
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
    };
  }

  ProductRow copyWith({
    String? id,
    String? name,
    Value<String?> imageUrl = const Value.absent(),
    DateTime? lastUpdatedAt,
  }) => ProductRow(
    id: id ?? this.id,
    name: name ?? this.name,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
  );
  ProductRow copyWithCompanion(ProductTableCompanion data) {
    return ProductRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, imageUrl, lastUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.imageUrl == this.imageUrl &&
          other.lastUpdatedAt == this.lastUpdatedAt);
}

class ProductTableCompanion extends UpdateCompanion<ProductRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> imageUrl;
  final Value<DateTime> lastUpdatedAt;
  final Value<int> rowid;
  const ProductTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductTableCompanion.insert({
    required String id,
    required String name,
    this.imageUrl = const Value.absent(),
    required DateTime lastUpdatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       lastUpdatedAt = Value(lastUpdatedAt);
  static Insertable<ProductRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? imageUrl,
    Expression<DateTime>? lastUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (imageUrl != null) 'image_url': imageUrl,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? imageUrl,
    Value<DateTime>? lastUpdatedAt,
    Value<int>? rowid,
  }) {
    return ProductTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
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

  /// When the source was added.
  final DateTime createdAt;
  const ProductSourceRow({
    required this.id,
    required this.productId,
    required this.url,
    required this.merchantDomain,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['url'] = Variable<String>(url);
    map['merchant_domain'] = Variable<String>(merchantDomain);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProductSourceTableCompanion toCompanion(bool nullToAbsent) {
    return ProductSourceTableCompanion(
      id: Value(id),
      productId: Value(productId),
      url: Value(url),
      merchantDomain: Value(merchantDomain),
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
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProductSourceRow copyWith({
    String? id,
    String? productId,
    String? url,
    String? merchantDomain,
    DateTime? createdAt,
  }) => ProductSourceRow(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    url: url ?? this.url,
    merchantDomain: merchantDomain ?? this.merchantDomain,
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
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, url, merchantDomain, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductSourceRow &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.url == this.url &&
          other.merchantDomain == this.merchantDomain &&
          other.createdAt == this.createdAt);
}

class ProductSourceTableCompanion extends UpdateCompanion<ProductSourceRow> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> url;
  final Value<String> merchantDomain;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProductSourceTableCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.url = const Value.absent(),
    this.merchantDomain = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductSourceTableCompanion.insert({
    required String id,
    required String productId,
    required String url,
    required String merchantDomain,
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
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (url != null) 'url': url,
      if (merchantDomain != null) 'merchant_domain': merchantDomain,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductSourceTableCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String>? url,
    Value<String>? merchantDomain,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ProductSourceTableCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      url: url ?? this.url,
      merchantDomain: merchantDomain ?? this.merchantDomain,
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
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StorePriceTableTable extends StorePriceTable
    with TableInfo<$StorePriceTableTable, StorePriceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StorePriceTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _storeNameMeta = const VerificationMeta(
    'storeName',
  );
  @override
  late final GeneratedColumn<String> storeName = GeneratedColumn<String>(
    'store_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productUrlMeta = const VerificationMeta(
    'productUrl',
  );
  @override
  late final GeneratedColumn<String> productUrl = GeneratedColumn<String>(
    'product_url',
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
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAvailableMeta = const VerificationMeta(
    'isAvailable',
  );
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
    'is_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
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
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    productId,
    storeName,
    productUrl,
    minorUnits,
    currencyCode,
    isAvailable,
    lastCheckedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'store_price_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<StorePriceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('store_name')) {
      context.handle(
        _storeNameMeta,
        storeName.isAcceptableOrUnknown(data['store_name']!, _storeNameMeta),
      );
    } else if (isInserting) {
      context.missing(_storeNameMeta);
    }
    if (data.containsKey('product_url')) {
      context.handle(
        _productUrlMeta,
        productUrl.isAcceptableOrUnknown(data['product_url']!, _productUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_productUrlMeta);
    }
    if (data.containsKey('minor_units')) {
      context.handle(
        _minorUnitsMeta,
        minorUnits.isAcceptableOrUnknown(data['minor_units']!, _minorUnitsMeta),
      );
    } else if (isInserting) {
      context.missing(_minorUnitsMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('is_available')) {
      context.handle(
        _isAvailableMeta,
        isAvailable.isAcceptableOrUnknown(
          data['is_available']!,
          _isAvailableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isAvailableMeta);
    }
    if (data.containsKey('last_checked_at')) {
      context.handle(
        _lastCheckedAtMeta,
        lastCheckedAt.isAcceptableOrUnknown(
          data['last_checked_at']!,
          _lastCheckedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastCheckedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productId, storeName};
  @override
  StorePriceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StorePriceRow(
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      storeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_name'],
      )!,
      productUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_url'],
      )!,
      minorUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minor_units'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      isAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_available'],
      )!,
      lastCheckedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_checked_at'],
      )!,
    );
  }

  @override
  $StorePriceTableTable createAlias(String alias) {
    return $StorePriceTableTable(attachedDatabase, alias);
  }
}

class StorePriceRow extends DataClass implements Insertable<StorePriceRow> {
  /// Product this offer belongs to.
  final String productId;

  /// Merchant display name.
  final String storeName;

  /// Merchant product-page URL.
  final String productUrl;

  /// Exact price in the currency's minor unit.
  final int minorUnits;

  /// ISO 4217 currency code.
  final String currencyCode;

  /// Whether the product is currently available.
  final bool isAvailable;

  /// When this offer was last checked.
  final DateTime lastCheckedAt;
  const StorePriceRow({
    required this.productId,
    required this.storeName,
    required this.productUrl,
    required this.minorUnits,
    required this.currencyCode,
    required this.isAvailable,
    required this.lastCheckedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_id'] = Variable<String>(productId);
    map['store_name'] = Variable<String>(storeName);
    map['product_url'] = Variable<String>(productUrl);
    map['minor_units'] = Variable<int>(minorUnits);
    map['currency_code'] = Variable<String>(currencyCode);
    map['is_available'] = Variable<bool>(isAvailable);
    map['last_checked_at'] = Variable<DateTime>(lastCheckedAt);
    return map;
  }

  StorePriceTableCompanion toCompanion(bool nullToAbsent) {
    return StorePriceTableCompanion(
      productId: Value(productId),
      storeName: Value(storeName),
      productUrl: Value(productUrl),
      minorUnits: Value(minorUnits),
      currencyCode: Value(currencyCode),
      isAvailable: Value(isAvailable),
      lastCheckedAt: Value(lastCheckedAt),
    );
  }

  factory StorePriceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StorePriceRow(
      productId: serializer.fromJson<String>(json['productId']),
      storeName: serializer.fromJson<String>(json['storeName']),
      productUrl: serializer.fromJson<String>(json['productUrl']),
      minorUnits: serializer.fromJson<int>(json['minorUnits']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      lastCheckedAt: serializer.fromJson<DateTime>(json['lastCheckedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<String>(productId),
      'storeName': serializer.toJson<String>(storeName),
      'productUrl': serializer.toJson<String>(productUrl),
      'minorUnits': serializer.toJson<int>(minorUnits),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'lastCheckedAt': serializer.toJson<DateTime>(lastCheckedAt),
    };
  }

  StorePriceRow copyWith({
    String? productId,
    String? storeName,
    String? productUrl,
    int? minorUnits,
    String? currencyCode,
    bool? isAvailable,
    DateTime? lastCheckedAt,
  }) => StorePriceRow(
    productId: productId ?? this.productId,
    storeName: storeName ?? this.storeName,
    productUrl: productUrl ?? this.productUrl,
    minorUnits: minorUnits ?? this.minorUnits,
    currencyCode: currencyCode ?? this.currencyCode,
    isAvailable: isAvailable ?? this.isAvailable,
    lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
  );
  StorePriceRow copyWithCompanion(StorePriceTableCompanion data) {
    return StorePriceRow(
      productId: data.productId.present ? data.productId.value : this.productId,
      storeName: data.storeName.present ? data.storeName.value : this.storeName,
      productUrl: data.productUrl.present
          ? data.productUrl.value
          : this.productUrl,
      minorUnits: data.minorUnits.present
          ? data.minorUnits.value
          : this.minorUnits,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      isAvailable: data.isAvailable.present
          ? data.isAvailable.value
          : this.isAvailable,
      lastCheckedAt: data.lastCheckedAt.present
          ? data.lastCheckedAt.value
          : this.lastCheckedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StorePriceRow(')
          ..write('productId: $productId, ')
          ..write('storeName: $storeName, ')
          ..write('productUrl: $productUrl, ')
          ..write('minorUnits: $minorUnits, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('lastCheckedAt: $lastCheckedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    productId,
    storeName,
    productUrl,
    minorUnits,
    currencyCode,
    isAvailable,
    lastCheckedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StorePriceRow &&
          other.productId == this.productId &&
          other.storeName == this.storeName &&
          other.productUrl == this.productUrl &&
          other.minorUnits == this.minorUnits &&
          other.currencyCode == this.currencyCode &&
          other.isAvailable == this.isAvailable &&
          other.lastCheckedAt == this.lastCheckedAt);
}

class StorePriceTableCompanion extends UpdateCompanion<StorePriceRow> {
  final Value<String> productId;
  final Value<String> storeName;
  final Value<String> productUrl;
  final Value<int> minorUnits;
  final Value<String> currencyCode;
  final Value<bool> isAvailable;
  final Value<DateTime> lastCheckedAt;
  final Value<int> rowid;
  const StorePriceTableCompanion({
    this.productId = const Value.absent(),
    this.storeName = const Value.absent(),
    this.productUrl = const Value.absent(),
    this.minorUnits = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.lastCheckedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StorePriceTableCompanion.insert({
    required String productId,
    required String storeName,
    required String productUrl,
    required int minorUnits,
    required String currencyCode,
    required bool isAvailable,
    required DateTime lastCheckedAt,
    this.rowid = const Value.absent(),
  }) : productId = Value(productId),
       storeName = Value(storeName),
       productUrl = Value(productUrl),
       minorUnits = Value(minorUnits),
       currencyCode = Value(currencyCode),
       isAvailable = Value(isAvailable),
       lastCheckedAt = Value(lastCheckedAt);
  static Insertable<StorePriceRow> custom({
    Expression<String>? productId,
    Expression<String>? storeName,
    Expression<String>? productUrl,
    Expression<int>? minorUnits,
    Expression<String>? currencyCode,
    Expression<bool>? isAvailable,
    Expression<DateTime>? lastCheckedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
      if (storeName != null) 'store_name': storeName,
      if (productUrl != null) 'product_url': productUrl,
      if (minorUnits != null) 'minor_units': minorUnits,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (isAvailable != null) 'is_available': isAvailable,
      if (lastCheckedAt != null) 'last_checked_at': lastCheckedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StorePriceTableCompanion copyWith({
    Value<String>? productId,
    Value<String>? storeName,
    Value<String>? productUrl,
    Value<int>? minorUnits,
    Value<String>? currencyCode,
    Value<bool>? isAvailable,
    Value<DateTime>? lastCheckedAt,
    Value<int>? rowid,
  }) {
    return StorePriceTableCompanion(
      productId: productId ?? this.productId,
      storeName: storeName ?? this.storeName,
      productUrl: productUrl ?? this.productUrl,
      minorUnits: minorUnits ?? this.minorUnits,
      currencyCode: currencyCode ?? this.currencyCode,
      isAvailable: isAvailable ?? this.isAvailable,
      lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (storeName.present) {
      map['store_name'] = Variable<String>(storeName.value);
    }
    if (productUrl.present) {
      map['product_url'] = Variable<String>(productUrl.value);
    }
    if (minorUnits.present) {
      map['minor_units'] = Variable<int>(minorUnits.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (lastCheckedAt.present) {
      map['last_checked_at'] = Variable<DateTime>(lastCheckedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StorePriceTableCompanion(')
          ..write('productId: $productId, ')
          ..write('storeName: $storeName, ')
          ..write('productUrl: $productUrl, ')
          ..write('minorUnits: $minorUnits, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('lastCheckedAt: $lastCheckedAt, ')
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
  @override
  List<GeneratedColumn> get $columns => [id, intervalMinutes];
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
  const RefreshSettingsRow({required this.id, required this.intervalMinutes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['interval_minutes'] = Variable<int>(intervalMinutes);
    return map;
  }

  RefreshSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return RefreshSettingsTableCompanion(
      id: Value(id),
      intervalMinutes: Value(intervalMinutes),
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
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'intervalMinutes': serializer.toJson<int>(intervalMinutes),
    };
  }

  RefreshSettingsRow copyWith({int? id, int? intervalMinutes}) =>
      RefreshSettingsRow(
        id: id ?? this.id,
        intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      );
  RefreshSettingsRow copyWithCompanion(RefreshSettingsTableCompanion data) {
    return RefreshSettingsRow(
      id: data.id.present ? data.id.value : this.id,
      intervalMinutes: data.intervalMinutes.present
          ? data.intervalMinutes.value
          : this.intervalMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RefreshSettingsRow(')
          ..write('id: $id, ')
          ..write('intervalMinutes: $intervalMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, intervalMinutes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RefreshSettingsRow &&
          other.id == this.id &&
          other.intervalMinutes == this.intervalMinutes);
}

class RefreshSettingsTableCompanion
    extends UpdateCompanion<RefreshSettingsRow> {
  final Value<int> id;
  final Value<int> intervalMinutes;
  const RefreshSettingsTableCompanion({
    this.id = const Value.absent(),
    this.intervalMinutes = const Value.absent(),
  });
  RefreshSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.intervalMinutes = const Value.absent(),
  });
  static Insertable<RefreshSettingsRow> custom({
    Expression<int>? id,
    Expression<int>? intervalMinutes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (intervalMinutes != null) 'interval_minutes': intervalMinutes,
    });
  }

  RefreshSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? intervalMinutes,
  }) {
    return RefreshSettingsTableCompanion(
      id: id ?? this.id,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RefreshSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('intervalMinutes: $intervalMinutes')
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
  late final $StorePriceTableTable storePriceTable = $StorePriceTableTable(
    this,
  );
  late final $RefreshSettingsTableTable refreshSettingsTable =
      $RefreshSettingsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    productTable,
    productSourceTable,
    storePriceTable,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'product_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('store_price_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProductTableTableCreateCompanionBuilder =
    ProductTableCompanion Function({
      required String id,
      required String name,
      Value<String?> imageUrl,
      required DateTime lastUpdatedAt,
      Value<int> rowid,
    });
typedef $$ProductTableTableUpdateCompanionBuilder =
    ProductTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> imageUrl,
      Value<DateTime> lastUpdatedAt,
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

  static MultiTypedResultKey<$StorePriceTableTable, List<StorePriceRow>>
  _storePriceTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.storePriceTable,
    aliasName: $_aliasNameGenerator(
      db.productTable.id,
      db.storePriceTable.productId,
    ),
  );

  $$StorePriceTableTableProcessedTableManager get storePriceTableRefs {
    final manager = $$StorePriceTableTableTableManager(
      $_db,
      $_db.storePriceTable,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storePriceTableRefsTable($_db),
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

  Expression<bool> storePriceTableRefs(
    Expression<bool> Function($$StorePriceTableTableFilterComposer f) f,
  ) {
    final $$StorePriceTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storePriceTable,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StorePriceTableTableFilterComposer(
            $db: $db,
            $table: $db.storePriceTable,
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

  Expression<T> storePriceTableRefs<T extends Object>(
    Expression<T> Function($$StorePriceTableTableAnnotationComposer a) f,
  ) {
    final $$StorePriceTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storePriceTable,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StorePriceTableTableAnnotationComposer(
            $db: $db,
            $table: $db.storePriceTable,
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
          PrefetchHooks Function({
            bool productSourceTableRefs,
            bool storePriceTableRefs,
          })
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
                Value<int> rowid = const Value.absent(),
              }) => ProductTableCompanion(
                id: id,
                name: name,
                imageUrl: imageUrl,
                lastUpdatedAt: lastUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> imageUrl = const Value.absent(),
                required DateTime lastUpdatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProductTableCompanion.insert(
                id: id,
                name: name,
                imageUrl: imageUrl,
                lastUpdatedAt: lastUpdatedAt,
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
          prefetchHooksCallback:
              ({productSourceTableRefs = false, storePriceTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (productSourceTableRefs) db.productSourceTable,
                    if (storePriceTableRefs) db.storePriceTable,
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
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (storePriceTableRefs)
                        await $_getPrefetchedData<
                          ProductRow,
                          $ProductTableTable,
                          StorePriceRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProductTableTableReferences
                              ._storePriceTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductTableTableReferences(
                                db,
                                table,
                                p0,
                              ).storePriceTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
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
      PrefetchHooks Function({
        bool productSourceTableRefs,
        bool storePriceTableRefs,
      })
    >;
typedef $$ProductSourceTableTableCreateCompanionBuilder =
    ProductSourceTableCompanion Function({
      required String id,
      required String productId,
      required String url,
      required String merchantDomain,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ProductSourceTableTableUpdateCompanionBuilder =
    ProductSourceTableCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String> url,
      Value<String> merchantDomain,
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
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductSourceTableCompanion(
                id: id,
                productId: productId,
                url: url,
                merchantDomain: merchantDomain,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required String url,
                required String merchantDomain,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ProductSourceTableCompanion.insert(
                id: id,
                productId: productId,
                url: url,
                merchantDomain: merchantDomain,
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
typedef $$StorePriceTableTableCreateCompanionBuilder =
    StorePriceTableCompanion Function({
      required String productId,
      required String storeName,
      required String productUrl,
      required int minorUnits,
      required String currencyCode,
      required bool isAvailable,
      required DateTime lastCheckedAt,
      Value<int> rowid,
    });
typedef $$StorePriceTableTableUpdateCompanionBuilder =
    StorePriceTableCompanion Function({
      Value<String> productId,
      Value<String> storeName,
      Value<String> productUrl,
      Value<int> minorUnits,
      Value<String> currencyCode,
      Value<bool> isAvailable,
      Value<DateTime> lastCheckedAt,
      Value<int> rowid,
    });

final class $$StorePriceTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $StorePriceTableTable, StorePriceRow> {
  $$StorePriceTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductTableTable _productIdTable(_$AppDatabase db) =>
      db.productTable.createAlias(
        $_aliasNameGenerator(db.storePriceTable.productId, db.productTable.id),
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

class $$StorePriceTableTableFilterComposer
    extends Composer<_$AppDatabase, $StorePriceTableTable> {
  $$StorePriceTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productUrl => $composableBuilder(
    column: $table.productUrl,
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

  ColumnFilters<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCheckedAt => $composableBuilder(
    column: $table.lastCheckedAt,
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

class $$StorePriceTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StorePriceTableTable> {
  $$StorePriceTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productUrl => $composableBuilder(
    column: $table.productUrl,
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

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCheckedAt => $composableBuilder(
    column: $table.lastCheckedAt,
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

class $$StorePriceTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StorePriceTableTable> {
  $$StorePriceTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get storeName =>
      $composableBuilder(column: $table.storeName, builder: (column) => column);

  GeneratedColumn<String> get productUrl => $composableBuilder(
    column: $table.productUrl,
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

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastCheckedAt => $composableBuilder(
    column: $table.lastCheckedAt,
    builder: (column) => column,
  );

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

class $$StorePriceTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StorePriceTableTable,
          StorePriceRow,
          $$StorePriceTableTableFilterComposer,
          $$StorePriceTableTableOrderingComposer,
          $$StorePriceTableTableAnnotationComposer,
          $$StorePriceTableTableCreateCompanionBuilder,
          $$StorePriceTableTableUpdateCompanionBuilder,
          (StorePriceRow, $$StorePriceTableTableReferences),
          StorePriceRow,
          PrefetchHooks Function({bool productId})
        > {
  $$StorePriceTableTableTableManager(
    _$AppDatabase db,
    $StorePriceTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StorePriceTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StorePriceTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StorePriceTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> productId = const Value.absent(),
                Value<String> storeName = const Value.absent(),
                Value<String> productUrl = const Value.absent(),
                Value<int> minorUnits = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<bool> isAvailable = const Value.absent(),
                Value<DateTime> lastCheckedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StorePriceTableCompanion(
                productId: productId,
                storeName: storeName,
                productUrl: productUrl,
                minorUnits: minorUnits,
                currencyCode: currencyCode,
                isAvailable: isAvailable,
                lastCheckedAt: lastCheckedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String productId,
                required String storeName,
                required String productUrl,
                required int minorUnits,
                required String currencyCode,
                required bool isAvailable,
                required DateTime lastCheckedAt,
                Value<int> rowid = const Value.absent(),
              }) => StorePriceTableCompanion.insert(
                productId: productId,
                storeName: storeName,
                productUrl: productUrl,
                minorUnits: minorUnits,
                currencyCode: currencyCode,
                isAvailable: isAvailable,
                lastCheckedAt: lastCheckedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StorePriceTableTableReferences(db, table, e),
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
                                    $$StorePriceTableTableReferences
                                        ._productIdTable(db),
                                referencedColumn:
                                    $$StorePriceTableTableReferences
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

typedef $$StorePriceTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StorePriceTableTable,
      StorePriceRow,
      $$StorePriceTableTableFilterComposer,
      $$StorePriceTableTableOrderingComposer,
      $$StorePriceTableTableAnnotationComposer,
      $$StorePriceTableTableCreateCompanionBuilder,
      $$StorePriceTableTableUpdateCompanionBuilder,
      (StorePriceRow, $$StorePriceTableTableReferences),
      StorePriceRow,
      PrefetchHooks Function({bool productId})
    >;
typedef $$RefreshSettingsTableTableCreateCompanionBuilder =
    RefreshSettingsTableCompanion Function({
      Value<int> id,
      Value<int> intervalMinutes,
    });
typedef $$RefreshSettingsTableTableUpdateCompanionBuilder =
    RefreshSettingsTableCompanion Function({
      Value<int> id,
      Value<int> intervalMinutes,
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
              }) => RefreshSettingsTableCompanion(
                id: id,
                intervalMinutes: intervalMinutes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> intervalMinutes = const Value.absent(),
              }) => RefreshSettingsTableCompanion.insert(
                id: id,
                intervalMinutes: intervalMinutes,
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
  $$StorePriceTableTableTableManager get storePriceTable =>
      $$StorePriceTableTableTableManager(_db, _db.storePriceTable);
  $$RefreshSettingsTableTableTableManager get refreshSettingsTable =>
      $$RefreshSettingsTableTableTableManager(_db, _db.refreshSettingsTable);
}
