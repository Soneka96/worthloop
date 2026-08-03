// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/screens/appearance_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/widgets/font_picker_dropdown.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/theme/app_font.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// "Font" group inside [AppearanceSettingsScreen] — font family picker.
class FontSection extends StatelessWidget {
  const FontSection({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppFont appFont = sl<AppFont>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.settings.appearance.font, style: textTheme.labelSmall),
        SizedBox(height: context.spacing.xs),
        AnimatedBuilder(
          animation: appFont,
          builder: (context, _) => FontPickerDropdown(
            selectedFontId: appFont.fontId,
            onFontSelected: appFont.setFont,
          ),
        ),
      ],
    );
  }
}
