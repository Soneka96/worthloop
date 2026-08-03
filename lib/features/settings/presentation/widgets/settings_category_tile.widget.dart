// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/screens/app_settings.screen.dart';
import 'package:worth_loop/shared/constants/enums.dart';

/// One row in [AppSettingsScreen]'s category list. Disabled automatically
/// when [SettingsCategoryX.isEnabled] is false.
class SettingsCategoryTile extends StatelessWidget {
  /// Which category this tile represents.
  final SettingsCategory category;

  /// Whether this is the currently-shown category.
  final bool isSelected;

  /// Called when the tile is tapped.
  final VoidCallback onTap;

  const SettingsCategoryTile({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key('settings-category-${category.name}'),
      leading: Icon(category.icon),
      title: Text(category.label),
      selected: isSelected,
      enabled: category.isEnabled,
      onTap: onTap,
    );
  }
}
