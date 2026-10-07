import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/constants/enums/data_status.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/models/login_data_model.dart';
import 'package:easygold_app_v3/features/auth/domain/usecases/signin_with_password_usecase.dart';
import 'package:easygold_app_v3/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSigninUsecase extends Mock implements SigninWithPasswordUsecase {}

class _FakeParams extends Fake implements SigninWithPasswordParams {}

void main() {
  late _MockSigninUsecase usecase;
  late AuthCubit cubit;

  setUpAll(() => registerFallbackValue(_FakeParams()));

  setUp(() {
    usecase = _MockSigninUsecase();
    cubit = AuthCubit(usecase);
  });

  tearDown(() => cubit.close());

  test('initial state is DataStatus.initial with no error', () {
    expect(cubit.state, const AuthState());
  });

  test('signInWithPassword emits loading then success on Right', () async {
    when(() => usecase(any())).thenAnswer(
      (_) async => const Right(LoginDataModel(accessToken: 'token')),
    );

    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        const AuthState(status: DataStatus.loading),
        const AuthState(status: DataStatus.success),
      ]),
    );

    await cubit.signInWithPassword(phoneNumber: '000', password: 'pw');
    await expectation;
  });

  test(
    'signInWithPassword emits loading then failure with message on Left',
    () async {
      when(() => usecase(any()))
          .thenAnswer((_) async => const Left(ServerFailure('Wrong password')));

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          const AuthState(status: DataStatus.loading),
          const AuthState(
            status: DataStatus.failure,
            errorMessage: 'Wrong password',
          ),
        ]),
      );

      await cubit.signInWithPassword(phoneNumber: '000', password: 'pw');
      await expectation;
    },
  );

  test(
    'signInWithPassword passes the phone number and password to the use case',
    () async {
      when(() => usecase(any())).thenAnswer(
        (_) async => const Right(LoginDataModel(accessToken: 'token')),
      );

      await cubit.signInWithPassword(phoneNumber: '123', password: 'secret');

      final params =
          verify(() => usecase(captureAny())).captured.single
              as SigninWithPasswordParams;
      expect(params.phoneNumber, '123');
      expect(params.password, 'secret');
    },
  );

  test('initialize emits loading then initial', () async {
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        const AuthState(status: DataStatus.loading),
        const AuthState(status: DataStatus.initial),
      ]),
    );

    await cubit.initialize();
    await expectation;
  });
}
