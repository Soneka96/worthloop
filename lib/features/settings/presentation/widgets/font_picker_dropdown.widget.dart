// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_font_presets.dart';

/// Searchable font-family picker for Appearance settings — every
/// [FontId] preset (except the [FontId.none] sentinel) is a dropdown entry,
/// each rendered in its own font so it previews what selecting it would
/// actually look like. Search matches either the pretty label ("JetBrains
/// Mono") or the raw preset name ("jetBrainsMono"), same as the theme
/// picker's dropdown. Shows at most [_maxVisibleOptions] at a time (with or
/// without a search query) — a growing preset list should stay scannable,
/// not turn into a scroll-forever wall of options.
class FontPickerDropdown extends StatelessWidget {
  static const int _maxVisibleOptions = 10;

  /// The currently-selected font preset.
  final FontId selectedFontId;

  /// Called with the preset the user picked.
  final ValueChanged<FontId> onFontSelected;

  const FontPickerDropdown({
    super.key,
    required this.selectedFontId,
    required this.onFontSelected,
  });

  @override
  Widget build(BuildContext context) {
    // DropdownMenu's own filterCallback re-filters whatever it was already
    // showing, not the full preset list — built fresh here so a search always
    // filters the complete list, not whatever a previous keystroke narrowed
    // it down to (otherwise clearing the search box wouldn't bring back
    // entries an earlier, more specific query had filtered out).
    final List<DropdownMenuEntry<FontId>> allEntries = FontId.values
        .where((fontId) => fontId != FontId.none)
        .map(_entryFor)
        .toList();

    return DropdownMenu<FontId>(
      key: const Key('font-picker-dropdown'),
      initialSelection: selectedFontId,
      enableFilter: true,
      enableSearch: true,
      filterCallback: (_, filter) {
        final String query = filter.toLowerCase();
        return allEntries
            .where(
              (entry) =>
                  entry.label.toLowerCase().contains(query) ||
                  entry.value.name.toLowerCase().contains(query),
            )
            .take(_maxVisibleOptions)
            .toList();
      },
      expandedInsets: EdgeInsets.zero,
      onSelected: (FontId? value) {
        if (value != null) {
          onFontSelected(value);
        }
      },
      // DropdownMenu only runs filterCallback once the search field's
      // onChanged has fired at least once — before any typing, it renders
      // this list completely unfiltered. Capping it here too is what
      // actually limits the very first, no-query view to 10 entries.
      dropdownMenuEntries: allEntries.take(_maxVisibleOptions).toList(),
    );
  }

  DropdownMenuEntry<FontId> _entryFor(FontId fontId) =>
      DropdownMenuEntry<FontId>(
        value: fontId,
        label: fontId.label,
        labelWidget: Text(
          fontId.label,
          style: TextStyle(fontFamily: fontFamilyPresets[fontId]),
        ),
      );
}
