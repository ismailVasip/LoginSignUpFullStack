import 'package:login_signup_frontend/features/home/domain/entities/user.dart';

class UserModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final bool isEmailVerified;

  UserModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.isEmailVerified,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      isEmailVerified: map['isEmailConfirmed'] as bool,
    );
  }
}

extension UserModelExtension on UserModel {
  UserEntity toEntity(){
    return UserEntity(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      isEmailVerified: isEmailVerified,
    );
  }
}
