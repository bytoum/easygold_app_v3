import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/errors/exceptions.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/models/login_data_model.dart';
import 'package:easygold_app_v3/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:easygold_app_v3/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late _MockDataSource dataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    dataSource = _MockDataSource();
    repository = AuthRepositoryImpl(dataSource);
  });

  Future<Either<Failure, LoginDataModel>> signIn() =>
      repository.signInWithPassword(
        phoneNumber: 'p',
        password: 'w',
        uuid: 'u',
        code: 'c',
        fmcToken: 'f',
        isAllowPushNoti: true,
      );

  test('returns Right with the data source result and forwards args', () async {
    const model = LoginDataModel(accessToken: 'tok');
    when(
      () => dataSource.signInWithPassword(
        phoneNumber: any(named: 'phoneNumber'),
        password: any(named: 'password'),
        uuid: any(named: 'uuid'),
        code: any(named: 'code'),
        fmcToken: any(named: 'fmcToken'),
        isAllowPushNoti: any(named: 'isAllowPushNoti'),
      ),
    ).thenAnswer((_) async => model);

    expect(await signIn(), const Right<Failure, LoginDataModel>(model));
    verify(
      () => dataSource.signInWithPassword(
        phoneNumber: 'p',
        password: 'w',
        uuid: 'u',
        code: 'c',
        fmcToken: 'f',
        isAllowPushNoti: true,
      ),
    ).called(1);
  });

  test(
    'maps ServerException to Left(ServerFailure) keeping the message',
    () async {
      when(
        () => dataSource.signInWithPassword(
          phoneNumber: any(named: 'phoneNumber'),
          password: any(named: 'password'),
          uuid: any(named: 'uuid'),
          code: any(named: 'code'),
          fmcToken: any(named: 'fmcToken'),
          isAllowPushNoti: any(named: 'isAllowPushNoti'),
        ),
      ).thenThrow(const ServerException('bad creds'));

      expect(
        await signIn(),
        const Left<Failure, LoginDataModel>(ServerFailure('bad creds')),
      );
    },
  );
}
