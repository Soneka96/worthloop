// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/usecases/search_profile.usecase.dart';

/// Parameters for [SearchProfileUseCase].
@immutable
class SearchProfileParams extends Equatable {
  /// GitHub login/handle to search for.
  final String username;

  const SearchProfileParams({required this.username});

  @override
  List<Object?> get props => [username];
}
