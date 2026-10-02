import 'package:dio/dio.dart';
class DioInterceptorService extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add your custom logic here, e.g., adding headers, logging, etc.
    print('Request: ${options.method} ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Add your custom logic here, e.g., logging responses
    print('Response: ${response.statusCode} ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle errors here, e.g., logging or transforming errors
    print('Error: ${err.message} ${err.requestOptions.path}');
    super.onError(err, handler);
  }
  
}