// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/shared/constants/layout_constants.dart';

/// Preview content for a [SettingsOptionPreviewCard] density option — a
/// fixed-height box with [itemCount] evenly-spaced rows. Density is shown by
/// how many rows fit in that same space, not by how tall the box is, so
/// every density option reads at the same size.
class DensityPreviewRows extends StatelessWidget {
  /// How many evenly-spaced rows to render.
  final int itemCount;

  const DensityPreviewRows({super.key, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    final Color rowColor = Theme.of(context).colorScheme.onSurfaceVariant;
    return SizedBox(
      height: SettingsOptionSizes.previewHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          itemCount,
          (int index) => Container(
            height: SettingsOptionSizes.densityRowHeight,
            color: rowColor,
          ),
        ),
      ),
    );
  }
}
