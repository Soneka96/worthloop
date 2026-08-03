// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/features/github_explorer/presentation/widgets/recent_search_tile.widget.dart';
import '../../fixtures/github_profile.fixture.dart';

void main() {
  Widget buildWidget({
    required GithubProfile profile,
    VoidCallback? onTap,
    VoidCallback? onToggleFavorite,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: RecentSearchTile(
          profile: profile,
          onTap: onTap ?? () {},
          onToggleFavorite: onToggleFavorite ?? () {},
        ),
      ),
    );
  }

  group('RecentSearchTile contains widgets', () {
    testWidgets(
      'RecentSearchTile contains a Text with the correct parameters for the username',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(profile: buildGithubProfile(username: 'octocat')),
        );

        expect(find.text('octocat'), findsOneWidget);
      },
    );

    testWidgets(
      'RecentSearchTile contains a "github-explorer-recent-search-favorite-octocat" IconButton with the correct parameters',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(profile: buildGithubProfile(username: 'octocat')),
        );

        expect(
          find.byKey(
            const Key('github-explorer-recent-search-favorite-octocat'),
          ),
          findsOneWidget,
        );
      },
    );
  });

  group("RecentSearchTile's elements behavior", () {
    testWidgets(
      'RecentSearchTile contains a "github-explorer-recent-search-octocat" InkWell with the correct behavior when tapped',
      (tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          buildWidget(
            profile: buildGithubProfile(username: 'octocat'),
            onTap: () => tapped = true,
          ),
        );
        await tester.tap(
          find.byKey(const Key('github-explorer-recent-search-octocat')),
        );

        expect(tapped, isTrue);
      },
    );

    testWidgets(
      'RecentSearchTile contains a "github-explorer-recent-search-favorite-octocat" IconButton with the correct behavior when tapped',
      (tester) async {
        bool toggled = false;

        await tester.pumpWidget(
          buildWidget(
            profile: buildGithubProfile(username: 'octocat'),
            onToggleFavorite: () => toggled = true,
          ),
        );
        await tester.tap(
          find.byKey(
            const Key('github-explorer-recent-search-favorite-octocat'),
          ),
        );

        expect(toggled, isTrue);
      },
    );

    testWidgets(
      'RecentSearchTile contains a "github-explorer-recent-search-favorite-octocat" IconButton with the correct parameters when profile.isFavorite = true',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(
            profile: buildGithubProfile(username: 'octocat', isFavorite: true),
          ),
        );

        final IconButton button = tester.widget(
          find.byKey(
            const Key('github-explorer-recent-search-favorite-octocat'),
          ),
        );
        final Icon icon = button.icon as Icon;
        expect(icon.icon, Icons.star);
      },
    );

    testWidgets(
      'RecentSearchTile contains a "github-explorer-recent-search-favorite-octocat" IconButton with the correct parameters when profile.isFavorite = false',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(
            profile: buildGithubProfile(username: 'octocat', isFavorite: false),
          ),
        );

        final IconButton button = tester.widget(
          find.byKey(
            const Key('github-explorer-recent-search-favorite-octocat'),
          ),
        );
        final Icon icon = button.icon as Icon;
        expect(icon.icon, Icons.star_border);
      },
    );
  });
}
