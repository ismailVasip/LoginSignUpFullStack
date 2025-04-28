
import 'package:login_signup_frontend/common/enums/gender.dart';

class SignUpRequestParams {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final Gender gender;
  final DateTime birthDate;
  final List<String> roles = ['User']; // Default role is 'User'

  // final String accessToken;
  // final String refreshToken;
  // final String refreshTokenExpireTime;

  SignUpRequestParams({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    required this.gender,
    required this.birthDate,
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
      'phoneNumber': phoneNumber,
      'gender': gender,
      'birthDate': birthDate.millisecondsSinceEpoch,
      // 'accessToken': accessToken,
      // 'refreshToken': refreshToken,
      // 'refreshTokenExpireTime': refreshTokenExpireTime,
    };
  }
}
