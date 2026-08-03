// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/shared/snugtoast/snugtoast_config.dart';
import 'package:worth_loop/shared/snugtoast/snugtoast_sizes.dart';

/// Binary-searches the narrowest box width that holds the message to the
/// same line count it'd take at the full width — this is what balances
/// the wrapped lines, instead of just cramming the first one.
///
/// Must measure with the real [Text]'s text scale and its padding/border
/// chrome, or the computed width won't match what's actually painted.
double _balancedWidth({
  required String message,
  required TextStyle style,
  required double maxWidth,
  required int maxLines,
  required TextScaler textScaler,
  required double horizontalChrome,
}) {
  final double maxTextWidth = maxWidth - horizontalChrome;

  int lineCountAt(double width) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: message, style: style),
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout(maxWidth: width);
    return painter.computeLineMetrics().length;
  }

  final int naturalLines = lineCountAt(maxTextWidth);
  if (naturalLines <= 1 || naturalLines > maxLines) {
    return maxWidth;
  }

  double low = 0;
  double high = maxTextWidth;
  while (high - low > 1) {
    final double mid = (low + high) / 2;
    if (lineCountAt(mid) <= naturalLines) {
      high = mid;
    } else {
      low = mid;
    }
  }
  return high + horizontalChrome;
}

/// Resolved once so [_balancedWidth]'s measurement and the real paint use
/// the identical style — [Text] merges in [DefaultTextStyle] otherwise, so
/// measuring the unmerged style alone wraps at the wrong width.
TextStyle _resolveTextStyle(BuildContext context, SnugToastConfig config) {
  return DefaultTextStyle.of(context).style.merge(
    TextStyle(color: config.foregroundColor, fontFamily: config.fontFamily),
  );
}

/// A single toast bubble — hugs [SnugToastConfig.message]'s own width up to
/// [SnugToastConfig.maxWidth], fades in on mount, and fades out before
/// calling [onDismiss] (on tap, or once [SnugToastConfig.duration] elapses).
class SnugToast extends StatefulWidget {
  /// This toast's visual and timing configuration.
  final SnugToastConfig config;

  /// Called once the fade-out animation finishes — the caller should then
  /// stop rendering this toast.
  final VoidCallback onDismiss;

  const SnugToast({super.key, required this.config, required this.onDismiss});

  @override
  State<SnugToast> createState() => _SnugToastState();
}

class _SnugToastState extends State<SnugToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _autoDismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: SnugToastSizes.fadeDuration,
    )..forward();
    _autoDismissTimer = Timer(widget.config.duration, _dismiss);
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    _autoDismissTimer?.cancel();
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final SnugToastConfig config = widget.config;
    final TextStyle textStyle = _resolveTextStyle(context, config);
    final double boxWidth = _balancedWidth(
      message: config.message,
      style: textStyle,
      maxWidth: config.maxWidth,
      maxLines: config.maxLines,
      textScaler: MediaQuery.textScalerOf(context),
      horizontalChrome:
          SnugToastSizes.horizontalPadding * 2 + SnugToastSizes.borderWidth * 2,
    );
    return FadeTransition(
      opacity: _controller,
      child: GestureDetector(
        onTap: _dismiss,
        child: IntrinsicWidth(
          child: ConstrainedBox(
            key: const Key('snugtoast-bubble'),
            constraints: BoxConstraints(maxWidth: boxWidth),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SnugToastSizes.horizontalPadding,
                vertical: SnugToastSizes.verticalPadding,
              ),
              decoration: BoxDecoration(
                color: config.backgroundColor,
                borderRadius: BorderRadius.circular(config.cornerRadius),
                border: Border.all(
                  color: config.borderColor,
                  width: SnugToastSizes.borderWidth,
                ),
                boxShadow: [
                  BoxShadow(
                    color: config.shadowColor,
                    blurRadius: SnugToastSizes.shadowBlurRadius,
                    offset: const Offset(0, SnugToastSizes.shadowOffsetY),
                  ),
                ],
              ),
              child: Text(
                config.message,
                key: const Key('snugtoast-message'),
                maxLines: config.maxLines,
                overflow: TextOverflow.ellipsis,
                textAlign: config.textAlign,
                style: textStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
