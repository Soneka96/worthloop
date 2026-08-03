// Flutter imports:
import 'package:flutter/material.dart';

/// A [DropdownMenu] wrapper that clears its field on open so the user types
/// into a blank search box instead of overwriting the current selection's
/// text, and restores that text if they back out without picking an entry.
class SearchableDropdown<T> extends StatefulWidget {
  /// The currently selected value. Must match a value in [entries].
  final T selected;

  /// [selected]'s display text — shown in the closed field.
  final String selectedLabel;

  /// The full list of choices.
  final List<DropdownMenuEntry<T>> entries;

  /// Called when the user picks an entry.
  final ValueChanged<T> onSelected;

  /// Accessible name for the field, read by screen readers (e.g. "Dark theme
  /// picker"). Also applied to the open/close trailing icon.
  final String semanticLabel;

  const SearchableDropdown({
    super.key,
    required this.selected,
    required this.selectedLabel,
    required this.entries,
    required this.onSelected,
    required this.semanticLabel,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.selectedLabel);
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(SearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus &&
        widget.selectedLabel != oldWidget.selectedLabel) {
      _controller.text = widget.selectedLabel;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _controller.clear();
    } else {
      _controller.text = widget.selectedLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      controller: _controller,
      focusNode: _focusNode,
      initialSelection: widget.selected,
      enableFilter: true,
      enableSearch: true,
      expandedInsets: EdgeInsets.zero,
      trailingIcon: Icon(
        Icons.arrow_drop_down,
        semanticLabel: widget.semanticLabel,
      ),
      selectedTrailingIcon: Icon(
        Icons.arrow_drop_up,
        semanticLabel: widget.semanticLabel,
      ),
      onSelected: (T? value) {
        if (value != null) {
          widget.onSelected(value);
        }
      },
      dropdownMenuEntries: widget.entries,
    );
  }
}
