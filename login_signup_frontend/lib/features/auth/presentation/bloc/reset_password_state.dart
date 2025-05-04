class ResetPasswordState {
  final String email;
  final bool isEmailSent;

  const ResetPasswordState({
    this.email = '',
    this.isEmailSent = false,
  });

  ResetPasswordState copyWith({
    String? email,
    bool? isEmailSent,
  }) {
    return ResetPasswordState(
      email: email ?? this.email,
      isEmailSent: isEmailSent ?? this.isEmailSent,
    );
  }
}
