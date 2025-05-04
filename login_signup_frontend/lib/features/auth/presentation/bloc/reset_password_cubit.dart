import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_signup_frontend/features/auth/presentation/bloc/reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(const ResetPasswordState());

  void setEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void markEmailAsSent() {
    emit(state.copyWith(isEmailSent: true));
  }

  void clear() {
    emit(const ResetPasswordState());
  }
}
