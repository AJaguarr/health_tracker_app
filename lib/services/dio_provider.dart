import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itoju_mobile/core/helpers/logger.dart';
import 'package:itoju_mobile/core/Storage/storage_class.dart';

///
final dioProvider = Provider((ref) {
  final dio = Dio();
  dio.options.baseUrl = prodUrl;
  dio.options.headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };
  dio.interceptors.add(AppInterceptor());
  return dio;
});

const String prodUrl =
    'https://occasional-carly-davidoh-b257669a.koyeb.app/v1/';

final idioProvider = Provider.autoDispose((_) {
  final dio = Dio();
  dio.options.baseUrl = prodUrl;
  dio.options.headers = {"Content-Type": "multipart/form-data"};
  dio.interceptors.add(AppInterceptor());
  return dio;
});

class AppInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.sendTimeout = Duration(seconds: 30);
    options.connectTimeout = Duration(seconds: 30);
    options.receiveTimeout = Duration(seconds: 30);
    debugLog(options.baseUrl + options.path);
    debugLog(options.headers);
    String token = await HiveStorage.get(HiveKeys.token) ?? '';
    options.headers["Authorization"] = "Bearer $token";
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode! >= 200) {
      debugLog("Yes Successful response");
    }
    debugLog(response.data);
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugLog(err);
    super.onError(err, handler);
  }
}
