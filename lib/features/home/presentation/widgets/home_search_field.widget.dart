// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';

/// A tonal search field for filtering tracked products by name.
class HomeSearchField extends StatefulWidget {
  /// Called with the field's text on every change.
  final ValueChanged<String> onChanged;

  const HomeSearchField({required this.onChanged, super.key});

  @override
  State<HomeSearchField> createState() => _HomeSearchFieldState();
}

class _HomeSearchFieldState extends State<HomeSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, _) => TextField(
        key: const Key('home-search-field'),
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: t.home.searchHint,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: value.text.isEmpty
              ? null
              : IconButton(
                  key: const Key('home-search-clear-button'),
                  icon: const Icon(Icons.clear),
                  tooltip: t.home.searchClearTooltip,
                  onPressed: _clear,
                ),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.resolvedCornerRadius),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
