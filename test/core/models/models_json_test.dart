import 'package:easygold_app_v3/core/constants/enums/gender.dart';
import 'package:easygold_app_v3/core/models/base_response.dart';
import 'package:easygold_app_v3/core/models/login_data_model.dart';
import 'package:easygold_app_v3/core/models/user_model.dart';
import 'package:easygold_app_v3/core/models/version_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('VersionModel maps fields', () {
    final model = VersionModel.fromJson({
      'name': 'v1',
      'note': 'n',
      'appAndroidVersion': '1.2.3',
      'isOpen': true,
    });
    expect(model.name, 'v1');
    expect(model.note, 'n');
    expect(model.appAndroidVersion, '1.2.3');
    expect(model.isOpen, isTrue);
    expect(model.appIosVersion, isNull);
  });

  group('BaseResponse', () {
    test('parses data with the supplied factory and applies defaults', () {
      final response = BaseResponse<String>.fromJson({
        'data': 'ok',
      }, (o) => o as String);
      expect(response.data, 'ok');
      expect(response.error, isFalse);
      expect(response.message, isNull);
    });

    test('reads error and message', () {
      final response = BaseResponse<int>.fromJson({
        'data': 1,
        'error': true,
        'message': 'bad',
      }, (o) => o as int);
      expect(response.error, isTrue);
      expect(response.message, 'bad');
    });
  });

  group('UserModel', () {
    test('reads id from _id, falling back to id', () {
      expect(UserModel.fromJson({'_id': 'a'}).id, 'a');
      expect(UserModel.fromJson({'id': 'b'}).id, 'b');
      expect(UserModel.fromJson({'_id': 'a', 'id': 'b'}).id, 'a');
    });

    test('maps snake_case fields, gender converter and defaults', () {
      final user = UserModel.fromJson({
        '_id': 'u1',
        'first_name': 'A',
        'last_name': 'B',
        'gender': 'f',
        'max_buys': 5,
        'address': [
          {'province': 'P'},
        ],
      });
      expect(user.firstName, 'A');
      expect(user.lastName, 'B');
      expect(user.gender, EGender.FEMALE);
      expect(user.maxBuys, 5.0);
      expect(user.address, hasLength(1));
      expect(user.imageDocument, isEmpty);
    });

    test('unknown gender becomes null', () {
      expect(UserModel.fromJson({'_id': 'u', 'gender': '?'}).gender, isNull);
    });
  });

  group('LoginDataModel', () {
    test('maps tokens, renamed keys and nested user', () {
      final data = LoginDataModel.fromJson({
        'accessToken': 'access',
        'refreshToken': 'refresh',
        'eg_number': 'EG1',
        'has_one_id': true,
        'verified': false,
        'user': {'_id': 'u1'},
      });
      expect(data.accessToken, 'access');
      expect(data.refreshToken, 'refresh');
      expect(data.egNumber, 'EG1');
      expect(data.hasOneId, isTrue);
      expect(data.verified, isFalse);
      expect(data.user?.id, 'u1');
    });

    test('requires accessToken', () {
      expect(() => LoginDataModel.fromJson({}), throwsA(isA<TypeError>()));
    });
  });
}
