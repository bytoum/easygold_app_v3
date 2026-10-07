import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/models/login_data_model.dart';
import 'package:easygold_app_v3/features/auth/domain/repositories/auth_repository.dart';
import 'package:easygold_app_v3/features/auth/domain/usecases/signin_with_password_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements AuthRepository {}

void main() {
  late _MockRepository repo;
  late SigninWithPasswordUsecase usecase;

  setUp(() {
    repo = _MockRepository();
    usecase = SigninWithPasswordUsecase(repo);
  });

  void stub(Either<Failure, LoginDataModel> result) {
    when(
      () => repo.signInWithPassword(
        phoneNumber: any(named: 'phoneNumber'),
        password: any(named: 'password'),
        uuid: any(named: 'uuid'),
        code: any(named: 'code'),
        fmcToken: any(named: 'fmcToken'),
        isAllowPushNoti: any(named: 'isAllowPushNoti'),
      ),
    ).thenAnswer((_) async => result);
  }

  test('SigninWithPasswordParams defaults isAllowPushNoti to false', () {
    final p = SigninWithPasswordParams(
      phoneNumber: 'p',
      password: 'w',
      uuid: 'u',
    );
    expect(p.isAllowPushNoti, isFalse);
    expect(p.code, isNull);
    expect(p.fmcToken, isNull);
  });

  test(
    'forwards every param to the repository and returns its result',
    () async {
      const model = LoginDataModel(accessToken: 't');
      stub(const Right(model));

      final result = await usecase(
        SigninWithPasswordParams(
          phoneNumber: 'p',
          password: 'w',
          uuid: 'u',
          code: 'c',
          fmcToken: 'f',
          isAllowPushNoti: true,
        ),
      );

      expect(result, const Right<Failure, LoginDataModel>(model));
      verify(
        () => repo.signInWithPassword(
          phoneNumber: 'p',
          password: 'w',
          uuid: 'u',
          code: 'c',
          fmcToken: 'f',
          isAllowPushNoti: true,
        ),
      ).called(1);
    },
  );

  test('passes failures through unchanged', () async {
    stub(const Left(ServerFailure('no')));
    final result = await usecase(
      SigninWithPasswordParams(phoneNumber: 'p', password: 'w', uuid: 'u'),
    );
    expect(result, const Left<Failure, LoginDataModel>(ServerFailure('no')));
  });
}
