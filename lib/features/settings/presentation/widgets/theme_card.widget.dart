// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/theme_card_preview.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_theme_presets.dart';

/// One brightness slot (Light or Dark) in App settings' theme picker — a
/// header + [ThemeCardPreview] combined into one clickable box (tapping
/// anywhere in it, not just the preview, makes [brightness] active — the
/// clickable area should match what looks clickable), with a searchable
/// preset dropdown below. [isActive] highlights whichever brightness is
/// current and shows an "Active" chip in the header.
class ThemeCard extends StatelessWidget {
  /// Which brightness slot this card represents.
  final Brightness brightness;

  /// The currently-selected preset for this brightness.
  final ThemeId selectedThemeId;

  /// Whether [brightness] is the app's current brightness.
  final bool isActive;

  /// Called with the preset the user picked from the dropdown.
  final ValueChanged<ThemeId> onThemeSelected;

  /// Called when the card is tapped to make [brightness] active.
  final VoidCallback onActivate;

  const ThemeCard({
    super.key,
    required this.brightness,
    required this.selectedThemeId,
    required this.isActive,
    required this.onThemeSelected,
    required this.onActivate,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double cornerRadius = context.resolvedCornerRadius;
    final List<ThemeId> presetOptions = themePresets.entries
        .where((entry) => entry.key != ThemeId.none)
        .where((entry) => entry.value.brightness == brightness)
        .map((entry) => entry.key)
        .toList();
    final String label = brightness == Brightness.dark
        ? t.settings.appearance.dark
        : t.settings.appearance.light;

    return Container(
      key: Key('theme-card-${brightness.name}'),
      padding: EdgeInsets.all(context.spacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cornerRadius),
        border: Border.all(
          color: isActive ? colorScheme.primary : colorScheme.outline,
          width: isActive
              ? SelectableCardBorders.selected
              : SelectableCardBorders.regular,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(cornerRadius),
            child: Material(
              color: Colors.transparent,
              child: Semantics(
                button: true,
                label: t.settings.appearance.activateThemeSemantics(
                  label: label,
                ),
                child: InkWell(
                  key: Key('theme-card-${brightness.name}-preview'),
                  onTap: onActivate,
                  child: Container(
                    padding: EdgeInsets.all(context.spacing.md),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(cornerRadius),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(label, style: textTheme.bodyMedium),
                            ),
                            if (isActive)
                              Flexible(
                                child: Container(
                                  key: Key(
                                    'theme-card-${brightness.name}-active-badge',
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.spacing.sm,
                                    vertical: context.spacing.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(
                                      cornerRadius,
                                    ),
                                  ),
                                  child: Text(
                                    t.settings.appearance.active,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.primary,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: context.spacing.sm),
                        ThemeCardPreview(
                          colorScheme:
                              themePresets[selectedThemeId] ?? colorScheme,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: context.spacing.sm),
          DropdownMenu<ThemeId>(
            key: Key('theme-card-${brightness.name}-dropdown'),
            initialSelection: selectedThemeId,
            enableFilter: true,
            enableSearch: true,
            // Default filtering only matches against the visible label
            // ("One Dark Pro") — this also matches the raw preset name
            // ("oneDarkPro"), so searching either way finds the preset.
            filterCallback: (entries, filter) {
              final String query = filter.toLowerCase();
              return entries
                  .where(
                    (entry) =>
                        entry.label.toLowerCase().contains(query) ||
                        entry.value.name.toLowerCase().contains(query),
                  )
                  .toList();
            },
            expandedInsets: EdgeInsets.zero,
            onSelected: (ThemeId? value) {
              if (value != null) {
                onThemeSelected(value);
              }
            },
            dropdownMenuEntries: presetOptions
                .map(
                  (ThemeId id) =>
                      DropdownMenuEntry<ThemeId>(value: id, label: id.label),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
