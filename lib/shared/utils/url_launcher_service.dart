// Package imports:
import 'package:url_launcher/url_launcher.dart' as url_launcher;

/// Opens external URLs in the device's default browser. App-wide plumbing
/// with no business rule behind it — registered via DI, called from
/// `ProductsMiddleware` only.
class UrlLauncherService {
  /// Opens [url] in the default browser, returning whether it succeeded.
  Future<bool> open(String url) async {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      return false;
    }
    try {
      return await url_launcher.launchUrl(
        uri,
        mode: url_launcher.LaunchMode.externalApplication,
      );
    } on Exception {
      return false;
    }
  }
}
