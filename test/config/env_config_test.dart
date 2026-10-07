import 'package:easygold_app_v3/config/env_config.dart';
import 'package:flutter_test/flutter_test.dart';

/// These tests check the *shape* of the config only. They never assert on,
/// print, or embed the values: they come from the local .env and several are
/// secrets, so every expectation is on a derived boolean.
void main() {
  final values = <String, String Function()>{
    'SECRET_OTP': () => EnvConfig.SECRET_OTP,
    'BASE_END_POINT': () => EnvConfig.BASE_END_POINT,
    'AWS_ACCESS_KEY': () => EnvConfig.AWS_ACCESS_KEY,
    'AWS_SECRET_KEY': () => EnvConfig.AWS_SECRET_KEY,
    'AWS_BUCKET_NAME': () => EnvConfig.AWS_BUCKET_NAME,
    'AWS_REGION': () => EnvConfig.AWS_REGION,
  };

  group('deobfuscation', () {
    values.forEach((name, read) {
      test('$name can be read without throwing', () {
        expect(() => read(), returnsNormally);
      });
    });
  });

  group('required fields', () {
    for (final name in ['SECRET_OTP', 'BASE_END_POINT']) {
      test('$name is not empty', () {
        expect(values[name]!().isNotEmpty, isTrue);
      });
    }

    test('BASE_END_POINT is an absolute http(s) URL', () {
      final uri = Uri.tryParse(EnvConfig.BASE_END_POINT);

      expect(uri != null && uri.hasAuthority, isTrue);
      expect(
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https'),
        isTrue,
      );
    });
  });

  group('optional AWS fields', () {
    test('AWS_REGION is never empty (it has a default)', () {
      expect(EnvConfig.AWS_REGION.isNotEmpty, isTrue);
    });

    test('AWS_REGION looks like a region id', () {
      expect(
        RegExp(r'^[a-z]{2}(-[a-z]+)+-\d+$').hasMatch(EnvConfig.AWS_REGION),
        isTrue,
      );
    });

    test('credentials are either both set or both empty', () {
      final hasKey = EnvConfig.AWS_ACCESS_KEY.isNotEmpty;
      final hasSecret = EnvConfig.AWS_SECRET_KEY.isNotEmpty;

      expect(hasKey == hasSecret, isTrue);
    });
  });
}
