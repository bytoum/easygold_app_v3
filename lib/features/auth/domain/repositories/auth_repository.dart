import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/models/login_data_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginDataModel>> signInWithPassword({
    required String phoneNumber,
    required String password,
    required String uuid,
    String? code,
    String? fmcToken,
    bool isAllowPushNoti = false,
  });
}