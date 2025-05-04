import 'package:dartz/dartz.dart';
import 'package:login_signup_frontend/core/usecase/usecase.dart';
import 'package:login_signup_frontend/features/auth/data/models/reset_password_params.dart';
import 'package:login_signup_frontend/features/auth/domain/repositories/auth.dart';
import 'package:login_signup_frontend/service_locator.dart';

class ResetPasswordUseCase implements Usecase<Either,ResetPasswordParams>{
  @override
  Future<Either> call({ResetPasswordParams? param}) async{
    return await serviceLocator<AuthRepository>().resetPassword(param!);
  }
}