import 'package:easygold_app_v3/core/constants/enums/data_status.dart';
import 'package:easygold_app_v3/core/extensions/either_extension.dart';
import 'package:easygold_app_v3/features/auth/domain/usecases/signin_with_password_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._signinWithPasswordUsecase) : super(const AuthState());

  final SigninWithPasswordUsecase _signinWithPasswordUsecase;

  Future<void> initialize() async {
    emit(state.copyWith(status: DataStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(status: DataStatus.initial));
  }

  Future<void> signInWithPassword({
    required String phoneNumber,
    required String password,
  }) async {
    emit(state.copyWith(status: DataStatus.loading));
    String fmcToken =
        "<FMC_TOKEN>"; //TODO: Replace with actual token retrieval logic
    String code =
        "<CODE_FOR_YOU>"; //TODO: Replace with actual code retrieval logic
    bool isAllowPushNoti = true; //TODO: Replace with actual logic to determine if push notifications are allowed

    String localUUID =
        "DEVICE_UUID"; //TODO: Replace with actual device UUID retrieval logic
    final result = await _signinWithPasswordUsecase(
      SigninWithPasswordParams(
        phoneNumber: phoneNumber,
        password: password,
        uuid: localUUID,
        code: code,
        fmcToken: fmcToken,
        isAllowPushNoti: isAllowPushNoti,
      ),
    );
    if (result.isLeft()) {
      emit(
        state.copyWith(
          status: DataStatus.failure,
          errorMessage: result.getLeft?.msg,
        ),
      );
    } else {
      emit(state.copyWith(status: DataStatus.success));
    }
  }
}
