import 'package:dio/dio.dart';

class ResponseModel {
  DioErrorType _type;
  Response _response;
  bool _success;

  ResponseModel(this._success, this._response, this._type);

  bool get success => _success;

  Response get response => _response;

  DioErrorType get type => _type;
}
