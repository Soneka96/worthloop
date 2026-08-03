// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/theme/app_language.dart';

/// Dropdown picker for [AppLocale] — the UI language.
class LanguagePickerDropdown extends StatelessWidget {
  /// The currently selected language.
  final AppLocale selectedLocale;

  /// Called with the newly-picked language.
  final ValueChanged<AppLocale> onLocaleSelected;

  const LanguagePickerDropdown({
    super.key,
    required this.selectedLocale,
    required this.onLocaleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<AppLocale>(
      key: const Key('language-picker-dropdown'),
      initialSelection: selectedLocale,
      expandedInsets: EdgeInsets.zero,
      enableSearch: false,
      selectOnly: true,
      onSelected: (AppLocale? value) {
        if (value != null) {
          onLocaleSelected(value);
        }
      },
      dropdownMenuEntries: AppLocale.values
          .map(
            (locale) => DropdownMenuEntry<AppLocale>(
              value: locale,
              label: locale.label,
            ),
          )
          .toList(),
    );
  }
}
