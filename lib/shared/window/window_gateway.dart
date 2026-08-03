// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:window_manager/window_manager.dart';

// Project imports:
import 'package:worth_loop/shared/window/Iwindow.gateway.dart';

/// Delegates to the real `window_manager` singleton.
class WindowGateway implements IWindowGateway {
  @override
  Future<void> setResizable(bool isResizable) =>
      windowManager.setResizable(isResizable);

  @override
  Future<void> setMaximizable(bool isMaximizable) =>
      windowManager.setMaximizable(isMaximizable);

  @override
  Future<void> setMinimumSize(Size size) => windowManager.setMinimumSize(size);

  @override
  Future<Size> getSize() => windowManager.getSize();

  @override
  Size getContentSize() {
    final FlutterView view = PlatformDispatcher.instance.views.first;
    return view.physicalSize / view.devicePixelRatio;
  }

  @override
  Future<Offset> getPosition() => windowManager.getPosition();

  @override
  Future<void> setBounds(Rect bounds) => windowManager.setBounds(bounds);

  @override
  Future<Offset> getCenteredPosition(Size size) =>
      calcWindowPosition(size, Alignment.center);

  @override
  Future<void> maximize() => windowManager.maximize();

  @override
  Future<bool> isMinimized() => windowManager.isMinimized();

  @override
  Future<bool> isPreventClose() => windowManager.isPreventClose();

  @override
  Future<void> setPreventClose(bool isPreventClose) =>
      windowManager.setPreventClose(isPreventClose);

  @override
  Future<void> hide() => windowManager.hide();

  @override
  Future<void> close() => windowManager.close();

  @override
  Future<void> destroy() => windowManager.destroy();

  @override
  void addListener(WindowListener listener) =>
      windowManager.addListener(listener);

  @override
  void removeListener(WindowListener listener) =>
      windowManager.removeListener(listener);
}
