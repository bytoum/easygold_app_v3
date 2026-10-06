import 'package:easy_localization/easy_localization.dart';
import 'package:easygold_app_v3/core/DI/service_locator.config.dart';
import 'package:material_ui/material_ui.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;
@injectableInit
Future<void> configureDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  //TODO: Initial dependencies
  await getIt.init();
}
