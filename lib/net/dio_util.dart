import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'response_model.dart';
import 'package:mini_logger/mini_logger.dart';

class DioUtil {
  static Dio _dio;

  /// 创建dio对象，请求参数发生变化，需重新创建
  static Dio _createDio({
    ContentType contentType,
    String baseUrl,
    Map<String, dynamic> header,
    int connectTimeout = 10000,
    int receiveTimeout = 100000,
  }) {
    bool flag = _dio == null ||
        (contentType != null &&
            _dio.options.contentType != contentType.subType) ||
        (baseUrl != null && _dio.options.baseUrl != baseUrl) ||
        (baseUrl != null && _dio.options.connectTimeout != connectTimeout) ||
        (baseUrl != null && _dio.options.receiveTimeout != receiveTimeout);
    // 请求头
    if (!flag && header != null) {
      if (_dio.options.headers == null) {
        flag = true;
      } else {
        if (_dio.options.headers.length != header.length) {
          flag = true;
        } else {
          _dio.options.headers.forEach((key, value) {
            flag = flag || (header[key] != value);
          });
        }
      }
    }
    if (flag) {
      BaseOptions options = BaseOptions(
          baseUrl: baseUrl ?? '',
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          contentType: contentType?.subType,
          headers: header ?? {},
          responseType: ResponseType.plain);
      _dio = Dio(options);
    }
    return _dio;
  }

  /// [path]-请求的地址，[data]-请求的数据
  static Future<ResponseModel> get(
    String path, {
    Map<String, dynamic> data,
    CancelToken cancelToken,
    ContentType contentType,
    String baseUrl,
    Map<String, dynamic> header,
    int connectTimeout = 3000,
    int receiveTimeout = 100000,
    bool printLog = true,
  }) async {
    DateTime _startTime = DateTime.now();
    Response response;
    StringBuffer _log = StringBuffer("\n======= Get请求 ======");
    _log..write('\n')..write("【URL】:$baseUrl$path");
    _log..write('\n')..write("【Header】:${jsonEncode(header)}");
    if (data != null) {
      _log..write('\n')..write('【Body】:${jsonEncode(data)}');
    }
    try {
      response = await _createDio(
        contentType: contentType,
        baseUrl: baseUrl,
        header: header,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
      ).get(
        path,
        queryParameters: data,
        cancelToken: cancelToken,
      );
      int duration = DateTime.now().difference(_startTime).inMilliseconds;
      _log
        ..write('\n')
        ..write('===== 成功: ${(duration / 1000).toStringAsFixed(4)} 秒====');
      _log..write('\n')..write('【Response】：$response');
      if (printLog) L.d(_log.toString());
    } on DioError catch (e) {
      int duration = DateTime.now().difference(_startTime).inMilliseconds;
      _log
        ..write("\n")
        ..write('！！！！！ ✖✖请求错误✖✖ ${(duration / 1000).toStringAsFixed(4)} 秒！！！！');
      _log..write("\n")..write('【DioError】：$e');
      if (printLog) L.e(_log.toString());
      return ResponseModel(false, null, e.type);
    } on Exception catch (e2) {
      int duration = DateTime.now().difference(_startTime).inMilliseconds;
      _log
        ..write("\n")
        ..write('！！！！！ ✖✖请求错误✖✖ ${(duration / 1000).toStringAsFixed(4)} 秒！！！！');
      _log..write("\n")..write('【DioError】：$e2');
      if (printLog) L.e(_log.toString());
      return ResponseModel(false, null, DioErrorType.RESPONSE);
    }
    return ResponseModel(
        response.statusCode == 200, response, DioErrorType.RESPONSE);
  }

  /// [path]-请求的地址，[data]-请求的数据
  static Future<ResponseModel> post(
    String path, {
    data,
    CancelToken cancelToken,
    ContentType contentType,
    String baseUrl,
    Map<String, dynamic> header,
    int connectTimeout = 3000,
    int receiveTimeout = 100000,
    bool printLog = true,
  }) async {
    Response response;
    DateTime _startTime = DateTime.now();
    StringBuffer _log = StringBuffer("\n======= Post请求 ======");
    _log..write('\n')..write("【Url】:$baseUrl$path");
    _log..write('\n')..write("【Header】:$header");
    if (data != null && data is FormData) {
      _log..write('\n')..write('【Body】:${data.fields}');
    } else {
      _log..write('\n')..write('【Body】:$data');
    }
    try {
      response = await _createDio(
        contentType: contentType,
        baseUrl: baseUrl,
        header: header,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
      ).post(
        path,
        data: data,
        cancelToken: cancelToken,
      );
      int duration = DateTime.now().difference(_startTime).inMilliseconds;
      _log
        ..write("\n")
        ..write("===== 请求成功：${(duration / 1000).toStringAsFixed(4)} 秒====");
      _log..write('\n')..write('【Response】：$response');
      if (printLog) L.d(_log.toString());
    } on DioError catch (e) {
      int duration = DateTime.now().difference(_startTime).inMilliseconds;
      _log
        ..write("\n")
        ..write('！！！！！ ✖✖请求错误✖✖ ${(duration / 1000).toStringAsFixed(4)} 秒！！！！');
      _log..write("\n")..write('【DioError】：$e');
      if (printLog) L.e(_log.toString());
      return ResponseModel(false, null, e.type);
    } on Exception catch (e2) {
      int duration = DateTime.now().difference(_startTime).inMilliseconds;
      _log
        ..write("\n")
        ..write('！！！！！ ✖✖请求错误✖✖ ${(duration / 1000).toStringAsFixed(4)} 秒！！！！');
      _log..write("\n")..write('【DioError】：$e2');
      if (printLog) L.e(_log.toString());
      return ResponseModel(false, null, DioErrorType.RESPONSE);
    }
    return ResponseModel(
        response.statusCode == 200, response, DioErrorType.RESPONSE);
  }
}
