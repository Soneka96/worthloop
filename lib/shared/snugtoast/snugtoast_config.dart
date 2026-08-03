// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:worth_loop/shared/snugtoast/snugtoast.widget.dart';

/// Visual and timing configuration for one [SnugToast] — everything the
/// widget needs to render and behave, with no dependency on any specific
/// app's theme, router, or DI container.
class SnugToastConfig extends Equatable {
  /// The text shown inside the toast.
  final String message;

  /// Which corner/edge of the screen the toast anchors to.
  final Alignment alignment;

  /// How long the toast stays visible before it auto-dismisses.
  final Duration duration;

  /// The toast's fill color.
  final Color backgroundColor;

  /// The message text's color.
  final Color foregroundColor;

  /// The message text's font family. `null` uses the platform default.
  final String? fontFamily;

  /// The toast's border color.
  final Color borderColor;

  /// The toast's drop-shadow color.
  final Color shadowColor;

  /// The toast's corner radius.
  final double cornerRadius;

  /// The toast's maximum width — it hugs the message's own width up to
  /// this, then wraps onto more lines rather than stretching wider.
  final double maxWidth;

  /// The most lines the message wraps onto before truncating with an
  /// ellipsis.
  final int maxLines;

  /// How the message text aligns within its own line(s) — separate from
  /// [alignment], which positions the whole bubble on screen.
  final TextAlign textAlign;

  const SnugToastConfig({
    required this.message,
    this.alignment = Alignment.bottomCenter,
    this.duration = const Duration(seconds: 4),
    this.backgroundColor = const Color(0xFF323232),
    this.foregroundColor = Colors.white,
    this.fontFamily,
    this.borderColor = Colors.transparent,
    this.shadowColor = Colors.black26,
    this.cornerRadius = 8,
    this.maxWidth = 320,
    this.maxLines = 2,
    this.textAlign = TextAlign.start,
  });

  @override
  List<Object?> get props => [
    message,
    alignment,
    duration,
    backgroundColor,
    foregroundColor,
    fontFamily,
    borderColor,
    shadowColor,
    cornerRadius,
    maxWidth,
    maxLines,
    textAlign,
  ];
}
