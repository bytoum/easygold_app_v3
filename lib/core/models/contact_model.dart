import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_model.freezed.dart';
part 'contact_model.g.dart';

@freezed
abstract class ContactModel with _$ContactModel {
  const factory ContactModel({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "contact_label") String? label,
    String? value,
    @JsonKey(name: "img") String? iconPath,
    @JsonKey(name: "is_active") bool? isActive,
    @JsonKey(name: "created_by") String? createdBy,
    @JsonKey(name: "updated_by") String? updatedBy,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
  }) = _ContactModel;

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);
}

@freezed
abstract class TitleModel with _$TitleModel {
  const factory TitleModel({
    @JsonKey(name: "_id") String? id,
    String? title,
    @JsonKey(name: "created_by") String? createdBy,
    @JsonKey(name: "updated_by") String? updatedBy,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
  }) = _TitleModel;

  factory TitleModel.fromJson(Map<String, dynamic> json) =>
      _$TitleModelFromJson(json);
}

@freezed
abstract class LocationModel with _$LocationModel {
  const factory LocationModel({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "location_name") String? name,
    @JsonKey(name: "address_text") String? address,
    @JsonKey(name: "is_active") bool? isActive,
    @JsonKey(name: "map_url") String? mapUrl,
    @JsonKey(name: "created_by") String? createdBy,
    @JsonKey(name: "updated_by") String? updatedBy,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);
}
