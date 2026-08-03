// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// One tappable choice in a preset picker (corner style, density, ...) — a
/// small [preview] of what the option looks like, a [label] underneath, and
/// a border that highlights when [isSelected]. The whole card is the tap
/// target, not just the preview, so the clickable area matches what looks
/// clickable.
class SettingsOptionPreviewCard extends StatelessWidget {
  /// The option's name, shown under the preview.
  final String label;

  /// Whether this is the currently-selected option.
  final bool isSelected;

  /// Called when the card is tapped.
  final VoidCallback onTap;

  /// The option's visual preview, shown above the label.
  final Widget preview;

  const SettingsOptionPreviewCard({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double cornerRadius = context.resolvedCornerRadius;
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        key: Key(
          'settings-option-preview-card-${label.toLowerCase().replaceAll(' ', '-')}',
        ),
        onTap: onTap,
        borderRadius: BorderRadius.circular(cornerRadius),
        child: Container(
          padding: EdgeInsets.all(context.spacing.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cornerRadius),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: isSelected
                  ? SelectableCardBorders.selected
                  : SelectableCardBorders.regular,
            ),
          ),
          child: Column(
            children: [
              preview,
              SizedBox(height: context.spacing.sm),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
