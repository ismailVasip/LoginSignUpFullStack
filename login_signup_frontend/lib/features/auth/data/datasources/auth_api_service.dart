import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:login_signup_frontend/core/constants/api_urls.dart';
import 'package:login_signup_frontend/core/network/dio_client.dart';
import 'package:login_signup_frontend/features/auth/data/models/signup_request_params.dart';
import 'package:login_signup_frontend/service_locator.dart';

abstract class AuthApiService {
  Future<Either> signUp(SignUpRequestParams signUpReq);
}

class AuthApiServiceImpl implements AuthApiService {
  @override
  Future<Either> signUp(SignUpRequestParams signUpReq) async{
    try{
      var response = serviceLocator<DioClient>().post(
        ApiUrls.register,
        data: signUpReq.toMap()
      );

      return Right(response);

    } on DioException catch(e){
        return Left(e.response!.data['message']);
    }
  }

}