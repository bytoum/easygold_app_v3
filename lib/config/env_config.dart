import 'package:envied/envied.dart';
part 'env_config.g.dart';

@Envied(path: '.env')
abstract class EnvConfig {
  @EnviedField(obfuscate: true)
  static String SECRET_OTP = _EnvConfig.SECRET_OTP;
  @EnviedField(obfuscate: true)
  static String BASE_END_POINT = _EnvConfig.BASE_END_POINT;

  @EnviedField(obfuscate: true, optional: true, defaultValue: '')
  static String AWS_ACCESS_KEY = _EnvConfig.AWS_ACCESS_KEY;
  @EnviedField(obfuscate: true, optional: true, defaultValue: '')
  static String AWS_SECRET_KEY = _EnvConfig.AWS_SECRET_KEY;
  @EnviedField(obfuscate: true, optional: true, defaultValue: '')
  static String AWS_BUCKET_NAME = _EnvConfig.AWS_BUCKET_NAME;
  @EnviedField(obfuscate: true, optional: true, defaultValue: 'ap-southeast-1')
  static String AWS_REGION = _EnvConfig.AWS_REGION;
}
