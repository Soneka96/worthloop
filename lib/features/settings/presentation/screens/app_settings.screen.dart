// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/settings_content.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// App-wide General and Appearance settings.
class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  static const List<SettingsCategory> _categories = [
    SettingsCategory.general,
    SettingsCategory.appearance,
    SettingsCategory.notifications,
  ];

  SettingsCategory _selectedCategory = SettingsCategory.general;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.title)),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(context.spacing.md),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<SettingsCategory>(
                key: const Key('settings-category-selector'),
                segments: _categories
                    .map(
                      (SettingsCategory category) =>
                          ButtonSegment<SettingsCategory>(
                            value: category,
                            label: Text(category.label),
                            icon: Icon(category.icon),
                          ),
                    )
                    .toList(growable: false),
                selected: {_selectedCategory},
                onSelectionChanged: (Set<SettingsCategory> selected) {
                  if (selected.isNotEmpty) {
                    setState(() => _selectedCategory = selected.first);
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.spacing.md),
              child: SingleChildScrollView(
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
