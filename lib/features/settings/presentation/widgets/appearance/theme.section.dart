// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/screens/appearance_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/widgets/theme_card.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_theme.dart';

/// "Theme" group inside [AppearanceSettingsScreen] — light/dark theme cards.
class ThemeSection extends StatelessWidget {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppTheme appTheme = sl<AppTheme>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.settings.appearance.theme, style: textTheme.labelSmall),
        SizedBox(height: context.spacing.xs),
        AnimatedBuilder(
          animation: appTheme,
          builder: (context, _) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ThemeCard(
                  brightness: Brightness.light,
                  selectedThemeId: appTheme.lightThemeId,
                  isActive: appTheme.brightness == Brightness.light,
                  onThemeSelected: appTheme.setTheme,
                  onActivate: () => appTheme.setBrightness(Brightness.light),
                ),
              ),
              SizedBox(width: context.spacing.lg),
              Expanded(
                child: ThemeCard(
                  brightness: Brightness.dark,
                  selectedThemeId: appTheme.darkThemeId,
                  isActive: appTheme.brightness == Brightness.dark,
                  onThemeSelected: appTheme.setTheme,
                  onActivate: () => appTheme.setBrightness(Brightness.dark),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
