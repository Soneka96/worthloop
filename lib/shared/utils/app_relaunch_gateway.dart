// Dart imports:
import 'dart:io';

// Project imports:
import 'package:worth_loop/shared/utils/Iapp_relaunch.gateway.dart';

/// Delegates to `dart:io`'s real process-spawning API.
class AppRelaunchGateway implements IAppRelaunchGateway {
  @override
  Future<void> relaunch() async {
    await Process.start(
      Platform.resolvedExecutable,
      [],
      mode: ProcessStartMode.detached,
    );
  }
}
