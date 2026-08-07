// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Provides native pull-to-refresh with contextual feedback for blocked pulls.
class PullToRefreshWidget extends StatefulWidget {
  /// Content that can be pulled to refresh.
  final Widget child;

  /// Starts a refresh when no refresh is already active.
  final Future<void> Function() onRefresh;

  /// Message shown in the pull area when a refresh is already active.
  final String? blockedMessage;

  const PullToRefreshWidget({
    required this.child,
    required this.onRefresh,
    required this.blockedMessage,
    super.key,
  });

  @override
  State<PullToRefreshWidget> createState() => _PullToRefreshWidgetState();
}

class _PullToRefreshWidgetState extends State<PullToRefreshWidget> {
  static const double _maxPullExtent = 72;

  double _pullExtent = 0;
  RefreshIndicatorStatus? _status;

  Future<void> _handleRefresh() async {
    if (widget.blockedMessage == null) {
      await widget.onRefresh();
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 900));
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (widget.blockedMessage == null ||
        notification.metrics.axis != Axis.vertical) {
      return false;
    }

    if (notification is OverscrollNotification &&
        notification.overscroll < 0 &&
        notification.metrics.pixels <= notification.metrics.minScrollExtent) {
      final double nextPullExtent = math.min(
        _maxPullExtent,
        _pullExtent - notification.overscroll,
      );
      if (nextPullExtent != _pullExtent) {
        setState(() => _pullExtent = nextPullExtent);
      }
    }

    return false;
  }

  void _handleStatusChange(RefreshIndicatorStatus? status) {
    if (_status == status) {
      return;
    }

    _status = status;
    if (status == RefreshIndicatorStatus.canceled ||
        status == RefreshIndicatorStatus.done) {
      setState(() => _pullExtent = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? blockedMessage = widget.blockedMessage;
    final Widget refreshIndicator = blockedMessage == null
        ? RefreshIndicator(onRefresh: _handleRefresh, child: widget.child)
        : RefreshIndicator.noSpinner(
            onRefresh: _handleRefresh,
            onStatusChange: _handleStatusChange,
            child: widget.child,
          );
    final bool showBlockedMessage =
        blockedMessage != null && _status != null && _pullExtent > 0;

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Stack(
        children: [
          Transform.translate(
            offset: Offset(0, _pullExtent),
            child: refreshIndicator,
          ),
          if (showBlockedMessage)
            Positioned(
              top: math.max(0, _pullExtent - context.spacing.xl),
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Center(
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      blockedMessage,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
