// Dart imports:
import 'dart:async';

/// Runs refreshes on a schedule while allowing immediate manual wake-ups.
class BackgroundRefreshLoop {
  final Future<Duration?> Function() _runOnce;
  final Future<Duration?> Function()? _runManualOnce;

  bool _manualRefreshRequested = false;
  Completer<void>? _wakeSignal;
  bool _isRunning = false;

  /// Creates a serialized refresh loop around [runOnce].
  BackgroundRefreshLoop({
    required Future<Duration?> Function() runOnce,
    Future<Duration?> Function()? runManualOnce,
  }) : _runOnce = runOnce,
       _runManualOnce = runManualOnce;

  /// Requests one refresh as soon as the current refresh finishes.
  void requestRefresh() {
    _manualRefreshRequested = true;
    final Completer<void>? wakeSignal = _wakeSignal;
    if (wakeSignal != null && !wakeSignal.isCompleted) {
      wakeSignal.complete();
    }
  }

  /// Runs until [runOnce] returns `null`.
  Future<void> run() async {
    if (_isRunning) {
      return;
    }

    _isRunning = true;
    try {
      while (true) {
        final bool isManualRefresh = _manualRefreshRequested;
        _manualRefreshRequested = false;
        final Duration? nextDelay = isManualRefresh && _runManualOnce != null
            ? await _runManualOnce()
            : await _runOnce();
        if (nextDelay == null) {
          return;
        }
        await _waitForNextRefresh(nextDelay);
      }
    } finally {
      _isRunning = false;
    }
  }

  Future<void> _waitForNextRefresh(Duration delay) async {
    if (_manualRefreshRequested) {
      return;
    }

    final Completer<void> wakeSignal = Completer<void>();
    _wakeSignal = wakeSignal;
    if (_manualRefreshRequested) {
      _wakeSignal = null;
      return;
    }

    try {
      await Future.any<void>([Future<void>.delayed(delay), wakeSignal.future]);
    } finally {
      if (identical(_wakeSignal, wakeSignal)) {
        _wakeSignal = null;
      }
    }
  }
}
