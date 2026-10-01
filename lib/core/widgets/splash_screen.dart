import 'package:easygold_app_v3/config/routes/app_router.dart';
import 'package:easygold_app_v3/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 1;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    setState(() {
      _opacity = 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 500),
        child: Assets.images.animatedLaunch.image(
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
        onEnd: () {
          context.go(Routes.home);
        },
      )
    );
  }
}
