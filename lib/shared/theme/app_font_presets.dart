// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';

/// Maps every [FontId] to its font family name. `null` means the platform's
/// system default — [FontId.none] and [FontId.systemDefault] both skip the
/// override rather than needing a family of their own.
const Map<FontId, String?> fontFamilyPresets = {
  FontId.none: null,
  FontId.systemDefault: null,
  FontId.inter: 'Inter',
  FontId.jetBrainsMono: 'JetBrains Mono',
  FontId.bungee: 'Bungee',
  FontId.pacifico: 'Pacifico',
  FontId.permanentMarker: 'Permanent Marker',
  FontId.pressStart2p: 'Press Start 2P',
  FontId.monoton: 'Monoton',
  FontId.playfairDisplay: 'Playfair Display',
  FontId.oswald: 'Oswald',
  FontId.caveat: 'Caveat',
  FontId.spaceMono: 'Space Mono',
  FontId.firaCode: 'Fira Code',
  FontId.bangers: 'Bangers',
  FontId.creepster: 'Creepster',
  FontId.bebasNeue: 'Bebas Neue',
  FontId.amaticSc: 'Amatic SC',
  FontId.abrilFatface: 'Abril Fatface',
};

/// [FontId.inter]'s x-height-to-em-square aspect (`sxHeight / unitsPerEm`
/// from its bundled file's `OS/2` table) — the reference every
/// [fontSizeFactorPresets] entry is normalized against. Inter is this app's
/// closest bundled match to a neutral system UI font (Segoe UI/San Francisco
/// sit close to the same ~0.52-0.55 range). Imported by
/// `tool/font_metrics.dart` so a new font's correction factor is computed
/// against this exact value rather than a re-typed copy.
const double referenceXHeightAspect = 1118 / 2048;

/// Per-font size correction so every [FontId] reads as roughly the same
/// perceived size at a given Text Size setting, despite wildly different
/// x-height-to-em ratios — a blocky display face like [FontId.pressStart2p]
/// (aspect 0.75) reads far bigger than a script face like [FontId.caveat]
/// (aspect 0.40) at the same nominal font size. Same idea as CSS's
/// `font-size-adjust`, which Flutter has no built-in equivalent for (see
/// flutter/flutter#150072) — each value here is
/// `referenceXHeightAspect / thisFont'sXHeightAspect`, measured directly from
/// the bundled files' `OS/2` table via `tool/font_metrics.dart`, rounded to 2
/// decimals. `1` means no correction — either no bundled file
/// ([FontId.none]/[FontId.systemDefault]) or already at the reference
/// ([FontId.inter] itself).
const Map<FontId, double> fontSizeFactorPresets = {
  FontId.none: 1,
  FontId.systemDefault: 1,
  FontId.inter: 1,
  FontId.jetBrainsMono: 0.99,
  FontId.bungee: 1.09,
  FontId.pacifico: 1.19,
  FontId.permanentMarker: 0.89,
  FontId.pressStart2p: 0.73,
  FontId.monoton: 0.78,
  FontId.playfairDisplay: 1.06,
  FontId.oswald: 0.94,
  FontId.caveat: 1.36,
  FontId.spaceMono: 1.1,
  FontId.firaCode: 1.04,
  FontId.bangers: 0.76,
  FontId.creepster: 0.74,
  FontId.bebasNeue: 0.78,
  FontId.amaticSc: 0.83,
  FontId.abrilFatface: 1.15,
};

/// Applies [fontId]'s family to every slot in [base], preserving each slot's
/// size/weight/colour. [FontId.systemDefault] (and the [FontId.none]
/// sentinel) return [base] unchanged.
///
/// [fontSizeFactorPresets]' correction is deliberately NOT applied here —
/// [base]'s slots still have a `null` `fontSize` at this point (Flutter only
/// fills in real sizes later, via `MaterialApp`'s locale-based geometry
/// merge), and [TextTheme.apply]'s `fontSizeFactor` asserts on a `null` size
/// for any factor other than `1.0`. The correction is applied instead as a
/// multiplier on the app-wide [TextScaler] in `main.dart`, alongside the
/// "Text Size" zoom level — that layer sees the fully-resolved font size at
/// render time, not this static, not-yet-merged [TextTheme].
TextTheme applyFontFamily(TextTheme base, FontId fontId) {
  final String? family = fontFamilyPresets[fontId];
  if (family == null) {
    return base;
  }
  return base.apply(fontFamily: family);
}
