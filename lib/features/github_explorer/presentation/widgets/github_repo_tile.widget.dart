// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_repo.entity.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// One row in [GithubProfileCard]'s top-repositories list — name, star
/// count, description, and language for a single [GithubRepo].
class GithubRepoTile extends StatelessWidget {
  /// The repository to render.
  final GithubRepo repo;

  const GithubRepoTile({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: GithubExplorerSizes.repoRowMinHeight,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.spacing.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(repo.name, style: textTheme.bodyMedium),
                  if (repo.description != null)
                    Text(
                      repo.description!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (repo.language != null)
                    Text(
                      repo.language!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: context.spacing.sm),
            Icon(Icons.star, size: IconSizes.sm, color: colorScheme.tertiary),
            SizedBox(width: context.spacing.xs),
            Text('${repo.stars}', style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
