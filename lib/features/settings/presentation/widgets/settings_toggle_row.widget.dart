// Flutter imports:
import 'package:flutter/material.dart';

/// A label + [Switch] row for a single on/off preference — reused across
/// Settings sections (General, Editor, ...).
class SettingsToggleRow extends StatelessWidget {
  /// The preference's name, shown beside the switch.
  final String label;

  /// The preference's current value.
  final bool value;

  /// Called with the new value when the switch is toggled.
  final ValueChanged<bool> onChanged;

  const SettingsToggleRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
