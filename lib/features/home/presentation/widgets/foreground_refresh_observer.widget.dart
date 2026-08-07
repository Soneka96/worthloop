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

  /// Content that remains visible while observing app lifecycle changes.
  final Widget child;

  const ForegroundRefreshObserver({
    required this.interval,
    required this.onRefresh,
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
  DateTime _lastRefreshAt = DateTime.now();
  bool _isForeground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant ForegroundRefreshObserver oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.interval != widget.interval) {
      _startTimer();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isForeground = state == AppLifecycleState.resumed;
    if (_isForeground) {
      _refreshIfDue();
      _startTimer();
    } else {
      _timer?.cancel();
      _timer = null;
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
    if (DateTime.now().difference(_lastRefreshAt) < widget.interval) {
      return;
    }
    _lastRefreshAt = DateTime.now();
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
