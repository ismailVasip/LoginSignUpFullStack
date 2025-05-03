import 'package:dartz/dartz.dart';
import 'package:login_signup_frontend/core/usecase/usecase.dart';
import 'package:login_signup_frontend/features/auth/data/models/signin_request_params.dart';
import 'package:login_signup_frontend/features/auth/domain/repositories/auth.dart';
import 'package:login_signup_frontend/service_locator.dart';

class SignInUseCase implements Usecase<Either,SignInRequestParams>{
  @override
  Future<Either> call({SignInRequestParams? param}) async{
    return serviceLocator<AuthRepository>().signIn(param!);
  }
}