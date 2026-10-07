import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/constants/enums/data_status.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/models/login_data_model.dart';
import 'package:easygold_app_v3/features/auth/domain/usecases/signin_with_password_usecase.dart';
import 'package:easygold_app_v3/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSignIn extends Mock implements SigninWithPasswordUsecase {}

class _FakeParams extends Fake implements SigninWithPasswordParams {}

void main() {
  late _MockSignIn signIn;
  late AuthCubit cubit;

  setUpAll(() => registerFallbackValue(_FakeParams()));

  setUp(() {
    signIn = _MockSignIn();
    cubit = AuthCubit(signIn);
  });

  tearDown(() => cubit.close());

  test('starts initial with no error', () {
    expect(cubit.state.status, DataStatus.initial);
    expect(cubit.state.errorMessage, isNull);
  });

  group('signInWithPassword', () {
    test('emits loading then success and forwards credentials', () async {
      when(
        () => signIn(any()),
      ).thenAnswer((_) async => const Right(LoginDataModel(accessToken: 't')));

      final states = expectLater(
        cubit.stream.map((s) => s.status),
        emitsInOrder([DataStatus.loading, DataStatus.success]),
      );
      await cubit.signInWithPassword(phoneNumber: '020', password: 'pw');
      await states;

      final params =
          verify(() => signIn(captureAny())).captured.single
              as SigninWithPasswordParams;
      expect(params.phoneNumber, '020');
      expect(params.password, 'pw');
      expect(cubit.state.errorMessage, isNull);
    });

    test('emits loading then failure carrying the failure message', () async {
      when(() => signIn(any()))
          .thenAnswer((_) async => const Left(ServerFailure('Wrong password')));

      final states = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AuthState>().having(
            (s) => s.status,
            'status',
            DataStatus.loading,
          ),
          isA<AuthState>()
              .having((s) => s.status, 'status', DataStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', 'Wrong password'),
        ]),
      );
      await cubit.signInWithPassword(phoneNumber: '020', password: 'pw');
      await states;
    });
  });

  testWidgets(
    'initialize shows loading for a second, then returns to initial',
    (tester) async {
      final statuses = <DataStatus>[];
      final sub = cubit.stream.listen((s) => statuses.add(s.status));
      addTearDown(sub.cancel);

      final done = cubit.initialize();
      await tester.pump();
      expect(statuses, [DataStatus.loading]);

      await tester.pump(const Duration(seconds: 1));
      await done;
      expect(statuses, [DataStatus.loading, DataStatus.initial]);
    },
  );
}
