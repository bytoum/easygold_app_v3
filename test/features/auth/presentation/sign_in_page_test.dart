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

  Future<void> pumpPage(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      home: OverlayKit(
        child: BlocProvider.value(value: cubit, child: const SignInPage()),
      ),
    ),
  );

  Finder field(String name) => find.byWidgetPredicate(
    (w) => w is TextField && w.decoration?.labelText == name,
  );

  Future<void> submit(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pump();
  }

  testWidgets(
    'shows required errors and does not call the use case when empty',
    (tester) async {
      await pumpPage(tester);
      await submit(tester);

      expect(find.text('Phone number is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      verifyNever(() => signIn(any()));
    },
  );

  testWidgets('rejects a non-numeric phone number', (tester) async {
    await pumpPage(tester);
    await tester.enterText(field('Phone Number'), 'abc');
    await tester.enterText(field('Password'), 'pw');
    await submit(tester);

    expect(find.text('Phone number must be numeric'), findsOneWidget);
    verifyNever(() => signIn(any()));
  });

  testWidgets('password field is obscured', (tester) async {
    await pumpPage(tester);
    final password = tester.widget<TextField>(field('Password'));
    expect(password.obscureText, isTrue);
  });

  testWidgets('valid input signs in with the entered credentials', (
    tester,
  ) async {
    when(() => signIn(any()))
        .thenAnswer((_) async => const Right(LoginDataModel(accessToken: 't')));
    await pumpPage(tester);
    await tester.enterText(field('Phone Number'), '020123');
    await tester.enterText(field('Password'), 'pw');
    await submit(tester);
    await tester.pump();

    final params =
        verify(() => signIn(captureAny())).captured.single
            as SigninWithPasswordParams;
    expect(params.phoneNumber, '020123');
    expect(params.password, 'pw');
  });

  testWidgets('a failure with a server message shows it in a snackbar', (
    tester,
  ) async {
    when(() => signIn(any()))
        .thenAnswer((_) async => const Left(ServerFailure('Account locked')));
    await pumpPage(tester);
    await tester.enterText(field('Phone Number'), '020123');
    await tester.enterText(field('Password'), 'pw');
    await submit(tester);
    await tester.pump();
    await tester.pump();

    expect(find.text('Account locked'), findsOneWidget);
  });

  testWidgets('a failure with an empty message shows the localized fallback', (
    tester,
  ) async {
    when(() => signIn(any()))
        .thenAnswer((_) async => const Left(ServerFailure('')));
    await pumpPage(tester);
    await tester.enterText(field('Phone Number'), '020123');
    await tester.enterText(field('Password'), 'pw');
    await submit(tester);
    await tester.pump();
    await tester.pump();

    // Localization is not initialised in tests, so tr() yields the key.
    expect(
      find.descendant(
        of: find.byType(SnackBar),
        matching: find.text('sign_in_failed'),
      ),
      findsOneWidget,
    );
  });
}
