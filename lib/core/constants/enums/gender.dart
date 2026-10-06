enum EGender {
  MALE("Male"),
  FEMALE("Female");

  final String value;
  const EGender(this.value);

  static EGender? fromValue(String? value) {
    switch (value?.toLowerCase()) {
      case "male":
      case "m":
      case "ຜູ້ຊາຍ":
      case "ຊາຍ":
        return EGender.MALE;
      case "female":
      case "f":
      case "ຜູ້ຍິງ":
      case "ຍິງ":
        return EGender.FEMALE;
      default:
        return null;
    }
  }

  // String get name {
  //   switch (this) {
  //     case EGender.MALE:
  //       return LocaleKeys.user_info_gender_gender_male.tr();
  //     case EGender.FEMALE:
  //       return LocaleKeys.user_info_gender_gender_female.tr();
  //   }
  // }
}
