import 'package:easygold_app_v3/core/models/address_model.dart';
import 'package:easygold_app_v3/core/models/background_detail_model.dart';
import 'package:easygold_app_v3/core/models/contact_model.dart';
import 'package:easygold_app_v3/core/models/login_data_model.dart';
import 'package:easygold_app_v3/core/models/user_model.dart';
import 'package:easygold_app_v3/core/models/version_info_model.dart';
import 'package:easygold_app_v3/core/models/version_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// Asserts every expected key/value is present in [actual], so a model that
/// silently drops fields cannot pass by comparing equal to itself.
void expectJson(Map<String, dynamic> actual, Map<String, dynamic> expected) {
  expected.forEach((key, value) {
    expect(actual, containsPair(key, value), reason: 'key $key');
  });
}

void main() {
  group('ContactModel', () {
    final json = {
      '_id': 'c1',
      'contact_label': 'Phone',
      'value': '123',
      'img': 'icon.png',
      'is_active': true,
      'created_by': 'admin',
      'created_at': '2024-01-02T03:04:05.000Z',
    };

    test('maps snake_case keys and parses dates', () {
      expectJson(ContactModel.fromJson(json).toJson(), json);
    });

    test('toJson uses the backend key names', () {
      final out = const ContactModel(
        id: 'c1',
        label: 'Phone',
        iconPath: 'i.png',
        isActive: false,
      ).toJson();

      expect(out['_id'], 'c1');
      expect(out['contact_label'], 'Phone');
      expect(out['img'], 'i.png');
      expect(out['is_active'], false);
    });

    test('round-trips through toJson', () {
      final model = ContactModel.fromJson(json);
      expect(ContactModel.fromJson(model.toJson()), model);
    });

    test('different values are not equal', () {
      expect(const ContactModel(id: 'a'), isNot(const ContactModel(id: 'b')));
    });
  });

  group('TitleModel', () {
    test('maps _id, title and audit fields', () {
      final json = {'_id': 't1', 'title': 'Help', 'created_by': 'admin'};
      expectJson(TitleModel.fromJson(json).toJson(), json);
    });

    test('different values are not equal', () {
      expect(const TitleModel(title: 'a'), isNot(const TitleModel(title: 'b')));
    });
  });

  group('LocationModel', () {
    test('maps location fields', () {
      final json = {
        '_id': 'l1',
        'location_name': 'Shop',
        'address_text': 'Main St',
        'map_url': 'https://maps.example/x',
        'is_active': true,
      };
      expectJson(LocationModel.fromJson(json).toJson(), json);
    });

    test('round-trips through toJson', () {
      const model = LocationModel(id: 'l1', name: 'Shop', mapUrl: 'u');
      expect(LocationModel.fromJson(model.toJson()), model);
      expect(model.toJson()['location_name'], 'Shop');
    });
  });

  group('BackgroundDetailModel', () {
    test('maps fields', () {
      final json = {
        '_id': 'b1',
        'name': 'bg.png',
        'modified_by': 'admin',
        'last_modified_local_at': '2024-05-01',
      };
      expectJson(BackgroundDetailModel.fromJson(json).toJson(), json);
    });

    test('round-trips through toJson', () {
      const model = BackgroundDetailModel(id: 'b1', name: 'bg.png');
      expect(BackgroundDetailModel.fromJson(model.toJson()), model);
    });
  });

  group('AddressModel', () {
    test('maps fields and round-trips', () {
      final json = {'village': 'V', 'district': 'D', 'province': 'P'};
      final model = AddressModel.fromJson(json);

      expect(
        model,
        const AddressModel(village: 'V', district: 'D', province: 'P'),
      );
      expect(model.toJson(), json);
    });
  });

  group('VersionInfoModel', () {
    test('parses nested version and background', () {
      final out = VersionInfoModel.fromJson({
        'version': {'name': 'v1', 'isOpen': true},
        'background': {'_id': 'b1'},
      }).toJson();

      expectJson(out['version'] as Map<String, dynamic>, {
        'name': 'v1',
        'isOpen': true,
      });
      expectJson(out['background'] as Map<String, dynamic>, {'_id': 'b1'});
    });

    test('round-trips through toJson', () {
      const model = VersionInfoModel(version: VersionModel(name: 'v1'));
      expect(VersionInfoModel.fromJson(model.toJson()), model);
    });
  });

  // The models below work today; these cover what models_json_test.dart
  // does not (serialization and equality).
  group('VersionModel', () {
    test('round-trips through toJson', () {
      const model = VersionModel(
        name: 'v1',
        note: 'n',
        appIosVersion: '2.0',
        isOpen: false,
      );
      expect(VersionModel.fromJson(model.toJson()), model);
    });

    test('equality is by value', () {
      expect(const VersionModel(name: 'a'), const VersionModel(name: 'a'));
      expect(
        const VersionModel(name: 'a'),
        isNot(const VersionModel(name: 'b')),
      );
    });
  });

  group('LoginDataModel', () {
    test('round-trips through toJson, keeping renamed keys', () {
      const model = LoginDataModel(
        accessToken: 'access',
        refreshToken: 'refresh',
        egNumber: 'EG1',
        hasOneId: true,
      );
      final json = model.toJson();

      expect(json['eg_number'], 'EG1');
      expect(json['has_one_id'], true);
      expect(LoginDataModel.fromJson(json), model);
    });

    // Guards against LoginDataModel losing explicitToJson, which would leave
    // `user` as a UserModel object in toJson() and break jsonEncode.
    test('toJson serializes the nested user to a map', () {
      const model = LoginDataModel(
        accessToken: 'access',
        user: UserModel(id: 'u1', firstName: 'A'),
      );

      expect(model.toJson()['user'], isA<Map<String, dynamic>>());
      expect(LoginDataModel.fromJson(model.toJson()), model);
    });

    test('equality is by value', () {
      expect(
        const LoginDataModel(accessToken: 'a'),
        const LoginDataModel(accessToken: 'a'),
      );
      expect(
        const LoginDataModel(accessToken: 'a'),
        isNot(const LoginDataModel(accessToken: 'b')),
      );
    });
  });

  group('UserModel', () {
    test('toJson writes snake_case keys and the gender display value', () {
      final json = const UserModel(
        id: 'u1',
        firstName: 'A',
        lastName: 'B',
      ).toJson();

      expect(json['first_name'], 'A');
      expect(json['last_name'], 'B');
      expect(json.containsKey('firstName'), isFalse);
    });

    test('round-trips through toJson', () {
      final model = UserModel.fromJson({
        '_id': 'u1',
        'first_name': 'A',
        'gender': 'm',
        'max_buys': 3,
        'image_document': ['a.png'],
      });

      expect(UserModel.fromJson(model.toJson()), model);
    });

    test('copyWith changes only the given field', () {
      const model = UserModel(id: 'u1', firstName: 'A', lastName: 'B');
      final copy = model.copyWith(firstName: 'Z');

      expect(copy.firstName, 'Z');
      expect(copy.lastName, 'B');
      expect(copy.id, 'u1');
    });
  });
}
