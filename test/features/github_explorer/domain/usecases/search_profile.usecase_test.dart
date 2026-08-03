// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/features/github_explorer/domain/repositories/Igithub_explorer.repository.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/params/search_profile.params.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/search_profile.usecase.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/github_profile.fixture.dart';

class MockIGithubExplorerRepository extends Mock
    implements IGithubExplorerRepository {}

void main() {
  late MockIGithubExplorerRepository mockRepo;
  late SearchProfileUseCase useCase;

  setUp(() {
    mockRepo = MockIGithubExplorerRepository();
    useCase = SearchProfileUseCase(mockRepo);
  });

  group('Usecase SearchProfileUseCase returns the correct value', () {
    test(
      'Usecase SearchProfileUseCase returns Right(GithubProfile) when the repository returns Right(GithubProfile)',
      () async {
        final GithubProfile profile = buildGithubProfile(username: 'octocat');
        when(
          () => mockRepo.searchProfile('octocat'),
        ).thenAnswer((_) async => Right(profile));

        final Either<Failure, GithubProfile> result = await useCase(
          const SearchProfileParams(username: 'octocat'),
        );

        expect(result, Right(profile));
        verify(() => mockRepo.searchProfile('octocat')).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test(
      'Usecase SearchProfileUseCase returns Left(NetworkFailure) when the repository returns Left(NetworkFailure)',
      () async {
        const NetworkFailure failure = NetworkFailure('boom');
        when(
          () => mockRepo.searchProfile('octocat'),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, GithubProfile> result = await useCase(
          const SearchProfileParams(username: 'octocat'),
        );

        expect(result, const Left(failure));
        verify(() => mockRepo.searchProfile('octocat')).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );
  });
}
