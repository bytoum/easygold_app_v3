import 'package:easygold_app_v3/core/constants/enums/gender.dart';
import 'package:easygold_app_v3/core/utils/gender_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EGender.fromValue', () {
    test('maps male spellings, case-insensitively', () {
      for (final v in ['male', 'Male', 'MALE', 'm', 'M', 'ຜູ້ຊາຍ', 'ຊາຍ']) {
        expect(EGender.fromValue(v), EGender.MALE, reason: v);
      }
    });

    test('maps female spellings, case-insensitively', () {
      for (final v in ['female', 'Female', 'f', 'F', 'ຜູ້ຍິງ', 'ຍິງ']) {
        expect(EGender.fromValue(v), EGender.FEMALE, reason: v);
      }
    });

    test('returns null for null, empty, and unknown values', () {
      expect(EGender.fromValue(null), isNull);
      expect(EGender.fromValue(''), isNull);
      expect(EGender.fromValue('other'), isNull);
    });
  });

  group('EGenderConverter', () {
    const converter = EGenderConverter();

    test('fromJson / toJson', () {
      expect(converter.fromJson('Female'), EGender.FEMALE);
      expect(converter.fromJson(null), isNull);
      expect(converter.toJson(EGender.MALE), 'Male');
      expect(converter.toJson(null), isNull);
    });
  });

  test('IDConverter is an identity conversion', () {
    const converter = IDConverter();
    expect(converter.fromJson('abc'), 'abc');
    expect(converter.toJson('abc'), 'abc');
  });
}
