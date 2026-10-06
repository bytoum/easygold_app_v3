import 'dart:convert';

import 'package:easygold_app_v3/core/errors/exceptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageService {
  Future<bool> setString({required String key, required String value});
  String? getString(String key);
  Future<bool> setObject({
    required String key,
    required Map<String, dynamic> value,
  });

  Map<String, dynamic>? getObject(String key);

  // Secure storage methods
  Future<void> writeSecureData(String key, String value);
  Future<String?> readSecureData(String key);
  Future<void> deleteSecureData(String key);
}

@LazySingleton(as: StorageService)
class StorageServiceImpl implements StorageService {
  final SharedPreferences _sharedPreferences;
  final FlutterSecureStorage _secureStorage;

  StorageServiceImpl({
    required this._sharedPreferences,
    required this._secureStorage,
  });
  @override
  Future<bool> setString({required String key, required String value}) async {
    return await _sharedPreferences.setString(key, value);
  }

  @override
  String? getString(String key) {
    return _sharedPreferences.getString(key);
  }

  @override
  Future<bool> setObject({
    required String key,
    required Map<String, dynamic> value,
  }) {
    try {
      final jsonString = jsonEncode(value);
      return _sharedPreferences.setString(key, jsonString);
    } catch (e) {
      throw CacheException('Failed to encode object to JSON: $e');
    }
  }

  @override
  Map<String, dynamic>? getObject(String key) {
    final jsonString = _sharedPreferences.getString(key);
    if (jsonString == null) {
      return null;
    }
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return jsonMap;
    } catch (e) {
      throw CacheException('Failed to decode JSON to object: $e');
    }
  }

  @override
  Future<void> writeSecureData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> readSecureData(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key);
  }
}
