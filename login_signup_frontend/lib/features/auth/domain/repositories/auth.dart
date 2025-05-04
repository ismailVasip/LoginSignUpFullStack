import 'package:dartz/dartz.dart';
import 'package:login_signup_frontend/features/auth/data/models/forgot_password_params.dart';
import 'package:login_signup_frontend/features/auth/data/models/reset_password_params.dart';
import 'package:login_signup_frontend/features/auth/data/models/signin_request_params.dart';
import 'package:login_signup_frontend/features/auth/data/models/signup_request_params.dart';
import 'package:login_signup_frontend/features/auth/data/models/verify_code_params.dart';

abstract class AuthRepository{

  Future<Either> signUp(SignUpRequestParams signUpReq);

  Future<bool> isLoggedIn();

  Future<Either> signIn(SignInRequestParams signInReq);
  
  Future<Either> forgotPassword(ForgotPasswordParams forgotPasswordReq);

  Future<Either> verifyCode(VerifyCodeParams verifyCodeReq);

  Future<Either> resetPassword(ResetPasswordParams resetPasswordReq);
}