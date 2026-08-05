/// Every enum in the app lives here, regardless of which feature uses it.
library;

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';

/// Identifies a named colour-theme preset (e.g. Dracula, One Dark Pro).
enum ThemeId {
  /// Sentinel value — no theme selected.
  none,

  /// Default Dark — the template's neutral, unbranded default dark theme.
  defaultDark,

  /// Default Light — the template's neutral, unbranded default light theme.
  defaultLight,

  /// Slugger Dark — dark purple/space palette, kept from this template's
  /// origin project.
  sluggerDark,

  /// Slugger Light — warm coffee-and-cream palette, kept from this
  /// template's origin project.
  sluggerLight,

  /// Dracula — dark purple/grey palette with high-contrast accent colours.
  dracula,

  /// One Dark Pro — Atom/VS Code-style dark theme, blue-grey palette.
  oneDarkPro,

  /// Catppuccin Latte — light pastel palette.
  catppuccinLatte,

  /// Nord — arctic, muted blue-grey palette.
  nord,

  /// Solarized Dark — precision-engineered low-contrast palette.
  solarizedDark,

  /// Catppuccin Mocha — dark, soothing pastel palette.
  catppuccinMocha,

  /// Everforest Dark — green, forest-inspired palette.
  everforestDark,

  /// Gruvbox Dark — retro, warm-contrast palette.
  gruvboxDark,

  /// Monokai — classic high-saturation editor palette.
  monokai,

  /// Rosé Pine — dark, soho-vibes palette.
  rosePine,

  /// Solarized Light — precision-engineered low-contrast palette.
  solarizedLight,

  /// Everforest Light — green, forest-inspired palette.
  everforestLight,

  /// Tomorrow — clean, muted light palette.
  tomorrow,

  /// Ayu Light — bright, warm-accent palette.
  ayuLight,

  /// Rosé Pine Dawn — light, soho-vibes palette.
  rosePineDawn,

  /// Gruvbox Light — retro, warm-contrast palette.
  gruvboxLight,

  /// GitHub Light — GitHub's Primer design system default light palette.
  githubLight,

  /// One Light — Atom/VS Code-style light theme, blue-grey palette.
  oneLight,
}

/// Display helpers for [ThemeId] — kept off the enum itself so the enum
/// stays a plain set of values.
extension ThemeIdX on ThemeId {
  /// The preset's human-readable label in the theme picker.
  String get label => switch (this) {
    ThemeId.none => '',
    ThemeId.defaultDark => 'Default Dark',
    ThemeId.defaultLight => 'Default Light',
    ThemeId.sluggerDark => 'Slugger Dark',
    ThemeId.sluggerLight => 'Slugger Light',
    ThemeId.dracula => 'Dracula',
    ThemeId.oneDarkPro => 'One Dark Pro',
    ThemeId.catppuccinLatte => 'Catppuccin Latte',
    ThemeId.nord => 'Nord',
    ThemeId.solarizedDark => 'Solarized Dark',
    ThemeId.catppuccinMocha => 'Catppuccin Mocha',
    ThemeId.everforestDark => 'Everforest Dark',
    ThemeId.gruvboxDark => 'Gruvbox Dark',
    ThemeId.monokai => 'Monokai',
    ThemeId.rosePine => 'Rosé Pine',
    ThemeId.solarizedLight => 'Solarized Light',
    ThemeId.everforestLight => 'Everforest Light',
    ThemeId.tomorrow => 'Tomorrow',
    ThemeId.ayuLight => 'Ayu Light',
    ThemeId.rosePineDawn => 'Rosé Pine Dawn',
    ThemeId.gruvboxLight => 'Gruvbox Light',
    ThemeId.githubLight => 'GitHub Light',
    ThemeId.oneLight => 'One Light',
  };
}

/// Identifies a named corner-radius preset for buttons/cards.
enum CornerStyle {
  /// Sentinel value — no corner style selected.
  none,

  /// Soft rounded corners — the app's current default.
  rounded,

  /// Tight, near-rectangular corners.
  square,
}

/// Display helpers for [CornerStyle] — kept off the enum itself so the enum
/// stays a plain set of values.
extension CornerStyleX on CornerStyle {
  /// The style's label in the Appearance settings picker.
  String get label => switch (this) {
    CornerStyle.none => '',
    CornerStyle.rounded => t.enums.cornerStyle.rounded,
    CornerStyle.square => t.enums.cornerStyle.square,
  };
}

/// Controls the spatial density of the UI — how tightly elements are packed.
enum SpacingDensity {
  /// Sentinel value — no density selected.
  none,

  /// Default spacing — the app's comfortable layout density.
  comfortable,

  /// Compact spacing — reduced padding/margins for power users with small
  /// screens.
  compact,
}

/// Display helpers for [SpacingDensity] — kept off the enum itself so the
/// enum stays a plain set of values.
extension SpacingDensityX on SpacingDensity {
  /// The density's label in the Appearance settings picker.
  String get label => switch (this) {
    SpacingDensity.none => '',
    SpacingDensity.comfortable => t.enums.spacingDensity.comfortable,
    SpacingDensity.compact => t.enums.spacingDensity.compact,
  };

  /// How many preview rows represent this density in the picker — density is
  /// shown by how much fits in the same space, not by box size.
  int get previewRowCount => switch (this) {
    SpacingDensity.none => 3,
    SpacingDensity.comfortable => 3,
    SpacingDensity.compact => 5,
  };
}

/// Identifies a named font-family preset for the app's UI text.
enum FontId {
  /// Sentinel value — no font selected.
  none,

  /// The platform's default UI font — no override applied.
  systemDefault,

  /// Inter — clean, neutral grotesque sans-serif.
  inter,

  /// JetBrains Mono — monospace, fits an IDE-adjacent feel.
  jetBrainsMono,

  /// Bungee — bold urban/street-sign display face.
  bungee,

  /// Pacifico — flowing casual script.
  pacifico,

  /// Permanent Marker — handwritten marker style.
  permanentMarker,

  /// Press Start 2P — retro 8-bit pixel face.
  pressStart2p,

  /// Monoton — ultra-bold neon-tube display face.
  monoton,

  /// Playfair Display — dramatic high-contrast serif.
  playfairDisplay,

  /// Oswald — tall condensed sans.
  oswald,

  /// Caveat — casual handwriting.
  caveat,

  /// Space Mono — retro-futuristic monospace.
  spaceMono,

  /// Fira Code — ligature-friendly monospace.
  firaCode,

  /// Bangers — comic-book shout display face.
  bangers,

  /// Creepster — horror/spooky display face.
  creepster,

  /// Bebas Neue — tall condensed display face.
  bebasNeue,

  /// Amatic SC — thin hand-drawn condensed face.
  amaticSc,

  /// Abril Fatface — dramatic high-contrast serif display face.
  abrilFatface,
}

/// Display helpers for [FontId] — kept off the enum itself so the enum
/// stays a plain set of values.
extension FontIdX on FontId {
  /// The preset's human-readable label in the font picker.
  String get label => switch (this) {
    FontId.none => '',
    FontId.systemDefault => 'System Default',
    FontId.inter => 'Inter',
    FontId.jetBrainsMono => 'JetBrains Mono',
    FontId.bungee => 'Bungee',
    FontId.pacifico => 'Pacifico',
    FontId.permanentMarker => 'Permanent Marker',
    FontId.pressStart2p => 'Press Start 2P',
    FontId.monoton => 'Monoton',
    FontId.playfairDisplay => 'Playfair Display',
    FontId.oswald => 'Oswald',
    FontId.caveat => 'Caveat',
    FontId.spaceMono => 'Space Mono',
    FontId.firaCode => 'Fira Code',
    FontId.bangers => 'Bangers',
    FontId.creepster => 'Creepster',
    FontId.bebasNeue => 'Bebas Neue',
    FontId.amaticSc => 'Amatic SC',
    FontId.abrilFatface => 'Abril Fatface',
  };
}

/// Identifies which category of `AppSettingsScreen`'s content pane is shown.
enum SettingsCategory {
  /// Sentinel value — no category selected.
  none,

  /// General app preferences.
  general,

  /// Theme and zoom controls.
  appearance,
}

/// Display/behaviour helpers for [SettingsCategory] — kept off the enum
/// itself so the enum stays a plain set of values.
extension SettingsCategoryX on SettingsCategory {
  /// The category's label in the settings category list.
  String get label => switch (this) {
    SettingsCategory.none => '',
    SettingsCategory.general => t.enums.settingsCategory.general,
    SettingsCategory.appearance => t.enums.settingsCategory.appearance,
  };

  /// The category's icon in the settings category list.
  IconData get icon => switch (this) {
    SettingsCategory.none => Icons.circle_outlined,
    SettingsCategory.general => Icons.settings_outlined,
    SettingsCategory.appearance => Icons.palette_outlined,
  };

  /// Whether this category currently has content built for it.
  bool get isEnabled => _enabledCategories.contains(this);

  /// Categories with real content. Extend this set, not the comparison
  /// logic above, as more categories are built.
  static const Set<SettingsCategory> _enabledCategories = {
    SettingsCategory.general,
    SettingsCategory.appearance,
  };
}

/// Identifies which edge or corner of a widget something is anchored to.
enum WidgetLocation {
  /// Sentinel value — no location selected.
  none,

  /// Anchored to the top-left corner.
  topLeft,

  /// Anchored to the top edge, centered.
  topCenter,

  /// Anchored to the top-right corner.
  topRight,

  /// Anchored to the left edge, centered.
  centerLeft,

  /// Anchored to the exact center.
  center,

  /// Anchored to the right edge, centered.
  centerRight,

  /// Anchored to the bottom-left corner.
  bottomLeft,

  /// Anchored to the bottom edge, centered.
  bottomCenter,

  /// Anchored to the bottom-right corner.
  bottomRight,
}

/// Describes the result of attempting to read a product price.
enum PriceFetchStatus {
  /// No price request has completed.
  none,

  /// A usable price was extracted.
  success,

  /// The page does not expose supported product price data.
  unsupported,

  /// The website rejected or challenged the request.
  blocked,

  /// The request failed before usable response data was received.
  networkError,

  /// The response contained price data that could not be used.
  invalidData,
}

/// Display helpers for [WidgetLocation] — kept off the enum itself so the
/// enum stays a plain set of values.
extension WidgetLocationX on WidgetLocation {
  /// The [Alignment] a widget-positioning API (e.g. a toast package) expects
  /// for this location.
  Alignment get alignment => switch (this) {
    WidgetLocation.none => throw UnsupportedError(
      'WidgetLocation.none has no alignment — pick a real location',
    ),
    WidgetLocation.topLeft => Alignment.topLeft,
    WidgetLocation.topCenter => Alignment.topCenter,
    WidgetLocation.topRight => Alignment.topRight,
    WidgetLocation.centerLeft => Alignment.centerLeft,
    WidgetLocation.center => Alignment.center,
    WidgetLocation.centerRight => Alignment.centerRight,
    WidgetLocation.bottomLeft => Alignment.bottomLeft,
    WidgetLocation.bottomCenter => Alignment.bottomCenter,
    WidgetLocation.bottomRight => Alignment.bottomRight,
  };
}
