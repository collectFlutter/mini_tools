import 'package:url_launcher/url_launcher.dart';

class UrlUtil {
  static bool isUrl(String url) {
    if (url == null || url.isEmpty) return false;
    return url.contains('http://') ||
        url.contains('https://') ||
        url.contains("ftp://");
  }

  /// 拨打号码
  static launchTel(String tel) {
    launch("tel:$tel");
  }

  static launchUrl(String urlString) {
    launch(urlString);
  }
}
