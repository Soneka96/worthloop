// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/settings_category_tile.widget.dart';
import 'package:worth_loop/shared/constants/enums.dart';

void main() {
  Widget buildWidget({
    required SettingsCategory category,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SettingsCategoryTile(
          category: category,
          isSelected: isSelected,
          onTap: onTap ?? () {},
        ),
      ),
    );
  }

  group('SettingsCategoryTile contains widgets', () {
    testWidgets(
      'SettingsCategoryTile contains a "settings-category-appearance" ListTile with the correct parameters',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(category: SettingsCategory.appearance, isSelected: true),
        );

        final ListTile tile = tester.widget(
          find.byKey(const Key('settings-category-appearance')),
        );

        expect(find.text('Appearance'), findsOneWidget);
        expect(tile.selected, true);
        expect(tile.enabled, true);
        expect((tile.leading as Icon).icon, SettingsCategory.appearance.icon);
      },
    );
  });

  group("SettingsCategoryTile's elements behavior", () {
    testWidgets('SettingsCategoryTile calls onTap when tapped', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          category: SettingsCategory.appearance,
          onTap: () => print('onTap called'),
        ),
      );

      await expectLater(
        () => tester.tap(find.byKey(const Key('settings-category-appearance'))),
        prints('onTap called\n'),
      );
    });
  });
}
