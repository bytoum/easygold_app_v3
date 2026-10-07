import 'package:easygold_app_v3/config/routes/app_router.dart';
import 'package:easygold_app_v3/core/constants/enums/data_status.dart';
import 'package:easygold_app_v3/core/DI/service_locator.dart';
import 'package:easygold_app_v3/core/widgets/not_found_widget.dart';
import 'package:easygold_app_v3/core/widgets/splash_screen.dart';
import 'package:easygold_app_v3/features/auth/domain/usecases/signin_with_password_usecase.dart';
import 'package:easygold_app_v3/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:easygold_app_v3/features/auth/presentation/pages/sign_in/sign_in_page.dart';
import 'package:easygold_app_v3/features/home/presentation/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overlay_kit/overlay_kit.dart';

class _MockSigninUsecase extends Mock implements SigninWithPasswordUsecase {}

Widget _app() => OverlayKit(child: MaterialApp.router(routerConfig: appRouter));

void main() {
  late List<AuthCubit> createdCubits;

  setUp(() async {
    createdCubits = [];
    await getIt.reset();
    // The /sign-in builder resolves AuthCubit from get_it, so register a
    // factory that hands out real cubits backed by a mocked use case.
    getIt.registerFactory<AuthCubit>(() {
      final cubit = AuthCubit(_MockSigninUsecase());
      createdCubits.add(cubit);
      return cubit;
    });
    appRouter.go(Routes.home);
  });

  tearDown(() async {
    appRouter.go(Routes.home);
    await getIt.reset();
  });

  testWidgets('initial location is the splash screen', (tester) async {
    // appRouter is a global already moved by setUp, so check its declaration.
    expect(Routes.splash, '/');
    appRouter.go(Routes.splash);
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);

    // Let the splash timers finish so none stays pending.
    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
  });

  testWidgets('/home builds HomePage with no redirect', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(SignInPage), findsNothing);
  });

  testWidgets('unknown paths show NotFoundWidget', (tester) async {
    appRouter.go('/nope');
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.byType(NotFoundWidget), findsOneWidget);
  });

  group('/sign-in', () {
    testWidgets('builds SignInPage with an AuthCubit from get_it', (
      tester,
    ) async {
      appRouter.go(Routes.signIn);
      await tester.pumpWidget(_app());
      await tester.pump();

      expect(find.byType(SignInPage), findsOneWidget);
      expect(createdCubits, hasLength(1));

      // Let the cubit's 1s startup timer finish so none stays pending.
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('initializes the cubit after the first frame', (tester) async {
      appRouter.go(Routes.signIn);
      await tester.pumpWidget(_app());
      await tester.pump();

      final cubit = createdCubits.single;
      expect(cubit.state.status, DataStatus.loading);

      // initialize() waits one second, then returns to initial.
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(cubit.state.status, DataStatus.initial);
    });

    testWidgets('closes the cubit when the route is left', (tester) async {
      appRouter.go(Routes.signIn);
      await tester.pumpWidget(_app());
      await tester.pump(const Duration(seconds: 2));

      final cubit = createdCubits.single;
      expect(cubit.isClosed, isFalse);

      appRouter.go(Routes.home);
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      expect(cubit.isClosed, isTrue);
    });

    testWidgets('each visit gets a fresh cubit', (tester) async {
      appRouter.go(Routes.signIn);
      await tester.pumpWidget(_app());
      await tester.pump(const Duration(seconds: 2));

      appRouter.go(Routes.home);
      await tester.pumpAndSettle();
      appRouter.go(Routes.signIn);
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      expect(createdCubits, hasLength(2));
      expect(identical(createdCubits.first, createdCubits.last), isFalse);
    });
  });
}
