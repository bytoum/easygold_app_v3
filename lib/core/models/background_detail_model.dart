import 'package:freezed_annotation/freezed_annotation.dart';
part 'background_detail_model.freezed.dart';
part 'background_detail_model.g.dart';

@freezed
abstract class BackgroundDetailModel with _$BackgroundDetailModel {
  const factory BackgroundDetailModel({
    @JsonKey(name: "_id") String? id,
    String? name,
    @JsonKey(name: "modified_by") String? modifiedBy,
    @JsonKey(name: "last_modified_local_at") String? lastModifiedLocalAt,
    @JsonKey(name: "created_at") DateTime? createdAt,
  }) = _BackgroundDetailModel;

  factory BackgroundDetailModel.fromJson(Map<String, dynamic> json) =>
      _$BackgroundDetailModelFromJson(json);
}
