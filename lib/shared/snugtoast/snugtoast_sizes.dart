// Project imports:
import 'package:worth_loop/shared/snugtoast/snugtoast.widget.dart';
import 'package:worth_loop/shared/snugtoast/snugtoast_config.dart';
import 'package:worth_loop/shared/snugtoast/snugtoast_wrapper.widget.dart';

/// Fixed visual/timing constants for [SnugToast] and [SnugToastWrapper] —
/// the things every toast looks/behaves the same way, as opposed to
/// [SnugToastConfig]'s per-toast options.
abstract final class SnugToastSizes {
  /// Horizontal padding around the message inside the toast bubble.
  static const double horizontalPadding = 16;

  /// Vertical padding around the message inside the toast bubble.
  static const double verticalPadding = 12;

  /// Width of the toast bubble's border.
  static const double borderWidth = 1;

  /// Blur radius for the toast's drop shadow.
  static const double shadowBlurRadius = 12;

  /// Vertical offset for the toast's drop shadow.
  static const double shadowOffsetY = 4;

  /// Distance the toast layer keeps from the screen's edges.
  static const double edgeMargin = 12;

  /// Gap between stacked toasts sharing the same alignment.
  static const double stackSpacing = 8;

  /// Duration of the fade in/out transition.
  static const Duration fadeDuration = Duration(milliseconds: 200);
}
