// Package imports:
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sqlite3/sqlite3.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';

/// Base type for typed, recoverable errors translated from infrastructure exceptions.
/// Datasources catch source-specific exceptions and wrap them in a concrete [Failure]
/// before they reach a repository or use case.
///
/// All [Failure] subclasses live in this one file — they're tightly related, small
/// value types, and grouping them keeps the whole hierarchy visible at a glance.
@immutable
abstract class Failure extends Equatable {
  /// Human-readable description of what went wrong.
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Wraps a database-layer exception (e.g. a drift [SqliteException]).
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Wraps a filesystem/platform exception (e.g. the file picker failing).
class FileSystemFailure extends Failure {
  const FileSystemFailure(super.message);
}

/// Wraps a network-layer exception (e.g. a dio [DioException]).
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Represents a requested record that does not exist.
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// Represents offers that cannot be compared because their currencies differ.
class CurrencyFailure extends Failure {
  const CurrencyFailure(super.message);
}

/// Represents user input that cannot create a valid record.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Describes a classified remote price-fetch failure.
class PriceFetchFailure extends Failure {
  /// The classified reason for the failed fetch.
  final PriceFetchStatus status;

  const PriceFetchFailure({required this.status, required String message})
    : super(message);

  @override
  List<Object?> get props => [status, message];
}
