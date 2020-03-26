import 'package:flutter/services.dart';

class StringUtil {
  /// 对象是否为空
  static bool isEmpty(Object value) {
    if (value == null) return true;
    return value is String && value.isEmpty;
  }

  /// 复制内容到剪切板
  static clip(String content) {
    Clipboard.setData(ClipboardData(text: content ?? ""));
  }
}
