import 'package:dio/dio.dart';
import 'package:easygold_app_v3/core/errors/exceptions.dart';
import 'package:easygold_app_v3/core/models/login_data_model.dart';
import 'package:easygold_app_v3/core/network/rest_client.dart';
import 'package:injectable/injectable.dart';

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
      throw ServerException(
        e.response?.data ?? e.message ?? 'Unknown error',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
