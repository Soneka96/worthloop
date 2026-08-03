// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/repositories/Igithub_explorer.repository.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/params/toggle_favorite.params.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/toggle_favorite.usecase.dart';
import 'package:worth_loop/shared/failures/failures.dart';

class MockIGithubExplorerRepository extends Mock
    implements IGithubExplorerRepository {}

void main() {
  late MockIGithubExplorerRepository mockRepo;
  late ToggleFavoriteUseCase useCase;

  setUp(() {
    mockRepo = MockIGithubExplorerRepository();
    useCase = ToggleFavoriteUseCase(mockRepo);
  });

  group('Usecase ToggleFavoriteUseCase returns the correct value', () {
    test(
      'Usecase ToggleFavoriteUseCase returns Right(unit) when the repository returns Right(unit)',
      () async {
        when(
          () => mockRepo.toggleFavorite('octocat'),
        ).thenAnswer((_) async => const Right(unit));

        final Either<Failure, Unit> result = await useCase(
          const ToggleFavoriteParams(username: 'octocat'),
        );

        expect(result, const Right(unit));
        verify(() => mockRepo.toggleFavorite('octocat')).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test(
      'Usecase ToggleFavoriteUseCase returns Left(DatabaseFailure) when the repository returns Left(DatabaseFailure)',
      () async {
        const DatabaseFailure failure = DatabaseFailure('boom');
        when(
          () => mockRepo.toggleFavorite('octocat'),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Unit> result = await useCase(
          const ToggleFavoriteParams(username: 'octocat'),
        );

        expect(result, const Left(failure));
        verify(() => mockRepo.toggleFavorite('octocat')).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );
  });
}
