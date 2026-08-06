import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A short branded transition between the native launch screen and the app.
class AppLaunchSplash extends StatefulWidget {
  final VoidCallback onFinished;

  const AppLaunchSplash({required this.onFinished, super.key});

  @override
  State<AppLaunchSplash> createState() => _AppLaunchSplashState();
}

class _AppLaunchSplashState extends State<AppLaunchSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1100),
        )
        ..forward().whenComplete(() {
          if (mounted) {
            widget.onFinished();
          }
        });

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B0B10),
        body: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final double entrance = Curves.easeOutCubic.transform(
                _controller.value,
              );
              final double sway = math.sin(_controller.value * math.pi * 2);
              return Opacity(
                opacity: entrance,
                child: Transform.translate(
                  offset: Offset(0, 12 * (1 - entrance) + sway * 2),
                  child: Transform.scale(
                    scale: 0.9 + entrance * 0.1 + sway * 0.012,
                    child: child,
                  ),
                ),
              );
            },
            child: Semantics(
              label: 'WorthLoop loading',
              child: Image.asset(
                'assets/launch_icon_alpha.png',
                width: 220,
                height: 220,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
