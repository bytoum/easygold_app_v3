import 'package:easygold_app_v3/core/errors/exceptions.dart';
import 'package:easygold_app_v3/core/services/storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late SharedPreferences prefs;
  late _MockSecureStorage secure;
  late StorageServiceImpl storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    secure = _MockSecureStorage();
    storage = StorageServiceImpl(
      sharedPreferences: prefs,
      secureStorage: secure,
    );
  });

  group('plain storage', () {
    test('setString/getString round-trip', () async {
      expect(await storage.setString(key: 'k', value: 'v'), isTrue);
      expect(storage.getString('k'), 'v');
    });

    test('getString returns null for a missing key', () {
      expect(storage.getString('missing'), isNull);
    });

    test('setObject/getObject round-trip a JSON map', () async {
      await storage.setObject(
        key: 'obj',
        value: {
          'a': 1,
          'b': ['x'],
        },
      );
      expect(storage.getObject('obj'), {
        'a': 1,
        'b': ['x'],
      });
    });

    test('getObject returns null for a missing key', () {
      expect(storage.getObject('missing'), isNull);
    });

    test(
      'setObject throws CacheException when the value cannot be encoded',
      () {
        expect(
          () => storage.setObject(key: 'bad', value: {'x': Object()}),
          throwsA(isA<CacheException>()),
        );
        expect(prefs.containsKey('bad'), isFalse);
      },
    );

    test('getObject throws CacheException for invalid JSON', () async {
      await prefs.setString('bad', '{not json');
      expect(() => storage.getObject('bad'), throwsA(isA<CacheException>()));
    });

    test(
      'getObject throws CacheException when JSON is not an object',
      () async {
        await prefs.setString('list', '[1,2]');
        expect(() => storage.getObject('list'), throwsA(isA<CacheException>()));
      },
    );
  });

  group('secure storage', () {
    test('writeSecureData delegates to FlutterSecureStorage only', () async {
      when(() => secure.write(key: 'token', value: 'abc'))
          .thenAnswer((_) async {});

      await storage.writeSecureData('token', 'abc');

      verify(() => secure.write(key: 'token', value: 'abc')).called(1);
      expect(
        prefs.getKeys(),
        isEmpty,
        reason: 'secrets must not reach SharedPreferences',
      );
    });

    test('readSecureData returns the stored value or null', () async {
      when(() => secure.read(key: 'token')).thenAnswer((_) async => 'abc');
      when(() => secure.read(key: 'none')).thenAnswer((_) async => null);

      expect(await storage.readSecureData('token'), 'abc');
      expect(await storage.readSecureData('none'), isNull);
    });

    test('deleteSecureData delegates to FlutterSecureStorage', () async {
      when(() => secure.delete(key: 'token')).thenAnswer((_) async {});

      await storage.deleteSecureData('token');

      verify(() => secure.delete(key: 'token')).called(1);
    });
  });
}
