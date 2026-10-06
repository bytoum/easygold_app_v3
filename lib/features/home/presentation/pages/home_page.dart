import 'package:easy_localization/easy_localization.dart';
import 'package:easygold_app_v3/config/routes/app_router.dart';
import 'package:easygold_app_v3/generated/locale_keys.g.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const new({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(LocaleKeys.welcome.tr()),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.push(Routes.signIn);
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
