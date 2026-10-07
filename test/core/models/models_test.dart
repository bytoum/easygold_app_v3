import 'package:easygold_app_v3/core/constants/enums/gender.dart';
import 'package:easygold_app_v3/core/models/base_response.dart';
import 'package:easygold_app_v3/core/models/contact_model.dart';
import 'package:easygold_app_v3/core/models/login_data_model.dart';
import 'package:easygold_app_v3/core/models/user_model.dart';
import 'package:easygold_app_v3/core/models/version_info_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BaseResponse', () {
    test('parses data with the supplied factory and applies defaults', () {
      final res = BaseResponse<int>.fromJson({'data': 5}, (o) => o as int);
      expect(res.data, 5);
      expect(res.error, isFalse);
      expect(res.message, isNull);
    });

    test('reads error and message', () {
      final res = BaseResponse<String>.fromJson({
        'data': 'x',
        'error': true,
        'message': 'bad',
      }, (o) => o as String);
      expect(res.error, isTrue);
      expect(res.message, 'bad');
    });
  });

  group('UserModel', () {
    test('reads id from _id, falling back to id', () {
      expect(UserModel.fromJson({'_id': 'a', 'id': 'b'}).id, 'a');
      expect(UserModel.fromJson({'id': 'b'}).id, 'b');
    });

    test('maps snake_case keys, gender converter and defaults', () {
      final user = UserModel.fromJson({
        '_id': 'u1',
        'first_name': 'A',
        'last_name': 'B',
        'gender': 'f',
        'max_buys': 3,
        'address': [
          {'village': 'v', 'district': 'd', 'province': 'p'},
        ],
      });
      expect(user.firstName, 'A');
      expect(user.lastName, 'B');
      expect(user.gender, EGender.FEMALE);
      expect(user.maxBuys, 3.0);
      expect(user.address.single.province, 'p');
      expect(user.imageDocument, isEmpty);
    });

    test('round-trips through toJson with snake_case keys', () {
      final json = UserModel.fromJson({
        '_id': 'u1',
        'first_name': 'A',
        'gender': 'Male',
      }).toJson();
      expect(json['first_name'], 'A');
      expect(json['gender'], 'Male');
    });

    test('throws when id is missing', () {
      expect(() => UserModel.fromJson({}), throwsA(isA<TypeError>()));
    });
  });

  group('LoginDataModel', () {
    test('parses nested user and renamed keys', () {
      final m = LoginDataModel.fromJson({
        'accessToken': 't',
        'eg_number': '123',
        'has_one_id': true,
        'user': {'_id': 'u'},
      });
      expect(m.accessToken, 't');
      expect(m.egNumber, '123');
      expect(m.hasOneId, isTrue);
      expect(m.user?.id, 'u');
      expect(m.refreshToken, isNull);
    });

    test('requires accessToken', () {
      expect(() => LoginDataModel.fromJson({}), throwsA(isA<TypeError>()));
    });
  });

  test('VersionInfoModel parses nested version and background', () {
    final m = VersionInfoModel.fromJson({
      'version': {'name': 'v1', 'isOpen': true},
      'background': {'_id': 'bg', 'created_at': '2026-01-02T03:04:05.000Z'},
    });
    expect(m.version?.name, 'v1');
    expect(m.version?.isOpen, isTrue);
    expect(m.background?.id, 'bg');
    expect(m.background?.createdAt, DateTime.utc(2026, 1, 2, 3, 4, 5));
  });

  test('ContactModel parses renamed keys and dates', () {
    final m = ContactModel.fromJson({
      '_id': 'c',
      'contact_label': 'Phone',
      'img': 'p.png',
      'is_active': true,
      'created_at': '2026-01-02T00:00:00.000Z',
    });
    expect(m.id, 'c');
    expect(m.label, 'Phone');
    expect(m.iconPath, 'p.png');
    expect(m.isActive, isTrue);
    expect(m.createdAt, DateTime.utc(2026, 1, 2));
  });
}
