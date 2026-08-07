// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';

/// Provides pull-to-refresh with transient feedback when a refresh is blocked.
class ProductRefreshIndicator extends StatefulWidget {
  /// Content that can be pulled to refresh.
  final Widget child;

  /// Starts a refresh when no refresh is already active.
  final Future<void> Function() onRefresh;

  /// Message shown when the pull is blocked by an active refresh.
  final String? blockedMessage;

  const ProductRefreshIndicator({
    required this.child,
    required this.onRefresh,
    required this.blockedMessage,
    super.key,
  });

  @override
  State<ProductRefreshIndicator> createState() =>
      _ProductRefreshIndicatorState();
}

class _ProductRefreshIndicatorState extends State<ProductRefreshIndicator> {
  bool _showBlockedMessage = false;

  Future<void> _handleRefresh() async {
    if (widget.blockedMessage == null) {
      await widget.onRefresh();
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 900));
  }

  void _handleStatusChange(RefreshIndicatorStatus? status) {
    final bool shouldShow =
        status == RefreshIndicatorStatus.drag ||
        status == RefreshIndicatorStatus.armed ||
        status == RefreshIndicatorStatus.snap ||
        status == RefreshIndicatorStatus.refresh;
    if (_showBlockedMessage != shouldShow && mounted) {
      setState(() => _showBlockedMessage = shouldShow);
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
    return Stack(
      children: [
        refreshIndicator,
        if (_showBlockedMessage && blockedMessage != null)
          Positioned(
            top: context.spacing.lg,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Center(
                child: Material(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(
                    context.resolvedCornerRadius,
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.spacing.lg,
                      vertical: context.spacing.sm,
                    ),
                    child: Text(
                      blockedMessage,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
