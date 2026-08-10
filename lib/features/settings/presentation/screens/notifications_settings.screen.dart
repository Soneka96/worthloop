// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/viewmodels/notifications_settings_screen.viewmodel.dart';
import 'package:worth_loop/features/settings/presentation/widgets/notifications/price_drop_alerts.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/notifications/price_increase_alerts.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/notifications/refresh_completed_alerts.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/notifications/show_refresh_progress.section.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// App settings' "Notifications" category — price-alert and background-refresh
/// notification controls.
class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return StoreConnector<AppState, NotificationsSettingsScreenViewModel>(
      distinct: true,
      converter: (store) =>
          sl<NotificationsSettingsScreenViewModel>(param1: store),
      builder: (context, viewmodel) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.settings.notifications.title,
              style: textTheme.headlineSmall,
            ),
            SizedBox(height: context.spacing.md),
            Text(
              t.settings.notifications.priceAlertsSectionLabel,
              style: textTheme.labelSmall,
            ),
            PriceDropAlertsSection(
              enabled: viewmodel.priceDropAlertsEnabled,
              isBusy: viewmodel.isBusy,
              onChanged: viewmodel.onPriceDropAlertsEnabledChanged,
            ),
            PriceIncreaseAlertsSection(
              enabled: viewmodel.priceIncreaseAlertsEnabled,
              isBusy: viewmodel.isBusy,
              onChanged: viewmodel.onPriceIncreaseAlertsEnabledChanged,
            ),
            Divider(height: context.spacing.xl),
            Text(
              t.settings.notifications.refreshActivitySectionLabel,
              style: textTheme.labelSmall,
            ),
            RefreshCompletedAlertsSection(
              enabled: viewmodel.refreshCompletedAlertsEnabled,
              isBusy: viewmodel.isBusy,
              onChanged: viewmodel.onRefreshCompletedAlertsEnabledChanged,
            ),
            ShowRefreshProgressSection(
              enabled: viewmodel.showRefreshProgress,
              isBusy: viewmodel.isBusy,
              onChanged: viewmodel.onShowRefreshProgressChanged,
            ),
          ],
        );
      },
    );
  }
}
