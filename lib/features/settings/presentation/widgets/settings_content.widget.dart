// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/screens/appearance_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/screens/general_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/screens/notifications_settings.screen.dart';
import 'package:worth_loop/shared/constants/enums.dart';

/// The content pane for whichever [SettingsCategory] is selected. Categories
/// without a built-out section yet render nothing.
class SettingsContent extends StatelessWidget {
  /// Which settings category to show content for.
  final SettingsCategory category;

  const SettingsContent({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return switch (category) {
      SettingsCategory.general => const GeneralSettingsScreen(),
      SettingsCategory.appearance => const AppearanceSettingsScreen(),
      SettingsCategory.notifications => const NotificationsSettingsScreen(),
      _ => const SizedBox.shrink(),
    };
  }
}
