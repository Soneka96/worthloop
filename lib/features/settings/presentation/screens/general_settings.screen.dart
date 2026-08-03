// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/viewmodels/general_settings_screen.viewmodel.dart';
import 'package:worth_loop/features/settings/presentation/widgets/general/about.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/general/default_save_location.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/general/language.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/general/updates.section.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// App settings' "General" category — default save location, language,
/// update check, and about info.
class GeneralSettingsScreen extends StatelessWidget {
  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final PackageInfo packageInfo = sl<PackageInfo>();

    return StoreConnector<AppState, GeneralSettingsScreenViewModel>(
      distinct: true,
      onInit: (store) => store.dispatch(const LoadGeneralSettingsAction()),
      converter: (store) => sl<GeneralSettingsScreenViewModel>(param1: store),
      builder: (context, viewmodel) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.settings.general.title, style: textTheme.headlineSmall),
            SizedBox(height: context.spacing.md),
            DefaultSaveLocationSection(
              path: viewmodel.defaultSaveLocation,
              pendingPath: viewmodel.pendingDataRoot,
              onPathSelected: viewmodel.onPickDefaultSaveLocation,
              onRestartNow: viewmodel.onRestartNow,
            ),
            SizedBox(height: context.spacing.md),
            const LanguageSection(),
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
