import 'package:dio/dio.dart';
import 'package:easygold_app_v3/core/errors/exceptions.dart';
import 'package:easygold_app_v3/core/models/login_data_model.dart';
import 'package:easygold_app_v3/core/network/rest_client.dart';
import 'package:injectable/injectable.dart';
import 'package:material_ui/material_ui.dart';

abstract class AuthRemoteDataSource {
  Future<LoginDataModel> signInWithPassword({
    required String phoneNumber,
    required String password,
    required String uuid,
    String? code,
    String? fmcToken,
    bool isAllowPushNoti = false,
  });
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthClient _authClient;
  AuthRemoteDataSourceImpl(this._authClient);

  @override
  Future<LoginDataModel> signInWithPassword({
    required String phoneNumber,
    required String password,
    required String uuid,
    String? code,
    String? fmcToken,
    bool isAllowPushNoti = false,
  }) async {
    try {
      final response = await _authClient.signInWithPassword(
        code,
        fmcToken,
        isAllowPushNoti.toString(),
        uuid,
        {'username': phoneNumber, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(_serverMessage(e));
    } catch (e) {
      debugPrint('signInWithPassword failed: ${e.runtimeType}');
      throw const ServerException('');
    }
  }

  /// Returns the backend's `message` only when it is a short string.
  /// Anything else yields '' so the UI falls back to a localized message
  /// instead of showing a raw response body or exception text.
  static const _maxMessageLength = 200;

  String _serverMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final message = data['message'];
      if (message is String) {
        final trimmed = message.trim();
        if (trimmed.isNotEmpty && trimmed.length <= _maxMessageLength) {
          return trimmed;
        }
      }
    }
    return '';
  }
}
