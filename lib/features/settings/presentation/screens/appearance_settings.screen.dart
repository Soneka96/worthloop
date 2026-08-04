// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/appearance/corner_style.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/appearance/density.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/appearance/font.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/appearance/theme.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/appearance/zoom.section.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// App settings' "Appearance" category — theme, corner style, density, font,
/// and zoom controls.
class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(t.settings.appearance.title, style: textTheme.headlineSmall),
        SizedBox(height: context.spacing.md),
        const ThemeSection(),
        SizedBox(height: context.spacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CornerStyleSection(),
            SizedBox(height: context.spacing.md),
            const DensitySection(),
          ],
        ),
        SizedBox(height: context.spacing.md),
        const FontSection(),
        SizedBox(height: context.spacing.md),
        const ZoomSection(),
      ],
    );
  }
}
