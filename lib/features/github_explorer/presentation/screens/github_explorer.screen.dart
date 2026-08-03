// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.actions.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/viewmodels/github_explorer_screen.viewmodel.dart';
import 'package:worth_loop/features/github_explorer/presentation/widgets/github_profile_card.widget.dart';
import 'package:worth_loop/features/github_explorer/presentation/widgets/recent_search_tile.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// The GitHub Explorer feature's screen — search a username, see their
/// profile and top repositories, and revisit or pin previous searches.
/// This is the template's reference example feature: a full
/// remote+local-datasource → repository → usecase → Redux → screen chain,
/// same shape as any feature you add on top of this template.
class GithubExplorerScreen extends StatefulWidget {
  const GithubExplorerScreen({super.key});

  @override
  State<GithubExplorerScreen> createState() => _GithubExplorerScreenState();
}

class _GithubExplorerScreenState extends State<GithubExplorerScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return StoreConnector<AppState, GithubExplorerScreenViewModel>(
      distinct: true,
      onInit: (store) => store.dispatch(const LoadRecentSearchesAction()),
      converter: (store) => sl<GithubExplorerScreenViewModel>(param1: store),
      builder: (context, viewmodel) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(context.spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    key: const Key('github-explorer-home-button'),
                    onPressed: viewmodel.onGoHome,
                    tooltip: t.githubExplorer.goHomeTooltip,
                    icon: Icon(
                      Icons.arrow_back,
                      size: IconSizes.md,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      t.githubExplorer.title,
                      style: textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    key: const Key('github-explorer-settings-button'),
                    onPressed: viewmodel.onOpenSettings,
                    tooltip: t.githubExplorer.settingsTooltip,
                    icon: Icon(
                      Icons.settings_outlined,
                      size: IconSizes.md,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.spacing.md),
              Row(
                children: [
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: GithubExplorerSizes.searchFieldMinHeight,
                      ),
                      child: TextField(
                        key: const Key('github-explorer-search-field'),
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: t.githubExplorer.searchHint,
                          errorText: viewmodel.error,
                        ),
                        onSubmitted: (_) => _search(viewmodel),
                      ),
                    ),
                  ),
                  SizedBox(width: context.spacing.sm),
                  FilledButton(
                    key: const Key('github-explorer-search-button'),
                    onPressed: viewmodel.isSearching
                        ? null
                        : () => _search(viewmodel),
                    child: Text(t.githubExplorer.searchButton),
                  ),
                ],
              ),
              SizedBox(height: context.spacing.md),
              if (viewmodel.isSearching)
                const Center(
                  key: Key('github-explorer-loading-indicator'),
                  child: CircularProgressIndicator(),
                )
              else if (viewmodel.profile == null)
                Text(t.githubExplorer.noResultYet, style: textTheme.bodyMedium)
              else
                GithubProfileCard(
                  profile: viewmodel.profile!,
                  onToggleFavorite: () =>
                      viewmodel.onToggleFavorite(viewmodel.profile!.username),
                ),
              SizedBox(height: context.spacing.lg),
              Text(
                t.githubExplorer.recentSearches,
                style: textTheme.labelSmall,
              ),
              SizedBox(height: context.spacing.xs),
              if (viewmodel.recentSearches.isEmpty)
                Text(
                  t.githubExplorer.noRecentSearches,
                  style: textTheme.bodySmall,
                )
              else
                ...viewmodel.recentSearches.map(
                  (profile) => RecentSearchTile(
                    profile: profile,
                    onTap: () {
                      _searchController.text = profile.username;
                      viewmodel.onSearch(profile.username);
                    },
                    onToggleFavorite: () =>
                        viewmodel.onToggleFavorite(profile.username),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _search(GithubExplorerScreenViewModel viewmodel) {
    final String username = _searchController.text.trim();
    if (username.isNotEmpty) {
      viewmodel.onSearch(username);
    }
  }
}
