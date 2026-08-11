// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

/// Refreshes the watchlist on a timer while the app is in the foreground.
class ForegroundRefreshObserver extends StatefulWidget {
  /// Interval between automatic refreshes.
  final Duration interval;

  /// Refreshes all tracked products.
  final VoidCallback onRefresh;

  /// Reconciles persisted results when the app returns to the foreground.
  final VoidCallback? onResume;

  /// Most recent persisted product update time.
  final DateTime? lastUpdatedAt;

  /// Content that remains visible while observing app lifecycle changes.
  final Widget child;

  const ForegroundRefreshObserver({
    required this.interval,
    required this.onRefresh,
    this.onResume,
    this.lastUpdatedAt,
    required this.child,
    super.key,
  });

  @override
  State<ForegroundRefreshObserver> createState() =>
      _ForegroundRefreshObserverState();
}

class _ForegroundRefreshObserverState extends State<ForegroundRefreshObserver>
    with WidgetsBindingObserver {
  Timer? _timer;
  DateTime? _lastRefreshAt;
  bool _isForeground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.lastUpdatedAt != null) {
      _refreshIfDue();
    }
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant ForegroundRefreshObserver oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool intervalChanged = oldWidget.interval != widget.interval;
    final bool lastUpdatedAtChanged =
        oldWidget.lastUpdatedAt != widget.lastUpdatedAt;
    if (lastUpdatedAtChanged && widget.lastUpdatedAt != null) {
      _refreshIfDue();
    }
    if (intervalChanged) {
      _startTimer();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isForeground = state == AppLifecycleState.resumed;
    if (_isForeground) {
      widget.onResume?.call();
      _refreshIfDue();
      _startTimer();
    } else {
      _timer?.cancel();
      _timer = null;
      _lastRefreshAt = null;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    if (!_isForeground || widget.interval <= Duration.zero) {
      return;
    }
    _timer = Timer.periodic(widget.interval, (_) => _refreshIfDue());
  }

  void _refreshIfDue() {
    if (!_isForeground || widget.interval <= Duration.zero) {
      return;
    }
    final DateTime now = DateTime.now();
    final DateTime? lastUpdatedAt = widget.lastUpdatedAt;
    final bool attemptIsDue =
        _lastRefreshAt == null ||
        now.difference(_lastRefreshAt ?? now) >= widget.interval;
    final bool dataIsStale =
        lastUpdatedAt != null &&
        now.difference(lastUpdatedAt) >= widget.interval;
    final bool refreshIsDue = lastUpdatedAt == null
        ? attemptIsDue
        : dataIsStale && attemptIsDue;
    if (!refreshIsDue) {
      return;
    }
    _lastRefreshAt = now;
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
