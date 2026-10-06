import 'package:freezed_annotation/freezed_annotation.dart';
part 'version_model.freezed.dart';
part 'version_model.g.dart';

@freezed
@JsonSerializable()
class VersionModel with _$VersionModel {
  final String? name;
  final String? note;
  final String? appAndroidVersionStore;
  final String? appIosVersionStore;
  final String? appAndroidVersion;
  final String? appIosVersion;
  final bool? isOpen;

  const VersionModel({
    this.name,
    this.note,
    this.appAndroidVersionStore,
    this.appIosVersionStore,
    this.appAndroidVersion,
    this.appIosVersion,
    this.isOpen,
  });

  factory VersionModel.fromJson(Map<String, Object?> json) =>
      _$VersionModelFromJson(json);

  Map<String, Object?> toJson() => _$VersionModelToJson(this);
}
