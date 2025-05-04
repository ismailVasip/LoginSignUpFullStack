class ForgotPasswordParams {
  final String email;

  ForgotPasswordParams({required this.email});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
    };
  }
}
