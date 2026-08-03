// Package imports:
import 'package:local_notifier/local_notifier.dart';

// Project imports:
import 'package:worth_loop/shared/notifications/Inotification.gateway.dart';

/// Delegates to the real `local_notifier` singleton.
class NotificationGateway implements INotificationGateway {
  /// Keeps every shown notification alive by identifier — `local_notifier`
  /// needs the original object (not just its id) to close it later.
  final Map<String, LocalNotification> _notifications = {};

  @override
  Future<void> setup(String appName) =>
      LocalNotifier.instance.setup(appName: appName);

  @override
  Future<String> show({
    required String title,
    String? body,
    List<String> actionLabels = const [],
    void Function()? onClick,
    void Function(int actionIndex)? onActionClicked,
  }) async {
    final LocalNotification notification = LocalNotification(
      title: title,
      body: body,
      actions: actionLabels
          .map((text) => LocalNotificationAction(text: text))
          .toList(),
    );
    if (onClick != null) {
      notification.onClick = onClick;
    }
    if (onActionClicked != null) {
      notification.onClickAction = onActionClicked;
    }
    _notifications[notification.identifier] = notification;
    await notification.show();
    return notification.identifier;
  }

  @override
  Future<void> close(String identifier) async {
    final LocalNotification? notification = _notifications.remove(identifier);
    if (notification != null) {
      await notification.close();
    }
  }
}
