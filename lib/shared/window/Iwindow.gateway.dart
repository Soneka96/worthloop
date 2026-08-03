// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:window_manager/window_manager.dart';

// Project imports:
import 'package:worth_loop/shared/window/window_controller.dart';

/// The narrow slice of `window_manager`'s API [WindowController] needs.
/// Exists so [WindowController] can be tested without a real OS window.
abstract interface class IWindowGateway {
  /// Allows or disallows the user resizing the window.
  Future<void> setResizable(bool isResizable);

  /// Allows or disallows the user manually maximizing the window — separate
  /// from [setResizable]; the native maximize control isn't disabled by it.
  Future<void> setMaximizable(bool isMaximizable);

  /// Prevents the user from resizing the window smaller than [size] —
  /// enforced natively, independent of [setResizable].
  Future<void> setMinimumSize(Size size);

  /// Reads the window's current size — the OUTER window rect (Win32
  /// `GetWindowRect`), including the title bar and borders. Not what's
  /// actually available to Flutter's content; see [getContentSize].
  Future<Size> getSize();

  /// Reads Flutter's own view size right now — the CONTENT area actually
  /// available to the widget tree, smaller than [getSize] by the title
  /// bar/border chrome. [setBounds] takes outer-rect dimensions (same
  /// terms as [getSize]), so a caller wanting an exact content size must
  /// add the difference between the two before calling it.
  Size getContentSize();

  /// Reads the window's current position.
  Future<Offset> getPosition();

  /// Moves and resizes the window in a single call.
  Future<void> setBounds(Rect bounds);

  /// Computes the position that centers a window of [size] on the current
  /// display.
  Future<Offset> getCenteredPosition(Size size);

  /// Maximizes the window to the current display's expanded bounds.
  Future<void> maximize();

  /// Whether the window is currently minimized. A minimized window's
  /// [getSize]/[getPosition] report the OS's minimized placement, not the
  /// size it will restore to — callers needing real geometry while this is
  /// `true` must use a previously cached value instead.
  Future<bool> isMinimized();

  /// Whether window-close requests are currently intercepted (see
  /// [setPreventClose]).
  Future<bool> isPreventClose();

  /// When `true`, a close request fires [WindowListener.onWindowClose]
  /// instead of closing the window immediately.
  Future<void> setPreventClose(bool isPreventClose);

  /// Hides the window without closing it — the window and its process are
  /// still alive, just not visible or in the taskbar. Unlike [close]/
  /// [destroy], this doesn't fire [WindowListener.onWindowClose] or end the
  /// process.
  Future<void> hide();

  /// Requests closing the window — respects [setPreventClose], rerouting to
  /// [WindowListener.onWindowClose] when it's `true`, unlike [destroy].
  Future<void> close();

  /// Closes the window immediately, bypassing [setPreventClose] — unlike
  /// [close].
  Future<void> destroy();

  /// Registers [listener] for window events (e.g. close requests).
  void addListener(WindowListener listener);

  /// Unregisters a listener added via [addListener].
  void removeListener(WindowListener listener);
}
