// Flutter imports:
import 'package:flutter/material.dart';

/// Holds Home's fixed window size. There is no live measurement in this
/// template — [homeSize] is always [shippedDefault], regardless of the
/// current font or spacing density.
class HomeWindowSizeService {
  /// The fixed width Home's content is measured against — preserved as the
  /// width:height aspect ratio for [shippedDefault].
  static const double referenceWidth = 560;
  static const double _aspectRatio = 560 / 420;

  /// A reasonable content height for Home's current design.
  static const double _defaultContentHeight = 200.0;

  /// The size derived from [_defaultContentHeight] — see its doc.
  static const Size shippedDefault = Size(
    _defaultContentHeight * _aspectRatio,
    _defaultContentHeight,
  );

  /// Home's fixed window size.
  Size get homeSize => shippedDefault;
}
