// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LogEntryTableTable extends LogEntryTable
    with TableInfo<$LogEntryTableTable, LogEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LogEntryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LogLevel, int> level =
      GeneratedColumn<int>(
        'level',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<LogLevel>($LogEntryTableTable.$converterlevel);
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    level,
    message,
    details,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'log_entry_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LogEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LogEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LogEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      level: $LogEntryTableTable.$converterlevel.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}level'],
        )!,
      ),
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
    );
  }

  @override
  $LogEntryTableTable createAlias(String alias) {
    return $LogEntryTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LogLevel, int, int> $converterlevel =
      const EnumIndexConverter<LogLevel>(LogLevel.values);
}

class LogEntryRow extends DataClass implements Insertable<LogEntryRow> {
  /// Primary key, auto-incremented by drift.
  final int id;

  /// When this entry was logged.
  final DateTime timestamp;

  /// This entry's severity, stored as [LogLevel]'s enum index.
  final LogLevel level;

  /// The log message text.
  final String message;

  /// The `logger` package printer's fully decorated output (stack frame,
  /// box-drawing) for this entry — `null` if none was captured. Used for
  /// exporting to the dev team; never shown on the Logs screen itself.
  final String? details;
  const LogEntryRow({
    required this.id,
    required this.timestamp,
    required this.level,
    required this.message,
    this.details,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    {
      map['level'] = Variable<int>(
        $LogEntryTableTable.$converterlevel.toSql(level),
      );
    }
    map['message'] = Variable<String>(message);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    return map;
  }

  LogEntryTableCompanion toCompanion(bool nullToAbsent) {
    return LogEntryTableCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      level: Value(level),
      message: Value(message),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
    );
  }

  factory LogEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LogEntryRow(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      level: $LogEntryTableTable.$converterlevel.fromJson(
        serializer.fromJson<int>(json['level']),
      ),
      message: serializer.fromJson<String>(json['message']),
      details: serializer.fromJson<String?>(json['details']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'level': serializer.toJson<int>(
        $LogEntryTableTable.$converterlevel.toJson(level),
      ),
      'message': serializer.toJson<String>(message),
      'details': serializer.toJson<String?>(details),
    };
  }

  LogEntryRow copyWith({
    int? id,
    DateTime? timestamp,
    LogLevel? level,
    String? message,
    Value<String?> details = const Value.absent(),
  }) => LogEntryRow(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    level: level ?? this.level,
    message: message ?? this.message,
    details: details.present ? details.value : this.details,
  );
  LogEntryRow copyWithCompanion(LogEntryTableCompanion data) {
    return LogEntryRow(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      level: data.level.present ? data.level.value : this.level,
      message: data.message.present ? data.message.value : this.message,
      details: data.details.present ? data.details.value : this.details,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LogEntryRow(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('level: $level, ')
          ..write('message: $message, ')
          ..write('details: $details')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp, level, message, details);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LogEntryRow &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.level == this.level &&
          other.message == this.message &&
          other.details == this.details);
}

class LogEntryTableCompanion extends UpdateCompanion<LogEntryRow> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<LogLevel> level;
  final Value<String> message;
  final Value<String?> details;
  const LogEntryTableCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.level = const Value.absent(),
    this.message = const Value.absent(),
    this.details = const Value.absent(),
  });
  LogEntryTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required LogLevel level,
    required String message,
    this.details = const Value.absent(),
  }) : timestamp = Value(timestamp),
       level = Value(level),
       message = Value(message);
  static Insertable<LogEntryRow> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<int>? level,
    Expression<String>? message,
    Expression<String>? details,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (level != null) 'level': level,
      if (message != null) 'message': message,
      if (details != null) 'details': details,
    });
  }

  LogEntryTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<LogLevel>? level,
    Value<String>? message,
    Value<String?>? details,
  }) {
    return LogEntryTableCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      level: level ?? this.level,
      message: message ?? this.message,
      details: details ?? this.details,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(
        $LogEntryTableTable.$converterlevel.toSql(level.value),
      );
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogEntryTableCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('level: $level, ')
          ..write('message: $message, ')
          ..write('details: $details')
          ..write(')'))
        .toString();
  }
}

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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LogEntryTableTable logEntryTable = $LogEntryTableTable(this);
  late final $GithubProfileTableTable githubProfileTable =
      $GithubProfileTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    logEntryTable,
    githubProfileTable,
  ];
}

typedef $$LogEntryTableTableCreateCompanionBuilder =
    LogEntryTableCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      required LogLevel level,
      required String message,
      Value<String?> details,
    });
typedef $$LogEntryTableTableUpdateCompanionBuilder =
    LogEntryTableCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<LogLevel> level,
      Value<String> message,
      Value<String?> details,
    });

class $$LogEntryTableTableFilterComposer
    extends Composer<_$AppDatabase, $LogEntryTableTable> {
  $$LogEntryTableTableFilterComposer({
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

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LogLevel, LogLevel, int> get level =>
      $composableBuilder(
        column: $table.level,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LogEntryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LogEntryTableTable> {
  $$LogEntryTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LogEntryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LogEntryTableTable> {
  $$LogEntryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LogLevel, int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);
}

class $$LogEntryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LogEntryTableTable,
          LogEntryRow,
          $$LogEntryTableTableFilterComposer,
          $$LogEntryTableTableOrderingComposer,
          $$LogEntryTableTableAnnotationComposer,
          $$LogEntryTableTableCreateCompanionBuilder,
          $$LogEntryTableTableUpdateCompanionBuilder,
          (
            LogEntryRow,
            BaseReferences<_$AppDatabase, $LogEntryTableTable, LogEntryRow>,
          ),
          LogEntryRow,
          PrefetchHooks Function()
        > {
  $$LogEntryTableTableTableManager(_$AppDatabase db, $LogEntryTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LogEntryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LogEntryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LogEntryTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<LogLevel> level = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String?> details = const Value.absent(),
              }) => LogEntryTableCompanion(
                id: id,
                timestamp: timestamp,
                level: level,
                message: message,
                details: details,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                required LogLevel level,
                required String message,
                Value<String?> details = const Value.absent(),
              }) => LogEntryTableCompanion.insert(
                id: id,
                timestamp: timestamp,
                level: level,
                message: message,
                details: details,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LogEntryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LogEntryTableTable,
      LogEntryRow,
      $$LogEntryTableTableFilterComposer,
      $$LogEntryTableTableOrderingComposer,
      $$LogEntryTableTableAnnotationComposer,
      $$LogEntryTableTableCreateCompanionBuilder,
      $$LogEntryTableTableUpdateCompanionBuilder,
      (
        LogEntryRow,
        BaseReferences<_$AppDatabase, $LogEntryTableTable, LogEntryRow>,
      ),
      LogEntryRow,
      PrefetchHooks Function()
    >;
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LogEntryTableTableTableManager get logEntryTable =>
      $$LogEntryTableTableTableManager(_db, _db.logEntryTable);
  $$GithubProfileTableTableTableManager get githubProfileTable =>
      $$GithubProfileTableTableTableManager(_db, _db.githubProfileTable);
}
