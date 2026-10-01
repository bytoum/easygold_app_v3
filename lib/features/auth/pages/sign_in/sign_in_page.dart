import 'package:easygold_app_v3/config/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(Routes.home);
          },
        ),
      ),
      body: const Center(
        child: Text('Welcome to the Sign In Page!'),
      ),
    );
  }
}