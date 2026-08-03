// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/shared/snugtoast/snugtoast_layer.widget.dart';
import 'package:worth_loop/shared/snugtoast/snugtoast_manager.dart';

/// Renders [manager]'s active toasts above [child]. Place once, near the
/// root of the app (above the router/navigator), so a toast can reach the
/// user from any screen without needing a [BuildContext]. Establishes its
/// own [Directionality] rather than relying on one from further up the
/// tree — [child] (typically a `MaterialApp`) provides one for itself, but
/// the toast layer is this widget's sibling, not [child]'s descendant.
class SnugToastWrapper extends StatefulWidget {
  /// The rest of the app, rendered beneath the toast layer.
  final Widget child;

  /// The manager whose active toasts this wrapper renders.
  final SnugToastManager manager;

  const SnugToastWrapper({
    super.key,
    required this.child,
    required this.manager,
  });

  @override
  State<SnugToastWrapper> createState() => _SnugToastWrapperState();
}

class _SnugToastWrapperState extends State<SnugToastWrapper> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widget.child,
          ListenableBuilder(
            listenable: widget.manager,
            builder: (context, _) => SnugToastLayer(manager: widget.manager),
          ),
        ],
      ),
    );
  }
}
