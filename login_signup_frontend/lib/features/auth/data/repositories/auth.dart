import 'package:dartz/dartz.dart';
import 'package:login_signup_frontend/features/auth/data/datasources/auth_api_service.dart';
import 'package:login_signup_frontend/features/auth/data/models/signup_request_params.dart';
import 'package:login_signup_frontend/features/auth/domain/repositories/auth.dart';
import 'package:login_signup_frontend/service_locator.dart';

class AuthRepositoryImp extends AuthRepository {
  @override
  Future<Either> signUp(SignUpRequestParams signUpReq) async {
    return serviceLocator<AuthApiService>().signUp(signUpReq);
  }
}
