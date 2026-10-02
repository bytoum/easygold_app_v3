import 'package:dio/dio.dart';
import 'package:easygold_app_v3/config/env_config.dart';
import 'package:easygold_app_v3/core/network/rest_client.dart';
import 'package:easygold_app_v3/core/services/dio_interceptor_service.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class InjectionModule {
  @preResolve // Async initialization
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
  
  @singleton
  Dio dio() {
    final dio = Dio(BaseOptions(
      baseUrl: EnvConfig.BASE_END_POINT,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    // You can add interceptors here if needed
    dio.interceptors.add(DioInterceptorService());
    return dio;
  }
  
  @lazySingleton
  RestClient get restClient => RestClient(dio(), baseUrl: EnvConfig.BASE_END_POINT);

}