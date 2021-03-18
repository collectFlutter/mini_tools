import 'dart:io';

import 'package:dio/dio.dart';
import '../log/log_util.dart';
import 'response_model.dart';

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
        (contentType != null && _dio.options.contentType != contentType.subType) ||
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
  static Future<ResponseModel> get(String path,
      {Map<String, dynamic> data,
      CancelToken cancelToken,
      ContentType contentType,
      String baseUrl,
      Map<String, dynamic> header,
      int connectTimeout = 10000,
      int receiveTimeout = 100000}) async {
    DateTime _startTime = DateTime.now();
    Response response;
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
      L.i('======= Get请求成功! ${(duration / 10000).toStringAsFixed(4)} 秒======');
      L.i('Url：${response.realUri.host} \n Header:$header');
      L.i('Body:$data');
      L.i('Response：$response');
    } on DioError catch (e) {
      L.e('======= <<!! Get请求错误 !!>> ======\n Url：$baseUrl$path \n Header:$header \n Body:$data \n DioError: $e');
      return ResponseModel(false, null, e.type);
    } on Exception catch (e2) {
      L.e('======= <<!! Get请求错误 !!>> ======\n Url：$baseUrl$path \n Header:$header \n Body:$data \n Exception: $e2');
      return ResponseModel(false, null, DioErrorType.other);
    }
    return ResponseModel(response.statusCode == 200, response, DioErrorType.response);
  }

  /// [path]-请求的地址，[data]-请求的数据
  static Future<ResponseModel> post(String path,
      {data,
      CancelToken cancelToken,
      ContentType contentType,
      String baseUrl,
      Map<String, dynamic> header,
      int connectTimeout = 10000,
      int receiveTimeout = 100000}) async {
    Response response;
    DateTime _startTime = DateTime.now();
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
      L.i('======= Post请求成功! ${(duration / 10000).toStringAsFixed(4)} 秒======');
      L.i('Url：$baseUrl$path \n Header:$header');
      if (data != null && data is FormData) {
        L.i('Body:${data.fields}');
      } else {
        L.i('Body:$data');
      }
      L.i('Response：$response');
    } on DioError catch (e) {
      int duration = DateTime.now().difference(_startTime).inMilliseconds;
      L.e('======= <<!! post请求错误 !!>> ${(duration / 10000).toStringAsFixed(4)} 秒======');
      L.e('Url：$baseUrl$path \n Header:$header');
      if (data != null && data is FormData) {
        L.e('Body:${data.fields}');
      } else {
        L.e('Body:$data');
      }
      L.e('DioError：$e');
      return ResponseModel(false, null, e.type);
    } on Exception catch (e2) {
      int duration = DateTime.now().difference(_startTime).inMilliseconds;
      L.e('======= <<!! post请求错误 !!>> ${(duration / 10000).toStringAsFixed(4)} 秒======');
      L.e('Url：$baseUrl$path \n Header:$header');
      if (data != null && data is FormData) {
        L.e('Body:${data.fields}');
      } else {
        L.e('Body:$data');
      }
      L.e('Exception：$e2');
      return ResponseModel(false, null, DioErrorType.other);
    }
    return ResponseModel(response.statusCode == 200, response, DioErrorType.response);
  }
}
