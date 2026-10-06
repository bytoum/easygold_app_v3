import 'package:easygold_app_v3/core/constants/enums/gender.dart';
import 'package:json_annotation/json_annotation.dart';

class EGenderConverter implements JsonConverter<EGender?, String?> {
  const EGenderConverter();

  @override
  EGender? fromJson(String? json) => EGender.fromValue(json);

  @override
  String? toJson(EGender? object) => object?.value;
}

class IDConverter implements JsonConverter<String, String> {
  const IDConverter();

  @override
  String fromJson(String json) {
    return json;
  }

  @override
  String toJson(String object) => object;
}
