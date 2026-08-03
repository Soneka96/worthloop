// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/settings_option_preview_card.widget.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// A labeled row of [SettingsOptionPreviewCard]s for choosing between a
/// small set of presets (corner style, density, ...) — one instance per
/// preset kind, so the picker layout itself isn't duplicated per kind.
class SettingsOptionPickerRow<T> extends StatelessWidget {
  /// The row's heading, above the option cards.
  final String label;

  /// Every option to show as a card.
  final List<T> options;

  /// Whether the given option is the currently-selected one.
  final bool Function(T option) isSelected;

  /// Called with the option the user picked.
  final ValueChanged<T> onSelected;

  /// The label to show under the given option's card.
  final String Function(T option) labelFor;

  /// The preview widget to show inside the given option's card.
  final Widget Function(T option) previewFor;

  const SettingsOptionPickerRow({
    super.key,
    required this.label,
    required this.options,
    required this.isSelected,
    required this.onSelected,
    required this.labelFor,
    required this.previewFor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        SizedBox(height: context.spacing.xs),
        Row(
          children: [
            for (final (int index, T option) in options.indexed) ...[
              if (index > 0) SizedBox(width: context.spacing.md),
              Expanded(
                child: SettingsOptionPreviewCard(
                  label: labelFor(option),
                  isSelected: isSelected(option),
                  onTap: () => onSelected(option),
                  preview: previewFor(option),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
