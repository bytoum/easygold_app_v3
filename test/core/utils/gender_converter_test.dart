import 'package:easygold_app_v3/core/constants/enums/gender.dart';
import 'package:easygold_app_v3/core/utils/gender_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EGenderConverter', () {
    const converter = EGenderConverter();

    test('fromJson parses known values and null', () {
      expect(converter.fromJson('male'), EGender.MALE);
      expect(converter.fromJson('F'), EGender.FEMALE);
      expect(converter.fromJson(null), isNull);
      expect(converter.fromJson('unknown'), isNull);
    });

    test('toJson returns the display value or null', () {
      expect(converter.toJson(EGender.MALE), 'Male');
      expect(converter.toJson(EGender.FEMALE), 'Female');
      expect(converter.toJson(null), isNull);
    });
  });

  group('IDConverter', () {
    const converter = IDConverter();

    test('round-trips the string unchanged', () {
      expect(converter.fromJson('abc-123'), 'abc-123');
      expect(converter.toJson('abc-123'), 'abc-123');
    });
  });
}
