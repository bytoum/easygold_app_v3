import 'package:aws_common/aws_common.dart';
import 'package:dio/dio.dart';
import 'package:easygold_app_v3/config/env_config.dart';
import 'package:easygold_app_v3/core/network/rest_client.dart';
import 'package:easygold_app_v3/core/services/asset_loader_service.dart';
import 'package:easygold_app_v3/core/services/dio_interceptor_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class InjectionModule {
  @preResolve // Async initialization
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @singleton
  Dio get dio {
    final dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.BASE_END_POINT,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    // You can add interceptors here if needed
    dio.interceptors.add(DioInterceptorService());
    return dio;
  }

  //S3
  @singleton
  AWSCredentialsProvider get awsCredentialsProvider => AWSCredentialsProvider(
    AWSCredentials(EnvConfig.AWS_ACCESS_KEY, EnvConfig.AWS_SECRET_KEY),
  );

  @lazySingleton
  S3AssetLoaderService get s3AssetLoaderWithCredentials => S3AssetLoaderService(
    bucket: EnvConfig.AWS_BUCKET_NAME,
    region: EnvConfig.AWS_REGION,
    credentialsProvider: awsCredentialsProvider,
    dio: dio,
  );

  //[API Clients]
  @lazySingleton
  RestClient get restClient =>
      RestClient(dio, baseUrl: EnvConfig.BASE_END_POINT);

  @lazySingleton
  AppClient get appClient => AppClient(dio, baseUrl: EnvConfig.BASE_END_POINT);

  @lazySingleton
  AuthClient get authClient =>
      AuthClient(dio, baseUrl: '${EnvConfig.BASE_END_POINT}/auth-service/api/v1/auth');
}
