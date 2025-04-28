enum Gender {
  male,
  female,
  other,
  unspecified,
}
extension GenderExtension on Gender {
  int get value {
    switch (this) {
      case Gender.male:
        return 0;
      case Gender.female:
        return 1;
      case Gender.other:
        return 2;
      case Gender.unspecified:
        return 3;
    }
  }
}
