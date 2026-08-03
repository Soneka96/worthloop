// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/features/github_explorer/domain/repositories/Igithub_explorer.repository.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/load_recent_searches.usecase.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import '../../fixtures/github_profile.fixture.dart';

class MockIGithubExplorerRepository extends Mock
    implements IGithubExplorerRepository {}

void main() {
  late MockIGithubExplorerRepository mockRepo;
  late LoadRecentSearchesUseCase useCase;

  setUp(() {
    mockRepo = MockIGithubExplorerRepository();
    useCase = LoadRecentSearchesUseCase(mockRepo);
  });

  group('Usecase LoadRecentSearchesUseCase returns the correct value', () {
    test(
      'Usecase LoadRecentSearchesUseCase returns Right(List<GithubProfile>) when the repository returns Right(List<GithubProfile>)',
      () async {
        final GithubProfile profile = buildGithubProfile();
        when(
          () => mockRepo.loadRecentSearches(),
        ).thenAnswer((_) async => Right([profile]));

        final Either<Failure, List<GithubProfile>> result = await useCase(
          NoParams(),
        );

        expect(result.isRight(), isTrue);
        expect(result.getOrElse((_) => []), [profile]);
        verify(() => mockRepo.loadRecentSearches()).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test(
      'Usecase LoadRecentSearchesUseCase returns Left(DatabaseFailure) when the repository returns Left(DatabaseFailure)',
      () async {
        const DatabaseFailure failure = DatabaseFailure('boom');
        when(
          () => mockRepo.loadRecentSearches(),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, List<GithubProfile>> result = await useCase(
          NoParams(),
        );

        expect(result, const Left(failure));
        verify(() => mockRepo.loadRecentSearches()).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );
  });
}
