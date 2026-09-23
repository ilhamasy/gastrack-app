import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheInterceptor extends Interceptor {
  final SharedPreferences _prefs;

  CacheInterceptor(this._prefs);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.method == 'GET' && response.statusCode == 200) {
      final key = response.requestOptions.uri.toString();
      _prefs.setString(key, jsonEncode(response.data));
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.requestOptions.method == 'GET') {
      final key = err.requestOptions.uri.toString();
      final cachedResponse = _prefs.getString(key);
      
      if (cachedResponse != null) {
        try {
          final data = jsonDecode(cachedResponse);
          return handler.resolve(
            Response(
              requestOptions: err.requestOptions,
              data: data,
              statusCode: 200,
              statusMessage: 'OK (Cached)',
            ),
          );
        } catch (_) {}
      }
    }
    super.onError(err, handler);
  }
}
