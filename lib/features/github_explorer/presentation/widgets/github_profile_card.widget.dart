// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/features/github_explorer/presentation/widgets/github_repo_tile.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// A found [GithubProfile]'s result card — avatar, name/bio, stats, a
/// favorite toggle, and the top-repositories list.
class GithubProfileCard extends StatelessWidget {
  /// The profile to render.
  final GithubProfile profile;

  /// Called when the favorite star is tapped.
  final VoidCallback onToggleFavorite;

  const GithubProfileCard({
    super.key,
    required this.profile,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      key: const Key('github-explorer-profile-card'),
      padding: EdgeInsets.all(context.spacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(context.resolvedCornerRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: Image.network(
                  profile.avatarUrl,
                  width: GithubExplorerSizes.profileAvatarDiameter,
                  height: GithubExplorerSizes.profileAvatarDiameter,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: GithubExplorerSizes.profileAvatarDiameter,
                    height: GithubExplorerSizes.profileAvatarDiameter,
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.person_outline,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              SizedBox(width: context.spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name ?? profile.username,
                      style: textTheme.titleMedium,
                    ),
                    Text(
                      '@${profile.username}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (profile.bio != null) ...[
                      SizedBox(height: context.spacing.xs),
                      Text(profile.bio!, style: textTheme.bodyMedium),
                    ],
                    SizedBox(height: context.spacing.xs),
                    Text(
                      '${t.githubExplorer.publicRepos(count: profile.publicRepos)} '
                      '· ${t.githubExplorer.followers(count: profile.followers)}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                key: const Key('github-explorer-favorite-button'),
                icon: Icon(profile.isFavorite ? Icons.star : Icons.star_border),
                color: profile.isFavorite
                    ? colorScheme.tertiary
                    : colorScheme.onSurfaceVariant,
                tooltip: t.githubExplorer.favoriteSemantics,
                onPressed: onToggleFavorite,
              ),
            ],
          ),
          SizedBox(height: context.spacing.md),
          Text(t.githubExplorer.topRepos, style: textTheme.labelSmall),
          SizedBox(height: context.spacing.xs),
          if (profile.repos.isEmpty)
            Text(t.githubExplorer.noRepos, style: textTheme.bodySmall)
          else
            ...profile.repos.map((repo) => GithubRepoTile(repo: repo)),
        ],
      ),
    );
  }
}
