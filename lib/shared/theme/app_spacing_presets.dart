// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Maps every [SpacingDensity] to a [VisualDensity]. [SpacingDensity.none]
/// falls back to [SpacingDensity.comfortable] — sentinel, not a real preset.
const Map<SpacingDensity, VisualDensity> spacingDensityPresets = {
  SpacingDensity.none: VisualDensity.standard,
  SpacingDensity.comfortable: VisualDensity.standard,
  SpacingDensity.compact: VisualDensity.compact,
};

/// Maps every [SpacingDensity] to its gap sizes. [SpacingDensity.none] falls
/// back to [AppSpacingThemeExtension.comfortable] — sentinel, not a real
/// preset.
const Map<SpacingDensity, AppSpacingThemeExtension> spacingValuePresets = {
  SpacingDensity.none: AppSpacingThemeExtension.comfortable,
  SpacingDensity.comfortable: AppSpacingThemeExtension.comfortable,
  SpacingDensity.compact: AppSpacingThemeExtension.compact,
};
