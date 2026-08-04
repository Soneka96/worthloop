// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GithubProfileTableTable extends GithubProfileTable
    with TableInfo<$GithubProfileTableTable, GithubProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GithubProfileTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
    'bio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publicReposMeta = const VerificationMeta(
    'publicRepos',
  );
  @override
  late final GeneratedColumn<int> publicRepos = GeneratedColumn<int>(
    'public_repos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _followersMeta = const VerificationMeta(
    'followers',
  );
  @override
  late final GeneratedColumn<int> followers = GeneratedColumn<int>(
    'followers',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reposJsonMeta = const VerificationMeta(
    'reposJson',
  );
  @override
  late final GeneratedColumn<String> reposJson = GeneratedColumn<String>(
    'repos_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    username,
    avatarUrl,
    name,
    bio,
    publicRepos,
    followers,
    reposJson,
    isFavorite,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'github_profile_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<GithubProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_avatarUrlMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    }
    if (data.containsKey('public_repos')) {
      context.handle(
        _publicReposMeta,
        publicRepos.isAcceptableOrUnknown(
          data['public_repos']!,
          _publicReposMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_publicReposMeta);
    }
    if (data.containsKey('followers')) {
      context.handle(
        _followersMeta,
        followers.isAcceptableOrUnknown(data['followers']!, _followersMeta),
      );
    } else if (isInserting) {
      context.missing(_followersMeta);
    }
    if (data.containsKey('repos_json')) {
      context.handle(
        _reposJsonMeta,
        reposJson.isAcceptableOrUnknown(data['repos_json']!, _reposJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_reposJsonMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {username};
  @override
  GithubProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GithubProfileRow(
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      ),
      publicRepos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}public_repos'],
      )!,
      followers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}followers'],
      )!,
      reposJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repos_json'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $GithubProfileTableTable createAlias(String alias) {
    return $GithubProfileTableTable(attachedDatabase, alias);
  }
}

class GithubProfileRow extends DataClass
    implements Insertable<GithubProfileRow> {
  /// GitHub login/handle — primary key, not auto-incremented.
  final String username;

  /// URL of the user's avatar image.
  final String avatarUrl;

  /// Display name, `null` if the user hasn't set one.
  final String? name;

  /// Profile bio, `null` if the user hasn't set one.
  final String? bio;

  /// Total public repository count.
  final int publicRepos;

  /// Follower count.
  final int followers;

  /// This user's top starred repositories, JSON-encoded — a handful of
  /// small denormalized rows per profile isn't worth a second table and
  /// join for this feature's scope.
  final String reposJson;

  /// Whether this profile is pinned in the recent-searches list.
  final bool isFavorite;

  /// When this profile was last fetched.
  final DateTime fetchedAt;
  const GithubProfileRow({
    required this.username,
    required this.avatarUrl,
    this.name,
    this.bio,
    required this.publicRepos,
    required this.followers,
    required this.reposJson,
    required this.isFavorite,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['username'] = Variable<String>(username);
    map['avatar_url'] = Variable<String>(avatarUrl);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    map['public_repos'] = Variable<int>(publicRepos);
    map['followers'] = Variable<int>(followers);
    map['repos_json'] = Variable<String>(reposJson);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  GithubProfileTableCompanion toCompanion(bool nullToAbsent) {
    return GithubProfileTableCompanion(
      username: Value(username),
      avatarUrl: Value(avatarUrl),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
      publicRepos: Value(publicRepos),
      followers: Value(followers),
      reposJson: Value(reposJson),
      isFavorite: Value(isFavorite),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory GithubProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GithubProfileRow(
      username: serializer.fromJson<String>(json['username']),
      avatarUrl: serializer.fromJson<String>(json['avatarUrl']),
      name: serializer.fromJson<String?>(json['name']),
      bio: serializer.fromJson<String?>(json['bio']),
      publicRepos: serializer.fromJson<int>(json['publicRepos']),
      followers: serializer.fromJson<int>(json['followers']),
      reposJson: serializer.fromJson<String>(json['reposJson']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'username': serializer.toJson<String>(username),
      'avatarUrl': serializer.toJson<String>(avatarUrl),
      'name': serializer.toJson<String?>(name),
      'bio': serializer.toJson<String?>(bio),
      'publicRepos': serializer.toJson<int>(publicRepos),
      'followers': serializer.toJson<int>(followers),
      'reposJson': serializer.toJson<String>(reposJson),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  GithubProfileRow copyWith({
    String? username,
    String? avatarUrl,
    Value<String?> name = const Value.absent(),
    Value<String?> bio = const Value.absent(),
    int? publicRepos,
    int? followers,
    String? reposJson,
    bool? isFavorite,
    DateTime? fetchedAt,
  }) => GithubProfileRow(
    username: username ?? this.username,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    name: name.present ? name.value : this.name,
    bio: bio.present ? bio.value : this.bio,
    publicRepos: publicRepos ?? this.publicRepos,
    followers: followers ?? this.followers,
    reposJson: reposJson ?? this.reposJson,
    isFavorite: isFavorite ?? this.isFavorite,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  GithubProfileRow copyWithCompanion(GithubProfileTableCompanion data) {
    return GithubProfileRow(
      username: data.username.present ? data.username.value : this.username,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      name: data.name.present ? data.name.value : this.name,
      bio: data.bio.present ? data.bio.value : this.bio,
      publicRepos: data.publicRepos.present
          ? data.publicRepos.value
          : this.publicRepos,
      followers: data.followers.present ? data.followers.value : this.followers,
      reposJson: data.reposJson.present ? data.reposJson.value : this.reposJson,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GithubProfileRow(')
          ..write('username: $username, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('name: $name, ')
          ..write('bio: $bio, ')
          ..write('publicRepos: $publicRepos, ')
          ..write('followers: $followers, ')
          ..write('reposJson: $reposJson, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    username,
    avatarUrl,
    name,
    bio,
    publicRepos,
    followers,
    reposJson,
    isFavorite,
    fetchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GithubProfileRow &&
          other.username == this.username &&
          other.avatarUrl == this.avatarUrl &&
          other.name == this.name &&
          other.bio == this.bio &&
          other.publicRepos == this.publicRepos &&
          other.followers == this.followers &&
          other.reposJson == this.reposJson &&
          other.isFavorite == this.isFavorite &&
          other.fetchedAt == this.fetchedAt);
}

class GithubProfileTableCompanion extends UpdateCompanion<GithubProfileRow> {
  final Value<String> username;
  final Value<String> avatarUrl;
  final Value<String?> name;
  final Value<String?> bio;
  final Value<int> publicRepos;
  final Value<int> followers;
  final Value<String> reposJson;
  final Value<bool> isFavorite;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const GithubProfileTableCompanion({
    this.username = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.name = const Value.absent(),
    this.bio = const Value.absent(),
    this.publicRepos = const Value.absent(),
    this.followers = const Value.absent(),
    this.reposJson = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GithubProfileTableCompanion.insert({
    required String username,
    required String avatarUrl,
    this.name = const Value.absent(),
    this.bio = const Value.absent(),
    required int publicRepos,
    required int followers,
    required String reposJson,
    this.isFavorite = const Value.absent(),
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : username = Value(username),
       avatarUrl = Value(avatarUrl),
       publicRepos = Value(publicRepos),
       followers = Value(followers),
       reposJson = Value(reposJson),
       fetchedAt = Value(fetchedAt);
  static Insertable<GithubProfileRow> custom({
    Expression<String>? username,
    Expression<String>? avatarUrl,
    Expression<String>? name,
    Expression<String>? bio,
    Expression<int>? publicRepos,
    Expression<int>? followers,
    Expression<String>? reposJson,
    Expression<bool>? isFavorite,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (username != null) 'username': username,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (name != null) 'name': name,
      if (bio != null) 'bio': bio,
      if (publicRepos != null) 'public_repos': publicRepos,
      if (followers != null) 'followers': followers,
      if (reposJson != null) 'repos_json': reposJson,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GithubProfileTableCompanion copyWith({
    Value<String>? username,
    Value<String>? avatarUrl,
    Value<String?>? name,
    Value<String?>? bio,
    Value<int>? publicRepos,
    Value<int>? followers,
    Value<String>? reposJson,
    Value<bool>? isFavorite,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return GithubProfileTableCompanion(
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      publicRepos: publicRepos ?? this.publicRepos,
      followers: followers ?? this.followers,
      reposJson: reposJson ?? this.reposJson,
      isFavorite: isFavorite ?? this.isFavorite,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (publicRepos.present) {
      map['public_repos'] = Variable<int>(publicRepos.value);
    }
    if (followers.present) {
      map['followers'] = Variable<int>(followers.value);
    }
    if (reposJson.present) {
      map['repos_json'] = Variable<String>(reposJson.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GithubProfileTableCompanion(')
          ..write('username: $username, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('name: $name, ')
          ..write('bio: $bio, ')
          ..write('publicRepos: $publicRepos, ')
          ..write('followers: $followers, ')
          ..write('reposJson: $reposJson, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

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
  late final $GithubProfileTableTable githubProfileTable =
      $GithubProfileTableTable(this);
  late final $ProductTableTable productTable = $ProductTableTable(this);
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
    githubProfileTable,
    productTable,
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
      result: [TableUpdate('store_price_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$GithubProfileTableTableCreateCompanionBuilder =
    GithubProfileTableCompanion Function({
      required String username,
      required String avatarUrl,
      Value<String?> name,
      Value<String?> bio,
      required int publicRepos,
      required int followers,
      required String reposJson,
      Value<bool> isFavorite,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$GithubProfileTableTableUpdateCompanionBuilder =
    GithubProfileTableCompanion Function({
      Value<String> username,
      Value<String> avatarUrl,
      Value<String?> name,
      Value<String?> bio,
      Value<int> publicRepos,
      Value<int> followers,
      Value<String> reposJson,
      Value<bool> isFavorite,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$GithubProfileTableTableFilterComposer
    extends Composer<_$AppDatabase, $GithubProfileTableTable> {
  $$GithubProfileTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get publicRepos => $composableBuilder(
    column: $table.publicRepos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get followers => $composableBuilder(
    column: $table.followers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reposJson => $composableBuilder(
    column: $table.reposJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GithubProfileTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GithubProfileTableTable> {
  $$GithubProfileTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get publicRepos => $composableBuilder(
    column: $table.publicRepos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get followers => $composableBuilder(
    column: $table.followers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reposJson => $composableBuilder(
    column: $table.reposJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GithubProfileTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GithubProfileTableTable> {
  $$GithubProfileTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<int> get publicRepos => $composableBuilder(
    column: $table.publicRepos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get followers =>
      $composableBuilder(column: $table.followers, builder: (column) => column);

  GeneratedColumn<String> get reposJson =>
      $composableBuilder(column: $table.reposJson, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$GithubProfileTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GithubProfileTableTable,
          GithubProfileRow,
          $$GithubProfileTableTableFilterComposer,
          $$GithubProfileTableTableOrderingComposer,
          $$GithubProfileTableTableAnnotationComposer,
          $$GithubProfileTableTableCreateCompanionBuilder,
          $$GithubProfileTableTableUpdateCompanionBuilder,
          (
            GithubProfileRow,
            BaseReferences<
              _$AppDatabase,
              $GithubProfileTableTable,
              GithubProfileRow
            >,
          ),
          GithubProfileRow,
          PrefetchHooks Function()
        > {
  $$GithubProfileTableTableTableManager(
    _$AppDatabase db,
    $GithubProfileTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GithubProfileTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GithubProfileTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GithubProfileTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> username = const Value.absent(),
                Value<String> avatarUrl = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<int> publicRepos = const Value.absent(),
                Value<int> followers = const Value.absent(),
                Value<String> reposJson = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GithubProfileTableCompanion(
                username: username,
                avatarUrl: avatarUrl,
                name: name,
                bio: bio,
                publicRepos: publicRepos,
                followers: followers,
                reposJson: reposJson,
                isFavorite: isFavorite,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String username,
                required String avatarUrl,
                Value<String?> name = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                required int publicRepos,
                required int followers,
                required String reposJson,
                Value<bool> isFavorite = const Value.absent(),
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => GithubProfileTableCompanion.insert(
                username: username,
                avatarUrl: avatarUrl,
                name: name,
                bio: bio,
                publicRepos: publicRepos,
                followers: followers,
                reposJson: reposJson,
                isFavorite: isFavorite,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GithubProfileTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GithubProfileTableTable,
      GithubProfileRow,
      $$GithubProfileTableTableFilterComposer,
      $$GithubProfileTableTableOrderingComposer,
      $$GithubProfileTableTableAnnotationComposer,
      $$GithubProfileTableTableCreateCompanionBuilder,
      $$GithubProfileTableTableUpdateCompanionBuilder,
      (
        GithubProfileRow,
        BaseReferences<
          _$AppDatabase,
          $GithubProfileTableTable,
          GithubProfileRow
        >,
      ),
      GithubProfileRow,
      PrefetchHooks Function()
    >;
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
          PrefetchHooks Function({bool storePriceTableRefs})
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
          prefetchHooksCallback: ({storePriceTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (storePriceTableRefs) db.storePriceTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
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
      PrefetchHooks Function({bool storePriceTableRefs})
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
  $$GithubProfileTableTableTableManager get githubProfileTable =>
      $$GithubProfileTableTableTableManager(_db, _db.githubProfileTable);
  $$ProductTableTableTableManager get productTable =>
      $$ProductTableTableTableManager(_db, _db.productTable);
  $$StorePriceTableTableTableManager get storePriceTable =>
      $$StorePriceTableTableTableManager(_db, _db.storePriceTable);
  $$RefreshSettingsTableTableTableManager get refreshSettingsTable =>
      $$RefreshSettingsTableTableTableManager(_db, _db.refreshSettingsTable);
}
