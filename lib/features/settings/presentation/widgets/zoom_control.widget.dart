// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_zoom.dart';

/// Discrete zoom-level picker — five-dot track (with a background rail)
/// plus zoom-out/in icons. The whole track is tappable/draggable; while
/// dragging, the thumb follows the pointer continuously and only snaps to
/// the nearest of [AppZoom.levels] on release, rather than jumping between
/// fixed slots on every drag update (which reads as "teleporting" instead of
/// a fluid drag). The current level's percentage is shown by the section
/// wrapping this widget, not here, to avoid a second row that has to stay
/// pixel-aligned with the track's five dots.
class ZoomControl extends StatefulWidget {
  /// The current zoom level, one of [AppZoom.levels].
  final double currentLevel;

  /// Called with the new level once a drag/tap settles on a step.
  final ValueChanged<double> onLevelChanged;

  const ZoomControl({
    super.key,
    required this.currentLevel,
    required this.onLevelChanged,
  });

  @override
  State<ZoomControl> createState() => _ZoomControlState();
}

// Zero duration while dragging (the thumb tracks the cursor with no lag),
// snap-animated only once the drag/tap ends — a slight overshoot reads as a
// deliberate "click into the slot" rather than just a fast fade.
class _ZoomControlState extends State<ZoomControl> {
  /// Raw, unsnapped drag position (0.0-1.0 along the track). `null` outside
  /// of an active drag, when the thumb falls back to
  /// [ZoomControl.currentLevel]'s fixed slot.
  double? _dragFraction;

  double _fractionForLevel(double level) {
    final int index = AppZoom.levels.indexOf(level);
    return index / (AppZoom.levels.length - 1);
  }

  double _levelForFraction(double fraction) {
    final int index = (fraction * (AppZoom.levels.length - 1)).round();
    return AppZoom.levels[index];
  }

  void _updateDragPosition(double localDx, double trackWidth) {
    final double fraction = (localDx / trackWidth).clamp(0.0, 1.0);
    setState(() => _dragFraction = fraction);
  }

  void _commitDrag() {
    final double? fraction = _dragFraction;
    setState(() => _dragFraction = null);
    if (fraction != null) {
      widget.onLevelChanged(_levelForFraction(fraction));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double displayedFraction =
        _dragFraction ?? _fractionForLevel(widget.currentLevel);
    final double displayedLevel = _dragFraction != null
        ? _levelForFraction(_dragFraction!)
        : widget.currentLevel;

    return Row(
      children: [
        const Icon(Icons.zoom_out, key: Key('zoom-control-zoom-out-icon')),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.spacing.lg),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Semantics(
                  label: t.settings.appearance.zoomLevelSemantics,
                  value: '${displayedLevel.toInt()}%',
                  child: GestureDetector(
                    key: const Key('zoom-control-track'),
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (DragStartDetails details) =>
                        _updateDragPosition(
                          details.localPosition.dx,
                          constraints.maxWidth,
                        ),
                    onPanUpdate: (DragUpdateDetails details) =>
                        _updateDragPosition(
                          details.localPosition.dx,
                          constraints.maxWidth,
                        ),
                    onPanEnd: (_) => _commitDrag(),
                    onTapDown: (TapDownDetails details) => _updateDragPosition(
                      details.localPosition.dx,
                      constraints.maxWidth,
                    ),
                    onTapUp: (_) => _commitDrag(),
                    child: SizedBox(
                      height: ZoomControlSizes.trackHeight,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            height: ZoomControlSizes.trackLineHeight,
                            color: colorScheme.outline,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (final double step in AppZoom.levels)
                                Container(
                                  key: Key('zoom-control-dot-${step.toInt()}'),
                                  width: ZoomControlSizes.dotSize,
                                  height: ZoomControlSizes.dotSize,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorScheme.outline,
                                  ),
                                ),
                            ],
                          ),
                          AnimatedPositioned(
                            duration: _dragFraction != null
                                ? Duration.zero
                                : const Duration(milliseconds: 320),
                            curve: Curves.easeOutBack,
                            left:
                                displayedFraction *
                                (constraints.maxWidth -
                                    ZoomControlSizes.thumbSize),
                            child: Container(
                              key: const Key('zoom-control-thumb'),
                              width: ZoomControlSizes.thumbSize,
                              height: ZoomControlSizes.thumbSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const Icon(Icons.zoom_in, key: Key('zoom-control-zoom-in-icon')),
      ],
    );
  }
}
