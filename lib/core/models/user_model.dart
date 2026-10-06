import 'package:easygold_app_v3/core/constants/enums/gender.dart';
import 'package:easygold_app_v3/core/models/address_model.dart';
import 'package:easygold_app_v3/core/utils/gender_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.freezed.dart';
part 'user_model.g.dart';

Object? _readId(
  Map<dynamic, dynamic> json,
  String key,
) {
  return json['_id'] ?? json['id'];
}
@freezed
abstract class UserModel with _$UserModel {
  @JsonSerializable(explicitToJson: true)
  const factory UserModel({
    String? username,
    String? password,
    String? role,
    String? phone,
    String? email,
    String? birthday,
    String? nationality,
    String? department,
    String? career,
    String? financeManageCode,
    String? status,
    String? kyc,
    String? blockDateLogin,
    String? blockLogin,
    String? isPinCode,
    String? pinCode,
    String? hint,
    String? note,
    @Default([]) List<AddressModel> address,
    List<dynamic>? shipment,
    double? numberLogin,
    @EGenderConverter() EGender? gender,
    @JsonKey(readValue: _readId) required String id,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'image_profile') String? imageProfile,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'branch_name') String? branchName,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'image_id_card') String? imageIdCard,
    @JsonKey(name: 'image_account_number') String? imageAccountNumber,
    @JsonKey(name: 'customer_type') String? customerType,
    @JsonKey(name: 'customer_code') String? customerCode,
    @JsonKey(name: 'user_status') String? userStatus,
    @JsonKey(name: 'document_type') String? documentType,
    @JsonKey(name: 'id_card') String? idCard,
    @JsonKey(name: 'family_book') String? familyBook,
    @JsonKey(name: 'bank_name') String? bankName,
    @JsonKey(name: 'account_number') String? accountNumber,
    @JsonKey(name: 'max_buys') double? maxBuys,
    @JsonKey(name: 'is_delete') String? isDelete,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'updated_by') String? updatedBy,
    @JsonKey(name: 'user_point') double? userPoint,
    @JsonKey(name: 'affiliate_code') String? affiliateCode,
    @JsonKey(name: 'affiliate_code_full_name') String? affiliateCodeFullName,
    @JsonKey(name: 'account_name') String? accountName,
    @JsonKey(name: 'expiry_date_id_card') String? expiryDateIdCard,
    @Default([]) @JsonKey(name: 'image_document') List<String> imageDocument,
    @JsonKey(name: 'is_aomkham_account') String? isAomkhamAccount,
    @JsonKey(name: 'reject_reason') String? kycRejectNote,
    @JsonKey(name: 'issue_date') String? issueDate,
    @JsonKey(name: 'first_name_en') String? firstNameEn,
    @JsonKey(name: 'last_name_en') String? lastNameEn,
    @JsonKey(name: 'has_quiz') bool? hasQuiz,
    @JsonKey(name: 'total_buy_today') double? totalBuyToday,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
