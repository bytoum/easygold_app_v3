import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class InjectionModule {
  @preResolve // Async initialization
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
  //TODO: Register modules
}