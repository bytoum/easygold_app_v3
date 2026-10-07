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
  late StorageServiceImpl service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    secure = _MockSecureStorage();
    service = StorageServiceImpl(
      sharedPreferences: prefs,
      secureStorage: secure,
    );
  });

  group('shared preferences', () {
    test('setString / getString round-trip', () async {
      expect(await service.setString(key: 'k', value: 'v'), isTrue);
      expect(service.getString('k'), 'v');
      expect(service.getString('missing'), isNull);
    });

    test('setObject / getObject round-trip', () async {
      await service.setObject(key: 'o', value: {'a': 1, 'b': 'x'});
      expect(service.getObject('o'), {'a': 1, 'b': 'x'});
    });

    test('getObject returns null when key is absent', () {
      expect(service.getObject('missing'), isNull);
    });

    test('getObject throws CacheException on invalid JSON', () async {
      await prefs.setString('bad', 'not json');
      expect(() => service.getObject('bad'), throwsA(isA<CacheException>()));
    });

    test('setObject throws CacheException when value is not encodable', () {
      expect(
        () => service.setObject(key: 'o', value: {'a': Object()}),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('secure storage', () {
    test('writeSecureData delegates to secure storage', () async {
      when(() => secure.write(key: 'k', value: 'v')).thenAnswer((_) async {});
      await service.writeSecureData('k', 'v');
      verify(() => secure.write(key: 'k', value: 'v')).called(1);
    });

    test('readSecureData returns the stored value', () async {
      when(() => secure.read(key: 'k')).thenAnswer((_) async => 'v');
      expect(await service.readSecureData('k'), 'v');
    });

    test('deleteSecureData delegates to secure storage', () async {
      when(() => secure.delete(key: 'k')).thenAnswer((_) async {});
      await service.deleteSecureData('k');
      verify(() => secure.delete(key: 'k')).called(1);
    });

    test('never touches shared preferences for secure data', () async {
      when(() => secure.write(key: 'k', value: 'v')).thenAnswer((_) async {});
      await service.writeSecureData('k', 'v');
      expect(prefs.getKeys(), isEmpty);
    });
  });
}
