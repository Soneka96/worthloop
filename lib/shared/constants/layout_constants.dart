// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/products/presentation/widgets/merchant_offer_row.widget.dart';
import 'package:worth_loop/features/settings/presentation/widgets/density_preview_rows.widget.dart';
import 'package:worth_loop/features/settings/presentation/widgets/settings_option_preview_card.widget.dart';
import 'package:worth_loop/features/settings/presentation/widgets/theme_card.widget.dart';
import 'package:worth_loop/features/settings/presentation/widgets/theme_card_preview.widget.dart';
import 'package:worth_loop/features/settings/presentation/widgets/zoom_control.widget.dart';
import 'package:worth_loop/shared/features/fading_scroll_view.widget.dart';
import 'package:worth_loop/shared/utils/popup_service.dart';

/// Cross-cutting icon-size constants — never an inline `size:` literal on an
/// [Icon].
abstract final class IconSizes {
  /// Small inline icon — e.g. a chevron beside a text link.
  static const double sm = 16;

  /// Standard icon — e.g. inside a button's `icon:` slot.
  static const double md = 18;
}

/// Cross-cutting popup sizing — never an inline width literal on a toast or
/// similar transient overlay.
abstract final class PopupSizes {
  /// Max width for [PopupService.show]'s toast content — a cap, not a fixed
  /// width, so a short message stays compact instead of stretching.
  static const double snackBarMaxWidth = 420;

  /// Max lines for [PopupService.show]'s toast content before it truncates
  /// with an ellipsis — generous enough that a typical status/error message
  /// never gets cut off.
  static const int snackBarMaxLines = 4;
}

/// Sizes for [ThemeCardPreview]'s miniature mock UI (header bar, accent dot,
/// body line, button bars) — one place to retune how that preview reads,
/// without touching unrelated sizes elsewhere.
abstract final class ThemePreviewSizes {
  /// The small circular accent dot in the mock header row.
  static const double accentDotSize = 10;

  /// The mock header bar's height (next to the accent dot).
  static const double headerBarHeight = 8;

  /// The mock body line's height.
  static const double bodyLineHeight = 6;

  /// The mock primary/secondary button bars' height.
  static const double buttonBarHeight = 22;
}

/// Shared preview-box height for Appearance settings' preset option cards
/// (corner style, density, ...) — kept as one constant so every option card
/// in a row reads as the same size regardless of what it's previewing;
/// changing it in one card without the other would make the row look
/// mismatched.
abstract final class SettingsOptionSizes {
  /// Preview box height, shared across every option card in a row.
  static const double previewHeight = 36;

  /// Height of each row in [DensityPreviewRows] — density is shown by how
  /// many of these fit inside [previewHeight], not by row size.
  static const double densityRowHeight = 3;
}

/// [FadingScrollView]'s scroll-view chrome.
abstract final class ScrollFadeSizes {
  /// Breathing room on every side of the scroll content.
  static const double gutter = 16;
}

/// Cross-cutting hairline-divider width — never an inline `width`/`height`
/// literal on a [Divider]/[VerticalDivider].
abstract final class DividerSizes {
  /// Width/height of a hairline [Divider]/[VerticalDivider].
  static const double hairline = 1;
}

/// Border width for a selectable card ([ThemeCard], [SettingsOptionPreviewCard])
/// — thicker when selected/active, so the state reads as emphasis rather
/// than just a colour change.
abstract final class SelectableCardBorders {
  /// Width when not the selected/active option.
  static const double regular = 1;

  /// Width when the selected/active option.
  static const double selected = 2;
}

/// Sizes for [MerchantOfferRow]'s quiet swipe-hint dot.
abstract final class MerchantOfferRowSizes {
  /// Diameter of the dot hinting the row can be swiped for edit/delete.
  static const double swipeHintDotSize = 6;
}

/// Sizes for [ZoomControl]'s track — the draggable thumb, the dot ticks, and
/// the background rail.
abstract final class ZoomControlSizes {
  /// Height of the whole track's tap/drag area.
  static const double trackHeight = 48;

  /// Diameter of each fixed level tick.
  static const double dotSize = 8;

  /// Diameter of the draggable thumb.
  static const double thumbSize = 14;

  /// Height of the background rail behind the ticks.
  static const double trackLineHeight = 2;
}
