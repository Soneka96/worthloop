// Project imports:
import 'package:worth_loop/shared/notifications/Inotification.gateway.dart';

/// Shows OS-level notifications via [INotificationGateway] — app-wide
/// plumbing with no business rule of its own, registered via DI, called only
/// from middleware. Tracks the most recently shown notification so
/// [closeActive] can dismiss it — e.g. on a clean app shutdown, before a
/// stale notification could ever be clicked with the app no longer running.
class SystemNotificationService {
  final INotificationGateway _gateway;

  String? _activeIdentifier;

  SystemNotificationService(this._gateway);

  /// One-time setup — must be called before [show], before `runApp()`.
  Future<void> initialize() => _gateway.setup('Clean Architecture Starter');

  /// Shows a notification with [title]/[body] and one button per label in
  /// [actionLabels], closing whatever this service last showed first.
  /// [onClick] fires when the notification body itself is clicked;
  /// [onActionClicked] fires with the clicked button's index into
  /// [actionLabels].
  Future<void> show({
    required String title,
    String? body,
    List<String> actionLabels = const [],
    void Function()? onClick,
    void Function(int actionIndex)? onActionClicked,
  }) async {
    await closeActive();
    _activeIdentifier = await _gateway.show(
      title: title,
      body: body,
      actionLabels: actionLabels,
      onClick: onClick,
      onActionClicked: onActionClicked,
    );
  }

  /// Dismisses the notification last shown via [show], if any.
  Future<void> closeActive() async {
    final String? identifier = _activeIdentifier;
    if (identifier == null) {
      return;
    }
    _activeIdentifier = null;
    await _gateway.close(identifier);
  }
}
