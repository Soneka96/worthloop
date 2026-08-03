// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/shared/snugtoast/snugtoast.widget.dart';
import 'package:worth_loop/shared/snugtoast/snugtoast_config.dart';
import 'package:worth_loop/shared/snugtoast/snugtoast_manager.dart';
import 'package:worth_loop/shared/snugtoast/snugtoast_sizes.dart';

/// Groups [manager]'s active toasts by [SnugToastConfig.alignment] and
/// stacks each group's toasts in a [Column], oldest first.
class SnugToastLayer extends StatelessWidget {
  /// The manager whose active toasts this layer renders.
  final SnugToastManager manager;

  const SnugToastLayer({super.key, required this.manager});

  @override
  Widget build(BuildContext context) {
    final Map<Alignment, List<({UniqueKey id, SnugToastConfig config})>>
    grouped = {};
    for (final entry in manager.active) {
      grouped.putIfAbsent(entry.config.alignment, () => []).add(entry);
    }

    return Stack(
      children: [
        for (final MapEntry(key: alignment, value: entries) in grouped.entries)
          Align(
            alignment: alignment,
            child: Padding(
              padding: const EdgeInsets.all(SnugToastSizes.edgeMargin),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < entries.length; i++) ...[
                    if (i > 0)
                      const SizedBox(height: SnugToastSizes.stackSpacing),
                    SnugToast(
                      key: ValueKey(entries[i].id),
                      config: entries[i].config,
                      onDismiss: () => manager.dismiss(entries[i].id),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
