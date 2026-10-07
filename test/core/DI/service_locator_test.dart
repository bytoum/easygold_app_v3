import 'package:aws_common/aws_common.dart';
import 'package:dio/dio.dart';
import 'package:easygold_app_v3/config/env_config.dart';
import 'package:easygold_app_v3/core/DI/service_locator.config.dart';
import 'package:easygold_app_v3/core/network/rest_client.dart';
import 'package:easygold_app_v3/core/services/asset_loader_service.dart';
import 'package:easygold_app_v3/core/services/dio_interceptor_service.dart';
import 'package:easygold_app_v3/core/services/storage_service.dart';
import 'package:easygold_app_v3/features/auth/domain/repositories/auth_repository.dart';
import 'package:easygold_app_v3/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:easygold_app_v3/features/home/domain/repositories/app_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late GetIt locator;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    // A private container, so the app-wide `getIt` is never touched.
    locator = GetIt.asNewInstance();
    await locator.init();
  });

  tearDown(() => locator.reset());

  test('registers the shared Dio as one configured singleton', () {
    final dio = locator<Dio>();

    expect(locator<Dio>(), same(dio));
    expect(dio.options.baseUrl, EnvConfig.BASE_END_POINT);
    expect(dio.options.connectTimeout, const Duration(seconds: 10));
    expect(dio.options.receiveTimeout, const Duration(seconds: 10));
    expect(dio.options.headers['Content-Type'], 'application/json');
    expect(dio.interceptors.whereType<DioInterceptorService>(), hasLength(1));
  });

  test('resolves the third-party objects and API clients', () {
    expect(locator<SharedPreferences>(), isNotNull);
    expect(locator<FlutterSecureStorage>(), isNotNull);
    expect(locator<AWSCredentialsProvider>(), isNotNull);
    expect(locator<S3AssetLoaderService>(), isNotNull);
    expect(locator<RestClient>(), isNotNull);
    expect(locator<AppClient>(), isNotNull);
    expect(locator<AuthClient>(), isNotNull);
  });

  test('binds abstractions to their implementations', () {
    expect(locator<StorageService>(), isA<StorageServiceImpl>());
    expect(locator<AuthRepository>(), isNotNull);
    expect(locator<AppRepository>(), isNotNull);
  });

  test('lazy singletons are shared; AuthCubit is a new instance each time', () {
    expect(locator<StorageService>(), same(locator<StorageService>()));
    expect(locator<AuthRepository>(), same(locator<AuthRepository>()));

    final a = locator<AuthCubit>();
    final b = locator<AuthCubit>();
    expect(a, isNot(same(b)));
    addTearDown(a.close);
    addTearDown(b.close);
  });
}
