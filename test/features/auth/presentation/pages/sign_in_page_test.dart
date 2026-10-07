import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/models/login_data_model.dart';
import 'package:easygold_app_v3/features/auth/domain/usecases/signin_with_password_usecase.dart';
import 'package:easygold_app_v3/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:easygold_app_v3/features/auth/presentation/pages/sign_in/sign_in_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overlay_kit/overlay_kit.dart';

class _MockSigninUsecase extends Mock implements SigninWithPasswordUsecase {}

class _FakeParams extends Fake implements SigninWithPasswordParams {}

Widget _app(_MockSigninUsecase usecase) => OverlayKit(
  child: MaterialApp(
    home: BlocProvider<AuthCubit>(
      create: (_) => AuthCubit(usecase),
      child: const SignInPage(),
    ),
  ),
);

Finder get _phone => find.widgetWithText(TextField, 'Phone Number');
Finder get _password => find.widgetWithText(TextField, 'Password');
Finder get _signIn => find.widgetWithText(ElevatedButton, 'Sign In');

/// The loading overlay animates forever, so pumpAndSettle would time out.
Future<void> _pumpFrames(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  late _MockSigninUsecase usecase;

  setUpAll(() => registerFallbackValue(_FakeParams()));
  setUp(() => usecase = _MockSigninUsecase());

  testWidgets('renders both fields and the button', (tester) async {
    await tester.pumpWidget(_app(usecase));

    expect(_phone, findsOneWidget);
    expect(_password, findsOneWidget);
    expect(_signIn, findsOneWidget);
  });

  testWidgets('password field is obscured', (tester) async {
    await tester.pumpWidget(_app(usecase));

    expect(tester.widget<TextField>(_password).obscureText, isTrue);
  });

  testWidgets('empty form shows required errors and skips sign-in', (
    tester,
  ) async {
    await tester.pumpWidget(_app(usecase));

    await tester.tap(_signIn);
    await tester.pump();

    expect(find.text('Phone number is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    verifyNever(() => usecase(any()));
  });

  testWidgets('non-numeric phone number is rejected', (tester) async {
    await tester.pumpWidget(_app(usecase));

    await tester.enterText(_phone, 'abc');
    await tester.enterText(_password, 'pw');
    await tester.tap(_signIn);
    await tester.pump();

    expect(find.text('Phone number must be numeric'), findsOneWidget);
    verifyNever(() => usecase(any()));
  });

  testWidgets(
    'valid credentials reach the use case without an error snackbar',
    (tester) async {
      when(() => usecase(any())).thenAnswer(
        (_) async => const Right(LoginDataModel(accessToken: 'token')),
      );
      await tester.pumpWidget(_app(usecase));

      await tester.enterText(_phone, '2055551234');
      await tester.enterText(_password, 'secret');
      await tester.tap(_signIn);
      await _pumpFrames(tester);

      final params =
          verify(() => usecase(captureAny())).captured.single
              as SigninWithPasswordParams;
      expect(params.phoneNumber, '2055551234');
      expect(params.password, 'secret');
      expect(find.byType(SnackBar), findsNothing);
    },
  );

  testWidgets('server failure shows its message in a snackbar', (tester) async {
    when(() => usecase(any()))
        .thenAnswer((_) async => const Left(ServerFailure('Wrong password')));
    await tester.pumpWidget(_app(usecase));

    await tester.enterText(_phone, '2055551234');
    await tester.enterText(_password, 'bad');
    await tester.tap(_signIn);
    await _pumpFrames(tester);

    expect(find.text('Wrong password'), findsOneWidget);
  });

  testWidgets('empty server message falls back to the generic failure text', (
    tester,
  ) async {
    when(() => usecase(any()))
        .thenAnswer((_) async => const Left(ServerFailure('')));
    await tester.pumpWidget(_app(usecase));

    await tester.enterText(_phone, '2055551234');
    await tester.enterText(_password, 'bad');
    await tester.tap(_signIn);
    await _pumpFrames(tester);

    // No EasyLocalization in this test, so tr() returns the key itself.
    expect(find.text('sign_in_failed'), findsOneWidget);
  });
}
