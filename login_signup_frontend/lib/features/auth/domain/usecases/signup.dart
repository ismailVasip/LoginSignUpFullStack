import 'package:dartz/dartz.dart';
import 'package:login_signup_frontend/core/usecase/usecase.dart';
import 'package:login_signup_frontend/features/auth/data/models/signup_request_params.dart';
import 'package:login_signup_frontend/features/auth/domain/repositories/auth.dart';
import 'package:login_signup_frontend/service_locator.dart';

class SignUpUseCase implements Usecase<Either<String, dynamic>,SignUpRequestParams>{
  @override
  Future<Either<String, dynamic>> call({SignUpRequestParams? param}) async{
    return serviceLocator<AuthRepository>().signUp(param!);
  }
}