// Package imports:
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/data/models/github_profile.model.dart';
import 'package:worth_loop/shared/constants/app_constants.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Calls GitHub's public REST API — no authentication, no API key.
class GithubRemoteDatasource {
  GithubRemoteDatasource(this._dio);

  /// HTTP client this datasource calls through.
  final Dio _dio;

  /// Fetches [username]'s profile and their top
  /// [GithubExplorerConstants.repoFetchLimit] starred repositories. Any
  /// [DioException] or malformed response is reported as [NetworkFailure],
  /// never silently treated as success.
  Future<Either<Failure, GithubProfileModel>> fetchProfile(
    String username,
  ) async {
    try {
      final Response<dynamic> profileResponse = await _dio.get<dynamic>(
        '${GithubExplorerConstants.baseUrl}/users/$username',
      );
      final Response<dynamic> reposResponse = await _dio.get<dynamic>(
        '${GithubExplorerConstants.baseUrl}/users/$username/repos',
        queryParameters: {
          'sort': 'stars',
          'direction': 'desc',
          'per_page': GithubExplorerConstants.repoFetchLimit,
        },
      );
      return Right(
        GithubProfileModel.fromRemote(
          profileJson: profileResponse.data,
          reposJson: reposResponse.data,
        ),
      );
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? e.toString()));
    } on FormatException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }
}
