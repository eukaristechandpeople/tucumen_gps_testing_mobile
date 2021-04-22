import 'dart:convert';

import 'package:dio/dio.dart';

import '../../main.dart';
import '../error/exception.dart';

abstract class BaseDioClient {
  Dio _instance;

  BaseDioClient(
  );

  String get _apiBaseUrl => urlBase;

  Future<String> getToken();


  Future<Dio> getDio() async {
    //await checkDeviceConnected();

    final token = await _getToken();
    final tokenChecked = await checkToken(token);

    _instance = Dio();
    _instance.options.baseUrl = _apiBaseUrl;
    _instance.options.connectTimeout = 120000;

    _instance.options.headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $tokenChecked"
    };

    //final performanceInterceptor = DioFirebasePerformanceInterceptor();
    //_instance.interceptors.add(DioInterceptor());
    //_instance.interceptors.add(DioCacheManager(CacheConfig(baseUrl: _apiBaseUrl)).interceptor);

    return _instance;
  }

  Future<String> checkToken(String token) async{
    return _getToken();
  }


  Future<String> _getToken() async {
    final token = await getToken();

    if (token == null) throw NotTokenException();

    return token;
  }


  Future<Response> get(url, {Map<String, String> headers}) async {
    await getDio();

    final response = await _instance.get(url, queryParameters: headers ?? null, /*options: buildCacheOptions(Duration(days: 1))*/);
    return _processResponse(response);
  }

  Future<Response> getUri(url) async {
    await getDio();
    final response = await _instance.getUri(url);
    return _processResponse(response);
  }


  Future<Response> post(url, {Map<String, String> headers, body, Encoding encoding}) async {
    await getDio();

    final response = await _instance.post(url, data: body, queryParameters: headers ?? null, /*options: buildCacheOptions(Duration(days: 1))*/);

    return _processResponse(response);
  }

  Future<Response> put(url, {Map<String, String> headers, body, Encoding encoding}) async {
    await getDio();

    final response = await _instance.put(url, data: body, queryParameters: headers ?? null, /*options: buildCacheOptions(Duration(days: 1))*/);

    return _processResponse(response);
  }


  Future<Response> delete(url, {Map<String, String> headers}) async {
    await getDio();

    final response = await _instance.delete(url, queryParameters: headers ?? null, /*options: buildCacheOptions(Duration(days: 1))*/);

    return _processResponse(response);
  }

  Future<void> checkDeviceConnected() async {
    /*final isDeviceConnected = await _connectionChecker.hasConnection;

    if (!isDeviceConnected) {
      throw (NotConnectionException(
          "No Internet, Reason: ${_connectionChecker?.lastTryResults?.toString() ?? ""}"));
    }*/
  }


  Response _processResponse(Response response) {
    var statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode <= 300) {
      return response;
    } else if (statusCode == 400) {
      throw BadRequestException(response.data.toString());
    } else if (statusCode == 401 || statusCode == 403) {
      throw UnauthorisedException(response.data.toString());
    } else {
      throw ServerException(
          'Error occured while Communication with Server with StatusCode : $statusCode');
    }
  }
}
