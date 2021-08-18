import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

class SpUtil {
  static SpUtil? _singleton;
  static SharedPreferences? _prefs;
  static Lock _lock = Lock();

  static Future<SpUtil> getInstance() async {
    if (_singleton == null) {
      await _lock.synchronized(() async {
        if (_singleton == null) {
          // 保持本地实例直到完全初始化。
          var singleton = SpUtil._();
          await singleton._init();
          _singleton = singleton;
        }
      });
    }
    return _singleton!;
  }

  SpUtil._();

  Future _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// put object.
  static Future<bool> putObject(String key, Object? value) async {
    if (_prefs == null) return false;
    return await _prefs!
        .setString(key, value == null ? "" : json.encode(value));
  }

  /// get object.
  static Map? getObject(String key) {
    if (_prefs == null) return null;
    String? _data = _prefs!.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  /// put object list.
  static Future<bool> putObjectList(String key, List<Object>? list) async {
    if (_prefs == null) return false;
    List<String> _dataList =
        list?.map((value) => json.encode(value)).toList() ?? [];
    return await _prefs!.setStringList(key, _dataList);
  }

  /// get object list.
  static List<dynamic> getObjectList(String key) {
    if (_prefs == null) return [];
    List<String>? dataLis = _prefs!.getStringList(key);
    return dataLis?.map((value) => json.decode(value)).toList() ?? [];
  }

  /// get string.
  static String getString(String key, {String defValue: ''}) {
    if (_prefs == null) return defValue;
    return _prefs!.getString(key) ?? defValue;
  }

  /// put string.
  static Future<bool> putString(String key, String value) async {
    if (_prefs == null) return false;
    return await _prefs!.setString(key, value);
  }

  /// get bool.
  static bool getBool(String key, {bool defValue: false}) {
    return _prefs?.getBool(key) ?? defValue;
  }

  /// put bool.
  static Future<bool> putBool(String key, bool value) async {
    if (_prefs == null) return false;
    return await _prefs!.setBool(key, value);
  }

  /// get int.
  static int getInt(String key, {int defValue: 0}) {
    return _prefs?.getInt(key) ?? defValue;
  }

  /// put int.
  static Future<bool> putInt(String key, int value) async {
    if (_prefs == null) return false;
    return await _prefs!.setInt(key, value);
  }

  /// get double.
  static double getDouble(String key, {double defValue: 0.0}) {
    return _prefs?.getDouble(key) ?? defValue;
  }

  /// put double.
  static Future<bool> putDouble(String key, double value) async {
    if (_prefs == null) return false;
    return await _prefs!.setDouble(key, value);
  }

  /// get string list.
  static List<String> getStringList(String key,
      {List<String> defValue: const []}) {
    return _prefs?.getStringList(key) ?? defValue;
  }

  /// put string list.
  static Future<bool> putStringList(String key, List<String> value) async {
    if (_prefs == null) return false;
    return await _prefs!.setStringList(key, value);
  }

  /// get dynamic.
  static dynamic getDynamic(String key, {Object? defValue}) {
    return _prefs?.get(key) ?? defValue;
  }

  /// have key.
  static bool haveKey(String key) {
    if (_prefs == null) return false;
    return _prefs!.getKeys().contains(key);
  }

  /// get keys.
  static Set<String> getKeys() {
    if (_prefs == null) return Set();
    return _prefs!.getKeys();
  }

  /// remove.
  static Future<bool> remove(String key) async {
    if (_prefs == null) return false;
    return await _prefs!.remove(key);
  }

  /// clear.
  static Future<bool> clear() async {
    if (_prefs == null) return false;
    return await _prefs!.clear();
  }

  ///Sp is initialized.
  static bool isInitialized() {
    return _prefs != null;
  }
}
