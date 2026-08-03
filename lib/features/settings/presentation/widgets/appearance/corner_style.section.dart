// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/screens/appearance_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/widgets/corner_style_preview_box.widget.dart';
import 'package:worth_loop/features/settings/presentation/widgets/settings_option_picker_row.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_shape.dart';

/// "Corner style" group inside [AppearanceSettingsScreen] — rounded vs square.
class CornerStyleSection extends StatelessWidget {
  static const List<CornerStyle> _options = [
    CornerStyle.rounded,
    CornerStyle.square,
  ];

  const CornerStyleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AppShape appShape = sl<AppShape>();
    return AnimatedBuilder(
      animation: appShape,
      builder: (context, _) => SettingsOptionPickerRow<CornerStyle>(
        label: t.settings.appearance.cornerStyle,
        options: _options,
        isSelected: (style) => appShape.cornerStyle == style,
        onSelected: appShape.setCornerStyle,
        labelFor: (style) => style.label,
        previewFor: (style) => CornerStylePreviewBox(style: style),
      ),
    );
  }
}
