part of 'auth_cubit.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(DataStatus.initial) DataStatus status,
    String? errorMessage,
  }) = _AuthState;
}
