// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// One row in the GitHub Explorer screen's recent-searches list — avatar
/// thumbnail, username, and a favorite toggle for a cached [GithubProfile].
/// Tapping the row re-searches that username.
class RecentSearchTile extends StatelessWidget {
  /// The cached profile this row represents.
  final GithubProfile profile;

  /// Called when the row itself is tapped.
  final VoidCallback onTap;

  /// Called when the favorite star is tapped.
  final VoidCallback onToggleFavorite;

  const RecentSearchTile({
    super.key,
    required this.profile,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      key: Key('github-explorer-recent-search-${profile.username}'),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.spacing.xs),
        child: Row(
          children: [
            ClipOval(
              child: Image.network(
                profile.avatarUrl,
                width: GithubExplorerSizes.recentSearchAvatarDiameter,
                height: GithubExplorerSizes.recentSearchAvatarDiameter,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: GithubExplorerSizes.recentSearchAvatarDiameter,
                  height: GithubExplorerSizes.recentSearchAvatarDiameter,
                  color: colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
            SizedBox(width: context.spacing.sm),
            Expanded(
              child: Text(profile.username, style: textTheme.bodyMedium),
            ),
            IconButton(
              key: Key(
                'github-explorer-recent-search-favorite-${profile.username}',
              ),
              icon: Icon(
                profile.isFavorite ? Icons.star : Icons.star_border,
              ),
              color: profile.isFavorite
                  ? colorScheme.tertiary
                  : colorScheme.onSurfaceVariant,
              tooltip: t.githubExplorer.favoriteSemantics,
              onPressed: onToggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}
