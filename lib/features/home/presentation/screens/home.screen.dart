// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/state/viewmodels/home_screen.viewmodel.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// The app's initial screen — a compact launcher, locked to a small window
/// size (see `WindowRouteWatcher`). Its only job is picking a destination:
/// a settings shortcut in the corner, and one primary action into GitHub
/// Explorer, the reference feature.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return StoreConnector<AppState, HomeScreenViewModel>(
      distinct: true,
      converter: (store) => sl<HomeScreenViewModel>(param1: store),
      builder: (context, viewmodel) {
        return Padding(
          padding: EdgeInsets.all(context.spacing.md),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    key: const Key('home-settings-button'),
                    onPressed: viewmodel.onOpenSettings,
                    tooltip: t.settings.title,
                    icon: Icon(
                      Icons.settings_outlined,
                      size: IconSizes.md,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        t.appTitle,
                        textAlign: TextAlign.center,
                        style: textTheme.headlineSmall,
                      ),
                      SizedBox(height: context.spacing.xs),
                      Text(
                        t.home.subtitle,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: context.spacing.lg),
                      FilledButton.icon(
                        key: const Key('home-start-searching-button'),
                        onPressed: viewmodel.onOpenGithubExplorer,
                        icon: const Icon(Icons.search),
                        label: Text(t.home.startSearching),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
