import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/models/login_data_model.dart';
import 'package:easygold_app_v3/features/auth/domain/repositories/auth_repository.dart';
import 'package:easygold_app_v3/features/auth/domain/usecases/signin_with_password_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late SigninWithPasswordUsecase usecase;

  final params = SigninWithPasswordParams(
    phoneNumber: '000',
    password: 'pw',
    uuid: 'uuid',
    code: 'code',
    fmcToken: 'fmc',
    isAllowPushNoti: true,
  );

  Future<Either<Failure, LoginDataModel>> stubbed() =>
      repository.signInWithPassword(
        phoneNumber: '000',
        password: 'pw',
        uuid: 'uuid',
        code: 'code',
        fmcToken: 'fmc',
        isAllowPushNoti: true,
      );

  setUp(() {
    repository = _MockAuthRepository();
    usecase = SigninWithPasswordUsecase(repository);
  });

  test(
    'forwards every param to the repository and returns its Right',
    () async {
      const model = LoginDataModel(accessToken: 'token');
      when(stubbed).thenAnswer((_) async => const Right(model));

      final result = await usecase(params);

      expect(result, const Right<Failure, LoginDataModel>(model));
      verify(stubbed).called(1);
    },
  );

  test('returns the repository Left unchanged', () async {
    when(stubbed).thenAnswer((_) async => const Left(ServerFailure('nope')));

    final result = await usecase(params);

    expect(result, const Left<Failure, LoginDataModel>(ServerFailure('nope')));
  });

  test('isAllowPushNoti defaults to false', () {
    expect(
      SigninWithPasswordParams(
        phoneNumber: '1',
        password: 'p',
        uuid: 'u',
      ).isAllowPushNoti,
      isFalse,
    );
  });
}
