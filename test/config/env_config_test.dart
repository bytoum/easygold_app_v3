import 'package:easygold_app_v3/config/env_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EnvConfig', () {
    test('has the required OTP value configured', () {
      expect(EnvConfig.SECRET_OTP.isNotEmpty, isTrue);
    });

    test('has an HTTP(S) base endpoint configured', () {
      final endpoint = Uri.tryParse(EnvConfig.BASE_END_POINT);
      final isValidHttpEndpoint =
          endpoint != null &&
          (endpoint.scheme == 'http' || endpoint.scheme == 'https') &&
          endpoint.host.isNotEmpty;

      expect(isValidHttpEndpoint, isTrue);
    });
  });
}
