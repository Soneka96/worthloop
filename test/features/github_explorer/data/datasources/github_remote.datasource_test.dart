// Package imports:
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/data/datasources/github_remote.datasource.dart';
import 'package:worth_loop/features/github_explorer/data/models/github_profile.model.dart';
import 'package:worth_loop/shared/failures/failures.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late GithubRemoteDatasource datasource;

  final Map<String, dynamic> profileJson = {
    'login': 'octocat',
    'avatar_url': 'https://example.com/octocat.png',
    'name': 'The Octocat',
    'bio': 'GitHub mascot',
    'public_repos': 8,
    'followers': 4000,
  };
  final List<dynamic> reposJson = [
    {
      'name': 'Hello-World',
      'stargazers_count': 100,
      'description': 'My first repository',
      'language': 'Dart',
    },
  ];

  setUpAll(() {
    registerFallbackValue(Options());
  });

  setUp(() {
    dio = MockDio();
    datasource = GithubRemoteDatasource(dio);
  });

  group('Method fetchProfile() returns the correct value', () {
    test('returns the parsed GithubProfileModel on success', () async {
      when(
        () => dio.get<dynamic>(any(that: contains('/users/octocat'))),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/users/octocat'),
          data: profileJson,
        ),
      );
      when(
        () => dio.get<dynamic>(
          any(that: contains('/users/octocat/repos')),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/users/octocat/repos'),
          data: reposJson,
        ),
      );

      final result = await datasource.fetchProfile('octocat');

      expect(result.isRight(), isTrue);
      final GithubProfileModel model = result.getOrElse(
        (_) => GithubProfileModel(
          username: '',
          avatarUrl: '',
          publicRepos: 0,
          followers: 0,
          repos: const [],
          fetchedAt: DateTime(2000),
        ),
      );
      expect(model.username, 'octocat');
      expect(model.repos, hasLength(1));
    });

    test(
      'returns Left(NetworkFailure) when dio throws DioException on the profile call',
      () async {
        when(
          () => dio.get<dynamic>(any(that: contains('/users/octocat'))),
        ).thenThrow(
          DioException(requestOptions: RequestOptions(path: '/users/octocat')),
        );

        final result = await datasource.fetchProfile('octocat');

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (data) => fail('expected Left, got Right($data)'),
        );
      },
    );

    test(
      'returns Left(NetworkFailure) when dio throws DioException on the repos call',
      () async {
        when(
          () => dio.get<dynamic>(any(that: contains('/users/octocat'))),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/users/octocat'),
            data: profileJson,
          ),
        );
        when(
          () => dio.get<dynamic>(
            any(that: contains('/users/octocat/repos')),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/users/octocat/repos'),
          ),
        );

        final result = await datasource.fetchProfile('octocat');

        expect(result.isLeft(), isTrue);
      },
    );

    test(
      'returns Left(NetworkFailure) when the profile response is missing a field',
      () async {
        when(
          () => dio.get<dynamic>(any(that: contains('/users/octocat'))),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/users/octocat'),
            data: {'login': 'octocat'},
          ),
        );
        when(
          () => dio.get<dynamic>(
            any(that: contains('/users/octocat/repos')),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/users/octocat/repos'),
            data: reposJson,
          ),
        );

        final result = await datasource.fetchProfile('octocat');

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (data) => fail('expected Left, got Right($data)'),
        );
      },
    );
  });
}
