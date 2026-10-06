import 'package:easygold_app_v3/core/models/background_detail_model.dart';
import 'package:easygold_app_v3/core/models/version_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'version_info_model.freezed.dart';
part 'version_info_model.g.dart';

@freezed
@JsonSerializable()
class VersionInfoModel with _$VersionInfoModel {
  const VersionInfoModel({
    VersionModel? version,
    BackgroundDetailModel? background,
  });

  factory VersionInfoModel.fromJson(Map<String, Object?> json) =>
      _$VersionInfoModelFromJson(json);

  Map<String, Object?> toJson() => _$VersionInfoModelToJson(this);
}
