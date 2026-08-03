// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:window_manager/window_manager.dart';

// Project imports:
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/notifications/system_notification_service.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/window/Iwindow.gateway.dart';
import 'package:worth_loop/shared/window/home_window_size_service.dart';

/// Switches the app window between Home's fixed size and a normal, resizable
/// window restored to the user's last-used size.
class WindowController with WindowListener {
  /// Where window calls are delegated.
  final IWindowGateway _gateway;

  /// Where the last window size is persisted.
  final AppPreferencesStore _store;

  /// Where [lockHome] reads Home's fixed window size.
  final HomeWindowSizeService _homeWindowSizeService;

  /// Dismissed on [onWindowClose] — a stale notification could otherwise
  /// still be sitting in the Action Center after the app has quit.
  final SystemNotificationService _notificationService;

  WindowController(
    this._gateway,
    this._store,
    this._homeWindowSizeService,
    this._notificationService,
  ) {
    _gateway.addListener(this);
    _gateway.setPreventClose(true);
    _gateway.setMinimumSize(_minWindowSize);
  }

  /// Below this in either dimension, a size can't be a real restored window —
  /// it's the OS's minimized placement (Windows reports something like
  /// 156x35 while minimized, nowhere close to a usable window). Guards every
  /// place geometry enters the system: caching it, persisting it, and
  /// reading it back — a bad value already on disk from before this guard
  /// existed must be rejected too, not just prevented from recurring. Distinct
  /// from [_minWindowSize]: this is a "could this even be a real size" floor,
  /// not "is this actually usable."
  static const double _minValidDimension = 200;

  /// The smallest size the user can resize the (non-Home) window to —
  /// enforced natively via [IWindowGateway.setMinimumSize] in the
  /// constructor. Sized for the Settings screen, not Home (Home is much
  /// smaller — see [HomeWindowSizeService.shippedDefault]): enough to keep
  /// [SettingsSizes.sidebarWidth] (220) and a readable content pane both
  /// visible — not just "not the OS's minimized-placement sentinel" like
  /// [_minValidDimension] is.
  static const Size _minWindowSize = Size(600, 400);

  /// Whether Home is the currently active screen — gates whether
  /// [onWindowClose] persists the current geometry as "last used" (Home's
  /// fixed geometry must never overwrite it).
  bool _isHomeActive = false;

  /// The last known non-Home geometry, kept in sync via [onWindowResized]/
  /// [onWindowMoved]. [onWindowClose] persists this instead of a live query
  /// when the window is minimized — a minimized window's real
  /// [IWindowGateway.getSize]/[IWindowGateway.getPosition] report the OS's
  /// minimized placement, not the size it should restore to.
  Size? _lastKnownSize;
  Offset? _lastKnownPosition;

  /// The gap between [IWindowGateway.getSize] (the OUTER window rect —
  /// Win32 `GetWindowRect`) and [IWindowGateway.getContentSize] (what
  /// Flutter's view actually reports) — the title bar/border chrome that
  /// [IWindowGateway.setBounds] doesn't account for on its own.
  /// [HomeWindowSizeService.homeSize] is a CONTENT size, so this must be
  /// added before it's usable as a [IWindowGateway.setBounds]/
  /// [IWindowGateway.getCenteredPosition] argument, both of which work in
  /// outer-rect terms. A fixed OS/DPI constant regardless of the window's
  /// current size, so measuring once and caching is safe.
  Size? _frameOverhead;

  /// `window_manager`'s native Windows `SetBounds` converts a logical size to
  /// physical pixels via `static_cast<int>(logical * devicePixelRatio)` — a
  /// truncation, not a round. Converting back (physical / devicePixelRatio)
  /// consistently yields a logical size a fraction of a pixel SMALLER than
  /// requested (e.g. at a 1.3 device pixel ratio, requesting 498.6 truncates
  /// to 648 physical px, which is only 498.46 logical px back — a real,
  /// reproducible ~0.1-0.2px shortfall, confirmed via `flutter run`'s render
  /// dumps always showing the exact same small overflow regardless of
  /// content). Padding the requested size by a pixel invisibly absorbs that
  /// native truncation loss instead of trying to out-compute it.
  static const double _nativeRoundingSafetyMargin = 1.0;

  /// Locks the window to a fixed, always-centered, non-resizable size — used
  /// while Home is the active screen. Persists the last known non-Home
  /// geometry first — otherwise a crash or forced kill while sitting on Home
  /// would lose whatever was last set, since only a clean [onWindowClose]
  /// would have persisted it. Only writes anything once real (non-Home)
  /// usage has actually populated [_lastKnownSize]/[_lastKnownPosition] —
  /// the very first launch calls this before Home is ever left, and must
  /// not overwrite the saved preference with the app's arbitrary cold-boot
  /// size.
  Future<void> lockHome() async {
    await _persistGeometry(_lastKnownSize, _lastKnownPosition);
    _isHomeActive = true;
    await _gateway.setResizable(false);
    await _gateway.setMaximizable(false);
    final Size contentSize = _homeWindowSizeService.homeSize;
    final Size overhead = await _getFrameOverhead();
    final Size outerSize = Size(
      contentSize.width + overhead.width + _nativeRoundingSafetyMargin,
      contentSize.height + overhead.height + _nativeRoundingSafetyMargin,
    );
    final Offset position = await _gateway.getCenteredPosition(outerSize);
    final Rect targetBounds = Rect.fromLTWH(
      position.dx,
      position.dy,
      outerSize.width,
      outerSize.height,
    );
    await _gateway.setBounds(targetBounds);
  }

  Future<Size> _getFrameOverhead() async {
    if (_frameOverhead != null) {
      return _frameOverhead!;
    }
    final Size outerSize = await _gateway.getSize();
    final Size contentSize = _gateway.getContentSize();
    _frameOverhead = Size(
      outerSize.width - contentSize.width,
      outerSize.height - contentSize.height,
    );
    return _frameOverhead!;
  }

  /// Unlocks the window and restores the user's last-used size/position —
  /// used once navigation leaves Home. Falls back to maximized when nothing
  /// has been saved yet.
  Future<void> unlockAndRestore() async {
    _isHomeActive = false;
    await _gateway.setResizable(true);
    await _gateway.setMaximizable(true);
    final Size? lastSize = await _store.readWindowSize();
    final Offset? lastPosition = await _store.readWindowPosition();
    if (lastSize != null && lastPosition != null && _isValidSize(lastSize)) {
      await _gateway.setBounds(
        Rect.fromLTWH(
          lastPosition.dx,
          lastPosition.dy,
          lastSize.width,
          lastSize.height,
        ),
      );
    } else {
      await _gateway.maximize();
    }
  }

  bool _isValidSize(Size size) =>
      size.width >= _minValidDimension && size.height >= _minValidDimension;

  // Only cached while Home isn't active, so Home's fixed size never becomes
  // the "last used" geometry restored elsewhere. Maximize/unmaximize fire
  // their own events, separate from resize/move — window_manager does not
  // treat clicking the maximize button as a resize.
  @override
  void onWindowResized() => _cacheCurrentGeometry();

  @override
  void onWindowMoved() => _cacheCurrentGeometry();

  @override
  void onWindowMaximize() => _cacheCurrentGeometry();

  @override
  void onWindowUnmaximize() => _cacheCurrentGeometry();

  Future<void> _cacheCurrentGeometry() async {
    if (_isHomeActive) {
      return;
    }
    final Size size = await _gateway.getSize();
    if (!_isValidSize(size)) {
      return;
    }
    _lastKnownSize = size;
    _lastKnownPosition = await _gateway.getPosition();
  }

  @override
  void onWindowClose() async {
    final bool shouldIntercept = await _gateway.isPreventClose();
    if (!shouldIntercept) {
      return;
    }
    if (!_isHomeActive) {
      final bool isMinimized = await _gateway.isMinimized();
      final Size? size = isMinimized
          ? _lastKnownSize
          : await _gateway.getSize();
      final Offset? position = isMinimized
          ? _lastKnownPosition
          : await _gateway.getPosition();
      await _persistGeometry(size, position);
    }
    await _notificationService.closeActive();
    await _gateway.destroy();
  }

  // No cached geometry while minimized (e.g. minimized before any resize
  // ever happened), or a live query that's still an invalid size despite
  // isMinimized() reporting false, means nothing gets persisted —
  // readWindowSize()/readWindowPosition() then come back null next launch,
  // and unlockAndRestore() already falls back to maximize().
  Future<void> _persistGeometry(Size? size, Offset? position) async {
    if (size != null && position != null && _isValidSize(size)) {
      await _store.writeWindowSize(size);
      await _store.writeWindowPosition(position);
    }
  }
}
