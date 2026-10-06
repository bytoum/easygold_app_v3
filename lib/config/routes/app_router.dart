import 'package:easygold_app_v3/core/DI/service_locator.dart';
import 'package:easygold_app_v3/core/widgets/not_found_widget.dart';
import 'package:easygold_app_v3/core/widgets/splash_screen.dart';
import 'package:easygold_app_v3/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:easygold_app_v3/features/auth/presentation/pages/sign_in/sign_in_page.dart';
import 'package:easygold_app_v3/features/home/presentation/pages/home_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
part 'routes.dart';

final appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: Routes.signIn,
      builder: (context, state) => BlocProvider<AuthCubit>(
        create: (context) {
          final authCubit = getIt<AuthCubit>();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (authCubit.isClosed) return;
            authCubit.initialize();
          });
          return authCubit;
        },
        child: const SignInPage(),
      ),
    ),
    GoRoute(path: Routes.home, builder: (context, state) => const HomePage()),
  ],
  errorBuilder: (context, state) => NotFoundWidget(),
  redirect: (BuildContext context, GoRouterState state) {
    // no need to redirect at all
    // final auth =  getIt<AuthCubit>();
    // if(!auth.isAuthenticated && state.uri.path != Routes.splash){
    //   return Routes.signIn;
    // }
    return null;
  },
);
