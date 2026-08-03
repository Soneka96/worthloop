// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_repo.entity.dart';
import 'package:worth_loop/features/github_explorer/presentation/widgets/github_repo_tile.widget.dart';
import '../../fixtures/github_repo.fixture.dart';

void main() {
  Widget buildWidget(GithubRepo repo) {
    return MaterialApp(
      home: Scaffold(body: GithubRepoTile(repo: repo)),
    );
  }

  group('GithubRepoTile contains widgets', () {
    testWidgets(
      'GithubRepoTile contains a Text with the correct parameters for the name',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(buildGithubRepo(name: 'Hello-World')),
        );

        expect(find.text('Hello-World'), findsOneWidget);
      },
    );

    testWidgets(
      'GithubRepoTile contains a Text with the correct parameters for the description',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(buildGithubRepo(description: 'My first repository')),
        );

        expect(find.text('My first repository'), findsOneWidget);
      },
    );

    testWidgets(
      'GithubRepoTile contains a Text with the correct parameters for the language',
      (tester) async {
        await tester.pumpWidget(buildWidget(buildGithubRepo(language: 'Dart')));

        expect(find.text('Dart'), findsOneWidget);
      },
    );

    testWidgets(
      'GithubRepoTile contains a Text with the correct parameters for the star count',
      (tester) async {
        await tester.pumpWidget(buildWidget(buildGithubRepo(stars: 42)));

        expect(find.text('42'), findsOneWidget);
      },
    );

    testWidgets('GithubRepoTile contains an Icon with the correct parameters', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(buildGithubRepo()));

      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });

  group("GithubRepoTile's elements behavior", () {
    testWidgets(
      'GithubRepoTile does not contain a description Text when description == null',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(buildGithubRepo(description: null)),
        );

        expect(find.text('My first repository'), findsNothing);
      },
    );

    testWidgets(
      'GithubRepoTile does not contain a language Text when language == null',
      (tester) async {
        await tester.pumpWidget(buildWidget(buildGithubRepo(language: null)));

        expect(find.text('Dart'), findsNothing);
      },
    );
  });
}
