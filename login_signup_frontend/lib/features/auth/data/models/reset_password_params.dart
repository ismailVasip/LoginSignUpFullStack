class ResetPasswordParams {
  final String email;
  final String token;
  final String password;
  final String confirmPassword;

  ResetPasswordParams({
    required this.email,
    required this.token,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'token': token,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
