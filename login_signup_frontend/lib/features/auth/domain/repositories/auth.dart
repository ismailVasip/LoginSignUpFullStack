import 'package:dartz/dartz.dart';
import 'package:login_signup_frontend/features/auth/data/models/signup_request_params.dart';

abstract class AuthRepository{

  Future<Either<String, dynamic>> signUp(SignUpRequestParams signUpReq);
}