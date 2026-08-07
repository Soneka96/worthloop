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
  static const Duration _animationDuration = Duration(milliseconds: 600);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _animationDuration,
  );
  bool _started = false;
  bool _finished = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) {
      return;
    }
    _started = true;
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1;
      _finish();
    } else {
      _controller.forward().whenComplete(_finish);
    }
  }

  void _finish() {
    if (_finished) {
      return;
    }
    _finished = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onFinished();
      }
    });
  }

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
        backgroundColor: const Color(0xFF101827),
        body: Center(
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: _controller,
              curve: Curves.easeOutCubic,
            ),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.96, end: 1).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: Semantics(
                label: 'WorthLoop loading',
                child: Image.asset(
                  'assets/worthloop_mark.png',
                  width: 180,
                  height: 180,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
