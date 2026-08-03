// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/presets/dark/catppuccin_mocha_theme.dart';
import 'package:worth_loop/shared/theme/presets/dark/default_dark_theme.dart';
import 'package:worth_loop/shared/theme/presets/dark/dracula_theme.dart';
import 'package:worth_loop/shared/theme/presets/dark/everforest_dark_theme.dart';
import 'package:worth_loop/shared/theme/presets/dark/gruvbox_dark_theme.dart';
import 'package:worth_loop/shared/theme/presets/dark/monokai_theme.dart';
import 'package:worth_loop/shared/theme/presets/dark/nord_theme.dart';
import 'package:worth_loop/shared/theme/presets/dark/one_dark_pro_theme.dart';
import 'package:worth_loop/shared/theme/presets/dark/rose_pine_theme.dart';
import 'package:worth_loop/shared/theme/presets/dark/slugger_dark_theme.dart';
import 'package:worth_loop/shared/theme/presets/dark/solarized_dark_theme.dart';
import 'package:worth_loop/shared/theme/presets/light/ayu_light_theme.dart';
import 'package:worth_loop/shared/theme/presets/light/catppuccin_latte_theme.dart';
import 'package:worth_loop/shared/theme/presets/light/default_light_theme.dart';
import 'package:worth_loop/shared/theme/presets/light/everforest_light_theme.dart';
import 'package:worth_loop/shared/theme/presets/light/github_light_theme.dart';
import 'package:worth_loop/shared/theme/presets/light/gruvbox_light_theme.dart';
import 'package:worth_loop/shared/theme/presets/light/one_light_theme.dart';
import 'package:worth_loop/shared/theme/presets/light/rose_pine_dawn_theme.dart';
import 'package:worth_loop/shared/theme/presets/light/slugger_light_theme.dart';
import 'package:worth_loop/shared/theme/presets/light/solarized_light_theme.dart';
import 'package:worth_loop/shared/theme/presets/light/tomorrow_theme.dart';

/// Maps every [ThemeId] to its [ColorScheme]. [ThemeId.none] falls back to
/// [defaultDarkColorScheme] — it's a sentinel value, not a real preset, so it
/// reuses the app's default rather than needing its own colours.
final Map<ThemeId, ColorScheme> themePresets = {
  ThemeId.none: defaultDarkColorScheme,
  ThemeId.defaultDark: defaultDarkColorScheme,
  ThemeId.defaultLight: defaultLightColorScheme,
  ThemeId.sluggerDark: sluggerDarkColorScheme,
  ThemeId.sluggerLight: sluggerLightColorScheme,
  ThemeId.dracula: draculaColorScheme,
  ThemeId.oneDarkPro: oneDarkProColorScheme,
  ThemeId.catppuccinLatte: catppuccinLatteColorScheme,
  ThemeId.nord: nordColorScheme,
  ThemeId.solarizedDark: solarizedDarkColorScheme,
  ThemeId.catppuccinMocha: catppuccinMochaColorScheme,
  ThemeId.everforestDark: everforestDarkColorScheme,
  ThemeId.gruvboxDark: gruvboxDarkColorScheme,
  ThemeId.monokai: monokaiColorScheme,
  ThemeId.rosePine: rosePineColorScheme,
  ThemeId.solarizedLight: solarizedLightColorScheme,
  ThemeId.everforestLight: everforestLightColorScheme,
  ThemeId.tomorrow: tomorrowColorScheme,
  ThemeId.ayuLight: ayuLightColorScheme,
  ThemeId.rosePineDawn: rosePineDawnColorScheme,
  ThemeId.gruvboxLight: gruvboxLightColorScheme,
  ThemeId.githubLight: githubLightColorScheme,
  ThemeId.oneLight: oneLightColorScheme,
};
