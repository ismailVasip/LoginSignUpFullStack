import 'package:dartz/dartz.dart';
import 'package:login_signup_frontend/core/usecase/usecase.dart';
import 'package:login_signup_frontend/features/auth/data/models/forgot_password_params.dart';
import 'package:login_signup_frontend/features/auth/domain/repositories/auth.dart';
import 'package:login_signup_frontend/service_locator.dart';

class ForgotPasswordUseCase implements Usecase<Either,ForgotPasswordParams> {
  @override
  Future<Either> call({ForgotPasswordParams? param}) async{
  return await serviceLocator<AuthRepository>().forgotPassword(param!);
      
  }
}