import 'package:easygold_app_v3/core/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_data_model.freezed.dart';
part 'login_data_model.g.dart';

@freezed
abstract class LoginDataModel with _$LoginDataModel {
  @JsonSerializable(explicitToJson: true)
  const factory LoginDataModel({
    required String accessToken,
    String? financeManageCode,
    @JsonKey(name: 'eg_number') String? egNumber,
    @JsonKey(name: 'has_one_id') bool? hasOneId,
    String? oic,
    bool? verified,
    UserModel? user,
    String? refreshToken,
  }) = _LoginDataModel;
  factory LoginDataModel.fromJson(Map<String, dynamic> json) =>
      _$LoginDataModelFromJson(json);
}
