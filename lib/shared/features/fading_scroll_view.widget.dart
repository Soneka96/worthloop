// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';

// Project imports:
import 'package:worth_loop/shared/constants/layout_constants.dart';

/// A scrollable pane with top and bottom fades — softens the cut-off at
/// either scroll edge instead of hard-clipping content. Pass a `key` that
/// changes when the content changes (e.g. a selected-tab enum) to reset
/// scroll to the top instead of carrying over the old position.
class FadingScrollView extends StatefulWidget {
  /// The scrollable content.
  final Widget child;

  const FadingScrollView({super.key, required this.child});

  @override
  State<FadingScrollView> createState() => _FadingScrollViewState();
}

class _FadingScrollViewState extends State<FadingScrollView> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _controller,
      child: FadingEdgeScrollView.fromSingleChildScrollView(
        child: SingleChildScrollView(
          controller: _controller,
          padding: const EdgeInsets.all(ScrollFadeSizes.gutter),
          child: widget.child,
        ),
      ),
    );
  }
}
