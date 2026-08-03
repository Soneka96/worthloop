// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/settings_category_tile.widget.dart';
import 'package:worth_loop/features/settings/presentation/widgets/settings_content.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/features/fading_scroll_view.widget.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// App-wide settings with General and Appearance categories.
class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  static const List<SettingsCategory> _categories = [
    SettingsCategory.general,
    SettingsCategory.appearance,
  ];

  SettingsCategory _selectedCategory = SettingsCategory.appearance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.title)),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: SettingsSizes.sidebarWidth,
            ),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _categories
                    .map(
                      (category) => SettingsCategoryTile(
                        category: category,
                        isSelected: category == _selectedCategory,
                        onTap: () =>
                            setState(() => _selectedCategory = category),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const VerticalDivider(width: DividerSizes.hairline),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(
                left: context.spacing.xl,
                right: context.spacing.xl,
              ),
              child: FadingScrollView(
                key: ValueKey(_selectedCategory),
                child: SettingsContent(category: _selectedCategory),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
