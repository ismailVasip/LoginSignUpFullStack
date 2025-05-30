class UserEntity {
  final String fullName;
  final String email;
  final String phoneNumber;
  final bool isEmailVerified;

  UserEntity({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.isEmailVerified,
  });
}
