import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/errors/exceptions.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/models/login_data_model.dart';
import 'package:easygold_app_v3/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:easygold_app_v3/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late _MockAuthRemoteDataSource dataSource;
  late AuthRepositoryImpl repository;

  Future<LoginDataModel> remoteCall() => dataSource.signInWithPassword(
    phoneNumber: '000',
    password: 'pw',
    uuid: 'uuid',
    code: 'code',
    fmcToken: 'fmc',
    isAllowPushNoti: true,
  );

  Future<Either<Failure, LoginDataModel>> signIn() =>
      repository.signInWithPassword(
        phoneNumber: '000',
        password: 'pw',
        uuid: 'uuid',
        code: 'code',
        fmcToken: 'fmc',
        isAllowPushNoti: true,
      );

  setUp(() {
    dataSource = _MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(dataSource);
  });

  test('returns Right with the data source result', () async {
    const model = LoginDataModel(accessToken: 'token');
    when(remoteCall).thenAnswer((_) async => model);

    expect(await signIn(), const Right<Failure, LoginDataModel>(model));
    verify(remoteCall).called(1);
  });

  test(
    'maps ServerException to Left(ServerFailure) with the same message',
    () async {
      when(remoteCall).thenThrow(const ServerException('bad credentials'));

      expect(
        await signIn(),
        const Left<Failure, LoginDataModel>(ServerFailure('bad credentials')),
      );
    },
  );
}
