import 'package:envied/envied.dart';
part 'env_config.g.dart';
@Envied(path: '.env')
abstract class EnvConfig {
  @EnviedField(obfuscate: true)
  static String SECRET_OTP = _EnvConfig.SECRET_OTP;
  @EnviedField(obfuscate: true)
  static String BASE_END_POINT = _EnvConfig.BASE_END_POINT;
}