import 'dart:convert' as convert;

class L {
  static int _level = 1;
  static String _tag = '==flutter==';

  /// 日志初始化
  /// [isDebug] - 是否是debug模式，是的情况下[level]会被设置为1<br/>
  /// [tag] - 日志 TAG <br/>
  /// [level] - 日志显示的最小等级，当[isDebug]同时存在时，以[level]优先<br/>
  static void init({
    bool isDebug = false,
    String tag = '==flutter==',
    int level,
  }) {
    L._level = level ?? isDebug ? 1 : 4;
    L._tag = tag;
  }

  /// 打印json数据
  static json(String msg, {String tag}) {
    var data = convert.json.decode(msg);
    if (data is Map) {
      _printMap(data);
    } else if (data is List) {
      _printList(data);
    } else
      v(msg, tag: tag);
  }

  /// Verbose就是冗长啰嗦的。通常表达开发调试过程中的一些详细信息，
  static void v(Object object, {String tag}) {
    if (_level <= 1) {
      _print(tag, '【V】', object);
    }
  }



  /// Debug来表达调试信息
  static void d(Object object, {String tag}) {
    if (_level <= 2) {
      _print(tag, '【D】', object);
    }
  }

  /// Info来表达一些信息
  static void i(Object object, {String tag}) {
    if (_level <= 3) {
      _print(tag, '【I】', object);
    }
  }

  /// Warning表示警告，但不一定会马上出现错误，开发时有时用来表示特别注意的地方。
  static void w(Object object, {String tag}) {
    if (_level <= 4) {
      _print(tag, '【W】', object);
    }
  }

  /// Error 出现错误，是最需要关注解决的。
  static void e(Object object, {String tag}) {
    if (_level <= 5) {
      _print(tag, '【E】', object);
    }
  }

  // https://github.com/Milad-Akarie/pretty_dio_logger
  static void _printMap(Map data,
      {String tag, int tabs = 1, bool isListItem = false, bool isLast = false}) {
    final bool isRoot = tabs == 1;
    final initialIndent = _indent(tabs);
    tabs++;
    if (isRoot || isListItem) v('$initialIndent{', tag: tag);

    data.keys.toList().asMap().forEach((index, key) {
      final isLast = index == data.length - 1;
      var value = data[key];
      if (value is String) value = '\"$value\"';
      if (value is Map) {
        if (value.length == 0)
          v('${_indent(tabs)} $key: $value${!isLast ? ',' : ''}', tag: tag);
        else {
          v('${_indent(tabs)} $key: {', tag: tag);
          _printMap(value, tabs: tabs);
        }
      } else if (value is List) {
        if (value.length == 0) {
          v('${_indent(tabs)} $key: ${value.toString()}', tag: tag);
        } else {
          v('${_indent(tabs)} $key: [', tag: tag);
          _printList(value, tabs: tabs);
          v('${_indent(tabs)} ]${isLast ? '' : ','}', tag: tag);
        }
      } else {
        final msg = value.toString().replaceAll('\n', '');
        v('${_indent(tabs)} $key: $msg${!isLast ? ',' : ''}', tag: tag);
      }
    });

    v('$initialIndent}${isListItem && !isLast ? ',' : ''}', tag: tag);
  }

  static void _printList(List list, {String tag, int tabs = 1}) {
    list.asMap().forEach((i, e) {
      final isLast = i == list.length - 1;
      if (e is Map) {
        if (e.length == 0)
          v('${_indent(tabs)}  $e${!isLast ? ',' : ''}', tag: tag);
        else
          _printMap(e, tabs: tabs + 1, isListItem: true, isLast: isLast);
      } else
        v('${_indent(tabs + 2)} $e${isLast ? '' : ','}', tag: tag);
    });
  }

  static void _print(String tag, String stag, Object object) {
    String _content = object.toString();
    String _tag = tag ?? L._tag;
    while (_content.isNotEmpty) {
      if (_content.length > 512) {
        print("$_tag $stag ${_content.substring(0, 512)}");
        _content = _content.substring(512, _content.length);
      } else {
        print("$tag $stag $_content");
        _content = "";
      }
    }
  }

  static String _indent([int tabCount = 1]) => '  ' * tabCount;
}
