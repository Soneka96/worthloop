// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/screens/appearance_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/widgets/zoom_control.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_zoom.dart';

/// "Zoom" group inside [AppearanceSettingsScreen] — UI zoom level control.
///
/// Shows the current level as a single live value next to the section
/// label, rather than a row of five percentage labels under
/// [ZoomControl]'s track — that row had to stay pixel-aligned with the
/// track's dots and drifted out of sync whenever either row's layout
/// changed independently.
class ZoomSection extends StatelessWidget {
  const ZoomSection({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppZoom appZoom = sl<AppZoom>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: appZoom,
          builder: (context, _) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t.settings.appearance.zoom, style: textTheme.labelSmall),
              Text('${appZoom.level.toInt()}%', style: textTheme.bodySmall),
            ],
          ),
        ),
        SizedBox(height: context.spacing.xs),
        AnimatedBuilder(
          animation: appZoom,
          builder: (context, _) => ZoomControl(
            currentLevel: appZoom.level,
            onLevelChanged: appZoom.setLevel,
          ),
        ),
      ],
    );
  }
}
