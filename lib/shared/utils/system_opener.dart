// Dart imports:
import 'dart:io';

// Project imports:
import 'package:worth_loop/shared/utils/logger_service.dart';

/// Signature matching [Process.run] — overridable in tests.
typedef ProcessRunner =
    Future<ProcessResult> Function(String executable, List<String> arguments);

/// Signature matching [Directory.new] — overridable in tests.
typedef DirectoryFactory = Directory Function(String path);

/// Opens a folder in the OS file explorer. App-wide plumbing with no
/// business rule behind it — never `url_launcher`, per this project's
/// tech-stack convention.
class SystemOpener {
  final LoggerService _loggerService;
  final ProcessRunner _runProcess;
  final DirectoryFactory _directoryFactory;
  final String _operatingSystem;

  SystemOpener(
    this._loggerService, {
    ProcessRunner runProcess = Process.run,
    DirectoryFactory directoryFactory = Directory.new,
    String? operatingSystem,
  }) : _runProcess = runProcess,
       _directoryFactory = directoryFactory,
       _operatingSystem = operatingSystem ?? Platform.operatingSystem;

  /// Opens [path] in the platform's file explorer, creating it first if it
  /// doesn't exist yet — some platforms silently fall back to a default
  /// window for a missing path instead of raising an error. Logs and
  /// swallows any failure — best-effort UI convenience, nothing else to do
  /// if the OS can't open it.
  Future<void> openFolder(String path) async {
    final String executable = switch (_operatingSystem) {
      'windows' => 'explorer',
      'macos' => 'open',
      _ => 'xdg-open',
    };
    try {
      final Directory directory = _directoryFactory(path);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      await _runProcess(executable, [path]);
    } on ProcessException {
      _loggerService.w('SystemOpener could not open folder: $path');
    } on FileSystemException {
      _loggerService.w('SystemOpener could not create folder: $path');
    }
  }
}
