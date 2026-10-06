import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/models/login_data_model.dart';
import 'package:easygold_app_v3/core/usecases/usecase.dart';
import 'package:easygold_app_v3/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

class SigninWithPasswordParams {
  final String phoneNumber;
  final String password;
  final String uuid;
  final String? code;
  final String? fmcToken;
  final bool isAllowPushNoti;

  SigninWithPasswordParams({
    required this.phoneNumber,
    required this.password,
    required this.uuid,
    this.code,
    this.fmcToken,
    this.isAllowPushNoti = false,
  });
}

@lazySingleton
class SigninWithPasswordUsecase
    implements UseCase<LoginDataModel, SigninWithPasswordParams> {
  final AuthRepository _authRepository;
  SigninWithPasswordUsecase(this._authRepository);
  @override
  Future<Either<Failure, LoginDataModel>> call(
    SigninWithPasswordParams params,
  ) async {
    return await _authRepository.signInWithPassword(
      phoneNumber: params.phoneNumber,
      password: params.password,
      uuid: params.uuid,
      code: params.code,
      fmcToken: params.fmcToken,
      isAllowPushNoti: params.isAllowPushNoti,
    );
  }
}
