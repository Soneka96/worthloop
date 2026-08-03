// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_shape_presets.dart';

/// Preview content for a [SettingsOptionPreviewCard] corner-style option —
/// a small box using [style]'s own radius (from [cornerRadiusPresets]), so
/// each option previews what selecting it would actually look like, rather
/// than the app's currently-active corner style.
class CornerStylePreviewBox extends StatelessWidget {
  /// Which corner style to preview.
  final CornerStyle style;

  const CornerStylePreviewBox({super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: SettingsOptionSizes.previewHeight,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(cornerRadiusPresets[style]!),
      ),
    );
  }
}
