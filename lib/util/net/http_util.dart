import 'dart:io';

import 'package:dio/dio.dart';

import '../log/log_util.dart';

class HttpUtil {
  static Dio _dio;

  /// 创建dio对象，请求参数发生变化，需重新创建
  static Dio _createDio({
    ContentType contentType,
    String baseUrl,
    Map<String, dynamic> header,
    int connectTimeout = 10000,
    int receiveTimeout = 100000,
  }) {
    bool hasChangeOptions = _dio == null;
    // 请求类型
    hasChangeOptions = hasChangeOptions || (contentType != null && _dio.options.contentType != contentType);
    // base url
    hasChangeOptions = hasChangeOptions || (baseUrl != null && _dio.options.baseUrl != baseUrl);
    // base url
    hasChangeOptions = hasChangeOptions || (baseUrl != null && _dio.options.connectTimeout != connectTimeout);
    // base url
    hasChangeOptions = hasChangeOptions || (baseUrl != null && _dio.options.receiveTimeout != receiveTimeout);
    // 请求头
    if (!hasChangeOptions && header != null) {
      if (_dio.options.headers == null) {
        hasChangeOptions = true;
      } else {
        if (_dio.options.headers.length != header.length) {
          hasChangeOptions = true;
        } else {
          _dio.options.headers.forEach((key, value) {
            hasChangeOptions = hasChangeOptions || (header[key] != value);
          });
        }
      }
    }
    if (hasChangeOptions) {
//      YU.log('重新创建dio对象');
      BaseOptions options = BaseOptions(
          baseUrl: baseUrl ?? '',
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          contentType: contentType,
          headers: header ?? {},
          responseType: ResponseType.plain);
      _dio = Dio(options);
    }
    return _dio;
  }

  static Future get(url,
      {data,
      cancelToken,
      ContentType contentType,
      String baseUrl,
      bool printLog = true,
      Map<String, dynamic> header,
      int connectTimeout = 10000,
      int receiveTimeout = 100000}) async {
    Response response;
    try {
      response = await _createDio(
        contentType: contentType,
        baseUrl: baseUrl,
        header: header,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
      ).get(
        url,
        queryParameters: data,
        cancelToken: cancelToken,
      );
      if (printLog)
        L.d(' \n ======= Get请求成功! ======\n Url：${response.request.baseUrl}$url \n Header:$header \n Body:$data \n Response：$response');
    } on DioError catch (e) {
      if (printLog) L.d("get请求错误 $e");
      return null;
    }
    return response.data;
  }

  /// [url]-请求的地址，[data]-请求的数据
  static post(url,
      {data,
      options,
      bool printLog = true,
      cancelToken,
      ContentType contentType,
      String baseUrl,
      Map<String, dynamic> header,
      int connectTimeout = 10000,
      int receiveTimeout = 100000}) async {
    Response response;
    try {
      response = await _createDio(
        contentType: contentType,
        baseUrl: baseUrl,
        header: header,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
      ).post(
        url,
        data: data,
        cancelToken: cancelToken,
      );
      if (printLog)
        L.d('======= Post请求成功 ======\n Url：${response.request.baseUrl}$url \n Header:$header \n Body:$data \n Response：$response');
    } on DioError catch (e) {
      if (printLog)
        L.d('======= <<!! post请求错误 !!>> ======\n Url：$baseUrl$url \n Header:$header \n Body:$data \n DioError: $e');
      return null;
    } on Exception catch (e2) {
      if (printLog)
        L.d('======= <<!! post请求错误 !!>> ======\n Url：$baseUrl$url \n Header:$header \n Body:$data \n Exception: $e2');
      return null;
    }
    return response.data;
  }
}
