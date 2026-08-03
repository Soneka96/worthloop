// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/features/github_explorer/presentation/widgets/github_profile_card.widget.dart';
import 'package:worth_loop/features/github_explorer/presentation/widgets/github_repo_tile.widget.dart';
import '../../fixtures/github_profile.fixture.dart';
import '../../fixtures/github_repo.fixture.dart';

void main() {
  Widget buildWidget({
    required GithubProfile profile,
    VoidCallback? onToggleFavorite,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: GithubProfileCard(
          profile: profile,
          onToggleFavorite: onToggleFavorite ?? () {},
        ),
      ),
    );
  }

  group('GithubProfileCard contains widgets', () {
    testWidgets(
      'GithubProfileCard contains a "github-explorer-profile-card" Container with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget(profile: buildGithubProfile()));

        expect(
          find.byKey(const Key('github-explorer-profile-card')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'GithubProfileCard contains a Text with the correct parameters for the name',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(profile: buildGithubProfile(name: 'The Octocat')),
        );

        expect(find.text('The Octocat'), findsOneWidget);
      },
    );

    testWidgets(
      'GithubProfileCard contains a Text with the correct parameters for the username',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(profile: buildGithubProfile(username: 'octocat')),
        );

        expect(find.text('@octocat'), findsOneWidget);
      },
    );

    testWidgets(
      'GithubProfileCard contains a Text with the correct parameters for the bio',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(profile: buildGithubProfile(bio: 'GitHub mascot')),
        );

        expect(find.text('GitHub mascot'), findsOneWidget);
      },
    );

    testWidgets(
      'GithubProfileCard contains GithubRepoTile widgets with the correct parameters',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(
            profile: buildGithubProfile(
              repos: [buildGithubRepo(), buildGithubRepo(name: 'second')],
            ),
          ),
        );

        expect(find.byType(GithubRepoTile), findsNWidgets(2));
      },
    );

    testWidgets(
      'GithubProfileCard contains a "github-explorer-favorite-button" IconButton with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget(profile: buildGithubProfile()));

        expect(
          find.byKey(const Key('github-explorer-favorite-button')),
          findsOneWidget,
        );
      },
    );
  });

  group("GithubProfileCard's elements behavior", () {
    testWidgets(
      'GithubProfileCard uses username as the display name when name == null',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(profile: buildGithubProfile(username: 'octocat', name: null)),
        );

        expect(find.text('octocat'), findsWidgets);
      },
    );

    testWidgets(
      'GithubProfileCard does not contain a bio Text when bio == null',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(profile: buildGithubProfile(bio: null)),
        );

        expect(find.text('GitHub mascot'), findsNothing);
      },
    );

    testWidgets(
      'GithubProfileCard displays the no-repos message when repos is empty',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(profile: buildGithubProfile(repos: const [])),
        );

        expect(
          find.text('This user has no public repositories.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'GithubProfileCard contains a "github-explorer-favorite-button" IconButton with the correct behavior when tapped',
      (tester) async {
        bool toggled = false;

        await tester.pumpWidget(
          buildWidget(
            profile: buildGithubProfile(),
            onToggleFavorite: () => toggled = true,
          ),
        );
        await tester.tap(
          find.byKey(const Key('github-explorer-favorite-button')),
        );

        expect(toggled, isTrue);
      },
    );
  });
}
