// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/snugtoast/snugtoast.dart';
import 'package:worth_loop/shared/theme/app_font.dart';
import 'package:worth_loop/shared/theme/app_font_presets.dart';
import 'package:worth_loop/shared/theme/app_shape.dart';
import 'package:worth_loop/shared/theme/app_theme.dart';

/// Shows app-wide popups (toasts) via [SnugToastManager]. App-wide plumbing
/// with no business rule behind it — registered via DI, injected into
/// middleware only. Requires a [SnugToastWrapper] above the app root (see
/// `main.dart`) so [show] can reach whichever screen is currently visible
/// without a [BuildContext].
class PopupService {
  /// Shows [message] as a toast anchored to [location] (bottom-center by
  /// default), for 4 seconds.
  void show(
    String message, {
    WidgetLocation location = WidgetLocation.bottomCenter,
  }) {
    final ColorScheme colorScheme = sl<AppTheme>().colorScheme;
    final double cornerRadius = sl<AppShape>().cornerRadius;

    sl<SnugToastManager>().show(
      SnugToastConfig(
        message: message,
        alignment: location.alignment,
        duration: const Duration(seconds: 4),
        backgroundColor: colorScheme.surfaceContainerHighest,
        foregroundColor: colorScheme.onSurface,
        fontFamily: fontFamilyPresets[sl<AppFont>().fontId],
        borderColor: colorScheme.outline,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.3),
        cornerRadius: cornerRadius,
        maxWidth: PopupSizes.snackBarMaxWidth,
        maxLines: PopupSizes.snackBarMaxLines,
        textAlign: TextAlign.center,
      ),
    );
  }
}
