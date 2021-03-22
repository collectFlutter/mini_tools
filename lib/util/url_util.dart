import 'package:url_launcher/url_launcher.dart';

class UrlUtil {
  static bool isUrl(String url) => isHttp(url) || isHttps(url) || isFtp(url);

  static bool isHttp(String url) =>
      url != null && url.toLowerCase().contains("http://");

  static bool isHttps(String url) =>
      url != null && url.toLowerCase().contains("https://");

  static bool isFtp(String url) =>
      url != null && url.toLowerCase().contains("ftp://");

  /// 拨打号码
  static launchTel(String tel) => launch("tel:$tel");

  static launchUrl(String urlString) => launch(urlString);
}
