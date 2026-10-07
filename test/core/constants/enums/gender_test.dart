import 'package:easygold_app_v3/core/constants/enums/gender.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EGender.fromValue', () {
    test('maps male aliases to MALE', () {
      for (final value in ['male', 'Male', 'MALE', 'm', 'M', 'ຜູ້ຊາຍ', 'ຊາຍ']) {
        expect(EGender.fromValue(value), EGender.MALE, reason: value);
      }
    });

    test('maps female aliases to FEMALE', () {
      for (final value in [
        'female',
        'Female',
        'FEMALE',
        'f',
        'F',
        'ຜູ້ຍິງ',
        'ຍິງ',
      ]) {
        expect(EGender.fromValue(value), EGender.FEMALE, reason: value);
      }
    });

    test('returns null for null, empty and unknown values', () {
      expect(EGender.fromValue(null), isNull);
      expect(EGender.fromValue(''), isNull);
      expect(EGender.fromValue('other'), isNull);
    });
  });

  test('value exposes the display string', () {
    expect(EGender.MALE.value, 'Male');
    expect(EGender.FEMALE.value, 'Female');
  });
}
