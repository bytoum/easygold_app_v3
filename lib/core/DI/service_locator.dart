import 'package:easygold_app_v3/core/DI/service_locator.config.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;
@injectableInit
Future<void>configureDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  //TODO: Initial dependencies
  await getIt.init();
}