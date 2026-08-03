// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/theme_card.widget.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Miniature mock UI (header bar, accent dot, body line, primary/secondary
/// button) rendered in [colorScheme] — lets a theme's personality read at a
/// glance inside a [ThemeCard]. No border/background of its own — it sits
/// inside the same clickable box as the card header, so the whole thing
/// reads as one unit rather than two.
class ThemeCardPreview extends StatelessWidget {
  /// The theme preset's colors to render the mock UI in.
  final ColorScheme colorScheme;

  const ThemeCardPreview({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    // Same corner radius the app's real buttons/cards use — this preview
    // should reflect the current Corner style preset, not an unrelated
    // fixed value (see architecture.md's "Theming" section).
    final double cornerRadius = context.resolvedCornerRadius;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.spacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: ThemePreviewSizes.accentDotSize,
                height: ThemePreviewSizes.accentDotSize,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: context.spacing.sm),
              Expanded(
                child: Container(
                  height: ThemePreviewSizes.headerBarHeight,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: context.spacing.sm),
          Container(
            height: ThemePreviewSizes.bodyLineHeight,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: context.spacing.lg),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: ThemePreviewSizes.buttonBarHeight,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(cornerRadius),
                  ),
                ),
              ),
              SizedBox(width: context.spacing.sm),
              Expanded(
                child: Container(
                  height: ThemePreviewSizes.buttonBarHeight,
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.secondary),
                    borderRadius: BorderRadius.circular(cornerRadius),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
