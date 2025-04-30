

class SignUpRequestParams {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final int gender;
  final String birthDate;
  final List<String> roles; // Default role is 'User'

  // final String accessToken;
  // final String refreshToken;
  // final String refreshTokenExpireTime;

  SignUpRequestParams({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.gender,
    required this.phoneNumber,
    required this.birthDate,
    required this.roles,
    // required this.accessToken,
    // required this.refreshToken,
    // required this.refreshTokenExpireTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'dateOfBirth': birthDate,
      'roles': roles,
      // 'accessToken': accessToken,
      // 'refreshToken': refreshToken,
      // 'refreshTokenExpireTime': refreshTokenExpireTime,
      // 'accessToken': accessToken,
      // 'refreshToken': refreshToken,
      // 'refreshTokenExpireTime': refreshTokenExpireTime,
    };
  }
}
