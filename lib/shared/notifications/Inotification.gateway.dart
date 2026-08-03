// Project imports:
import 'package:worth_loop/shared/notifications/system_notification_service.dart';

/// The narrow slice of `local_notifier`'s API [SystemNotificationService]
/// needs. Exists so [SystemNotificationService] can be tested without a real
/// OS notification.
abstract interface class INotificationGateway {
  /// One-time setup — must be called before [show] or [close]. [appName] is
  /// what Windows registers the notification's Start Menu shortcut/AUMID
  /// under.
  Future<void> setup(String appName);

  /// Shows a notification with [title]/[body] and one button per label in
  /// [actionLabels]. [onClick] fires when the notification body itself is
  /// clicked; [onActionClicked] fires with the clicked button's index into
  /// [actionLabels]. Returns an identifier [close] can later use to dismiss
  /// this exact notification.
  Future<String> show({
    required String title,
    String? body,
    List<String> actionLabels,
    void Function()? onClick,
    void Function(int actionIndex)? onActionClicked,
  });

  /// Dismisses the notification previously returned by [show] via
  /// [identifier]. A no-op if it's already gone.
  Future<void> close(String identifier);
}
