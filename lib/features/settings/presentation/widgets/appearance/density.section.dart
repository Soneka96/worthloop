// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/screens/appearance_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/widgets/density_preview_rows.widget.dart';
import 'package:worth_loop/features/settings/presentation/widgets/settings_option_picker_row.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_spacing.dart';

/// "Density" group inside [AppearanceSettingsScreen] — comfortable vs compact.
class DensitySection extends StatelessWidget {
  static const List<SpacingDensity> _options = [
    SpacingDensity.comfortable,
    SpacingDensity.compact,
  ];

  const DensitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final AppSpacing appSpacing = sl<AppSpacing>();
    return AnimatedBuilder(
      animation: appSpacing,
      builder: (context, _) => SettingsOptionPickerRow<SpacingDensity>(
        label: t.settings.appearance.density,
        options: _options,
        isSelected: (density) => appSpacing.density == density,
        onSelected: appSpacing.setDensity,
        labelFor: (density) => density.label,
        previewFor: (density) =>
            DensityPreviewRows(itemCount: density.previewRowCount),
      ),
    );
  }
}
