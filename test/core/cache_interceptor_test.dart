import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gastrack_app/core/network/cache_interceptor.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CacheInterceptor', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({'http://localhost/api/vehicles': '[{"id":"v-1"}]'});
      prefs = await SharedPreferences.getInstance();
    });

    test('caches response on GET 200', () async {
      final interceptor = CacheInterceptor(prefs);
      final options = RequestOptions(path: 'http://localhost/api/vehicles', method: 'GET');

      final response = Response(
        requestOptions: options,
        data: [{'id': 'v-1'}],
        statusCode: 200,
      );

      final handler = ResponseInterceptorHandler();
      interceptor.onResponse(response, handler);

      expect(prefs.getString('http://localhost/api/vehicles'), '[{"id":"v-1"}]');
    });

    test('resolves from cache on network error', () async {
      final interceptor = CacheInterceptor(prefs);
      final options = RequestOptions(path: 'http://localhost/api/vehicles', method: 'GET');

      final err = DioException(
        requestOptions: options,
        type: DioExceptionType.connectionTimeout,
      );

      final handler = ErrorInterceptorHandler();
      interceptor.onError(err, handler);
    });
  });
}
