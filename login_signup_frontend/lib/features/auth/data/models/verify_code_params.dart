class VerifyCodeParams {
  final String email;
  final String verificationCode;

  VerifyCodeParams({required this.email, required this.verificationCode});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'verificationCode': verificationCode,
    };
  }

}
