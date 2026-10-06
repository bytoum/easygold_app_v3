import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/errors/exceptions.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/models/login_data_model.dart';
import 'package:easygold_app_v3/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:easygold_app_v3/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  AuthRepositoryImpl(this._authRemoteDataSource);

  @override
  Future<Either<Failure, LoginDataModel>> signInWithPassword({
    required String phoneNumber,
    required String password,
    required String uuid,
    String? code,
    String? fmcToken,
    bool isAllowPushNoti = false,
  }) async {
    try {
      final result = await _authRemoteDataSource.signInWithPassword(
        phoneNumber: phoneNumber,
        password: password,
        uuid: uuid,
        code: code,
        fmcToken: fmcToken,
        isAllowPushNoti: isAllowPushNoti,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
