import 'package:freezed_annotation/freezed_annotation.dart';
part 'address_model.freezed.dart';
part 'address_model.g.dart';

@JsonSerializable()
@freezed
class AddressModel with _$AddressModel {
  const AddressModel({String? village, String? district, String? province});
  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}
