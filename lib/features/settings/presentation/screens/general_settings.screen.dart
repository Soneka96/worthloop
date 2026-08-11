// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/viewmodels/general_settings_screen.viewmodel.dart';
import 'package:worth_loop/features/settings/presentation/widgets/general/about.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/general/browser_refresh.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/general/language.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/general/refresh_interval.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/general/updates.section.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// App settings' General category.
class GeneralSettingsScreen extends StatelessWidget {
  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final PackageInfo packageInfo = sl<PackageInfo>();

    return StoreConnector<AppState, GeneralSettingsScreenViewModel>(
      distinct: true,
      onInit: (store) => store.dispatch(const LoadRefreshSettingsAction()),
      converter: (store) => sl<GeneralSettingsScreenViewModel>(param1: store),
      builder: (context, viewmodel) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.settings.general.title, style: textTheme.headlineSmall),
            SizedBox(height: context.spacing.md),
            const LanguageSection(),
            Divider(height: context.spacing.xl),
            RefreshIntervalSection(
              intervalMinutes: viewmodel.refreshIntervalMinutes,
              isBusy: viewmodel.isRefreshIntervalBusy,
              onSelected: viewmodel.onRefreshIntervalSelected,
            ),
            Divider(height: context.spacing.xl),
            BrowserRefreshSection(
              enabled: viewmodel.browserRefreshEnabled,
              isBusy: viewmodel.isRefreshIntervalBusy,
              onChanged: viewmodel.onBrowserRefreshEnabledChanged,
              onOpenBackgroundRestrictions:
                  viewmodel.onOpenBackgroundRestrictions,
            ),
            Divider(height: context.spacing.xl),
            UpdatesSection(
              version: packageInfo.version,
              onCheckForUpdates: viewmodel.onCheckForUpdates,
            ),
            Divider(height: context.spacing.xl),
            AboutSection(onOpenPrivacyPolicy: viewmodel.onOpenPrivacyPolicy),
          ],
        );
      },
    );
  }
}
