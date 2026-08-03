// Package imports:
import 'package:logger/logger.dart';

// Project imports:
import 'package:worth_loop/shared/constants/app_constants.dart';
import 'package:worth_loop/shared/utils/popup_service.dart';

/// Wraps the `logger` package's [Logger] as the app's single log entry
/// point. App-wide plumbing with a business rule (`Level.fatal` alerts the
/// user) — registered via DI, called from middleware/usecases/repositories/
/// datasources/other services only, per `ai/context/architecture.md`'s
/// "Services" section.
class LoggerService {
  LoggerService(
    this._logger,
    this._popupService, {
    DateTime Function() now = DateTime.now,
  }) : _now = now;

  final Logger _logger;
  final PopupService _popupService;
  final DateTime Function() _now;
  final Map<String, DateTime> _lastAlertedAt = {};

  /// Logs [message] at debug severity. Alerts the user via [PopupService]
  /// when [showPopup] is `true`, subject to the same dedupe window as [f].
  void d(String message, {bool showPopup = false}) {
    _logger.d(message);
    if (showPopup) _alert(message);
  }

  /// Logs [message] at info severity. Alerts the user via [PopupService]
  /// when [showPopup] is `true`, subject to the same dedupe window as [f].
  void i(String message, {bool showPopup = false}) {
    _logger.i(message);
    if (showPopup) _alert(message);
  }

  /// Logs [message] at warning severity. Alerts the user via [PopupService]
  /// when [showPopup] is `true`, subject to the same dedupe window as [f].
  void w(String message, {bool showPopup = false}) {
    _logger.w(message);
    if (showPopup) _alert(message);
  }

  /// Logs [message] at error severity. Alerts the user via [PopupService]
  /// when [showPopup] is `true`, subject to the same dedupe window as [f].
  void e(String message, {bool showPopup = false}) {
    _logger.e(message);
    if (showPopup) _alert(message);
  }

  /// Logs [message] at fatal severity and always alerts the user via
  /// [PopupService] — the one severity where showing a popup isn't optional.
  void f(String message) {
    _logger.f(message);
    _alert(message);
  }

  /// Shows [message] via [PopupService], unless the same message already
  /// alerted within [AlertConstants.alertDedupeWindow].
  void _alert(String message) {
    final DateTime now = _now();
    final DateTime? lastAlertedAt = _lastAlertedAt[message];
    if (lastAlertedAt != null &&
        now.difference(lastAlertedAt) < AlertConstants.alertDedupeWindow) {
      return;
    }
    _lastAlertedAt[message] = now;
    _popupService.show(message);
  }
}
