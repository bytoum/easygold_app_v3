import 'package:easygold_app_v3/core/widgets/not_found_widget.dart';
import 'package:easygold_app_v3/core/widgets/splash_screen.dart';
import 'package:easygold_app_v3/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
part 'routes.dart';

final appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) => HomePage(),
    ),
  ],
  errorBuilder: (context, state) => NotFoundWidget(),
  redirect: (BuildContext context, GoRouterState state){
    // no need to redirect at all
    return null;
  }
);
