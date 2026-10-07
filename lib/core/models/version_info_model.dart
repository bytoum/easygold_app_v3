import 'package:easygold_app_v3/core/models/background_detail_model.dart';
import 'package:easygold_app_v3/core/models/version_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'version_info_model.freezed.dart';
part 'version_info_model.g.dart';

@freezed
abstract class VersionInfoModel with _$VersionInfoModel {
  @JsonSerializable(explicitToJson: true)
  const factory VersionInfoModel({
    VersionModel? version,
    BackgroundDetailModel? background,
  }) = _VersionInfoModel;

  factory VersionInfoModel.fromJson(Map<String, Object?> json) =>
      _$VersionInfoModelFromJson(json);
}
