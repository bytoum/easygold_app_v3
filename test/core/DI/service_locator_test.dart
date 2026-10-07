import 'package:aws_common/aws_common.dart';
import 'package:dio/dio.dart';
import 'package:easygold_app_v3/config/env_config.dart';
import 'package:easygold_app_v3/core/DI/service_locator.dart';
import 'package:easygold_app_v3/core/network/rest_client.dart';
import 'package:easygold_app_v3/core/services/asset_loader_service.dart';
import 'package:easygold_app_v3/core/services/dio_interceptor_service.dart';
import 'package:easygold_app_v3/core/services/storage_service.dart';
import 'package:easygold_app_v3/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:easygold_app_v3/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:easygold_app_v3/features/auth/domain/repositories/auth_repository.dart';
import 'package:easygold_app_v3/features/auth/domain/usecases/signin_with_password_usecase.dart';
import 'package:easygold_app_v3/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:easygold_app_v3/features/home/data/datasources/app_remote_datasource.dart';
import 'package:easygold_app_v3/features/home/data/repositories/app_repository_impl.dart';
import 'package:easygold_app_v3/features/home/domain/repositories/app_repository.dart';
import 'package:easygold_app_v3/features/home/domain/usecases/check_version_available_usecase.dart';
import 'package:easygold_app_v3/features/home/domain/usecases/get_bill_background_usecase.dart';
import 'package:easygold_app_v3/features/home/domain/usecases/get_contact_usecase.dart';
import 'package:easygold_app_v3/features/home/domain/usecases/get_location_usecase.dart';
import 'package:easygold_app_v3/features/home/domain/usecases/get_social_media_usecase.dart';
import 'package:easygold_app_v3/features/home/domain/usecases/get_title_usecase.dart';
import 'package:easygold_app_v3/features/home/domain/usecases/get_version_detail_usecase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Runs the real configureDependencies() (generated graph + InjectionModule).
/// Nothing here touches the network: Dio, the API clients and the S3 loader
/// are only constructed, never called. Env values are never asserted on or
/// printed; checks that involve them compare to a boolean.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await getIt.reset();
    await configureDependencies();
  });

  tearDown(() => getIt.reset());

  group('registrations', () {
    test('every use case resolves', () {
      expect(getIt<SigninWithPasswordUsecase>(), isNotNull);
      expect(getIt<CheckVersionAvailableUsecase>(), isNotNull);
      expect(getIt<GetBillBackgroundUseCase>(), isNotNull);
      expect(getIt<GetContactUseCase>(), isNotNull);
      expect(getIt<GetLocationUseCase>(), isNotNull);
      expect(getIt<GetSocialMediaUseCase>(), isNotNull);
      expect(getIt<GetTitleUseCase>(), isNotNull);
      expect(getIt<GetVersionDetailUseCase>(), isNotNull);
    });

    test('repositories and data sources resolve to their implementations', () {
      expect(getIt<AuthRepository>(), isA<AuthRepositoryImpl>());
      expect(getIt<AppRepository>(), isA<AppRepositoryImpl>());
      expect(getIt<AuthRemoteDataSource>(), isA<AuthRemoteDataSourceImpl>());
      expect(getIt<AppRemoteDataSource>(), isA<AppRemoteDataSourceImpl>());
    });

    test('StorageService resolves to StorageServiceImpl', () {
      expect(getIt<StorageService>(), isA<StorageServiceImpl>());
    });

    test('third-party objects and API clients resolve', () {
      expect(getIt<SharedPreferences>(), isNotNull);
      expect(getIt<FlutterSecureStorage>(), isNotNull);
      expect(getIt<Dio>(), isNotNull);
      expect(getIt<AWSCredentialsProvider>(), isNotNull);
      expect(getIt<S3AssetLoaderService>(), isNotNull);
      expect(getIt<RestClient>(), isNotNull);
      expect(getIt<AppClient>(), isNotNull);
      expect(getIt<AuthClient>(), isNotNull);
    });

    test('AuthCubit resolves with its use case wired in', () {
      final cubit = getIt<AuthCubit>();
      addTearDown(cubit.close);

      expect(cubit.state, const AuthState());
    });
  });

  group('lifetimes', () {
    test('AuthCubit is a factory: each resolve is a new instance', () {
      final a = getIt<AuthCubit>();
      final b = getIt<AuthCubit>();
      addTearDown(a.close);
      addTearDown(b.close);

      expect(identical(a, b), isFalse);
    });

    test('use cases and repositories are lazy singletons', () {
      expect(
        identical(
          getIt<SigninWithPasswordUsecase>(),
          getIt<SigninWithPasswordUsecase>(),
        ),
        isTrue,
      );
      expect(
        identical(getIt<AuthRepository>(), getIt<AuthRepository>()),
        isTrue,
      );
      expect(identical(getIt<AppRepository>(), getIt<AppRepository>()), isTrue);
    });

    test('Dio is a singleton shared by all consumers', () {
      expect(identical(getIt<Dio>(), getIt<Dio>()), isTrue);
    });
  });

  group('shared Dio configuration', () {
    test('uses the env base URL, JSON content type and 10s timeouts', () {
      final options = getIt<Dio>().options;

      expect(options.baseUrl == EnvConfig.BASE_END_POINT, isTrue);
      expect(options.headers['Content-Type'], 'application/json');
      expect(options.connectTimeout, const Duration(seconds: 10));
      expect(options.receiveTimeout, const Duration(seconds: 10));
    });

    test('has the logging interceptor installed', () {
      expect(
        getIt<Dio>().interceptors.whereType<DioInterceptorService>(),
        hasLength(1),
      );
    });
  });

  test('configureDependencies can be re-run after a reset', () async {
    await getIt.reset();
    await configureDependencies();

    expect(getIt<AuthRepository>(), isA<AuthRepositoryImpl>());
  });
}
