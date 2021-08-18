import 'package:url_launcher/url_launcher.dart';

class UrlUtil {
  /// 拨打号码
  static launchTel(String tel) {
    launch("tel:$tel");
  }

  static launchUrl(String urlString) {
    launch(urlString);
  }
}
