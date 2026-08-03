// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/shared/snugtoast/snugtoast_config.dart';
import 'package:worth_loop/shared/snugtoast/snugtoast_wrapper.widget.dart';

/// Owns the stack of currently-visible toasts. Framework-agnostic — holds
/// no [BuildContext], no DI container, no app-specific types.
/// [SnugToastWrapper] listens to it to render the active toasts; callers
/// add one via [show].
class SnugToastManager extends ChangeNotifier {
  final List<({UniqueKey id, SnugToastConfig config})> _active = [];

  /// The toasts currently visible, oldest first.
  List<({UniqueKey id, SnugToastConfig config})> get active =>
      List.unmodifiable(_active);

  /// Adds [config] as a new visible toast.
  void show(SnugToastConfig config) {
    _active.add((id: UniqueKey(), config: config));
    notifyListeners();
  }

  /// Removes the toast identified by [id], if it's still active.
  void dismiss(UniqueKey id) {
    _active.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }
}
