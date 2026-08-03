import 'dart:io';

/// Copies tool/pre-commit into .git/hooks so it runs on every commit.
/// Run once after cloning: dart run tool/install_hooks.dart
void main() {
  final source = File('tool/pre-commit');
  final dest = File('.git/hooks/pre-commit');
  dest.writeAsBytesSync(source.readAsBytesSync());
  if (!Platform.isWindows) {
    Process.runSync('chmod', ['+x', dest.path]);
  }
  // ignore: avoid_print
  print('Installed pre-commit hook.');
}
