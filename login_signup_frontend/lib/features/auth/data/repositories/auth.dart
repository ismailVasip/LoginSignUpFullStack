import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_signup_frontend/features/auth/data/datasources/auth_api_service.dart';
import 'package:login_signup_frontend/features/auth/data/datasources/auth_local_service.dart';
import 'package:login_signup_frontend/features/auth/data/models/signin_request_params.dart';
import 'package:login_signup_frontend/features/auth/data/models/signup_request_params.dart';
import 'package:login_signup_frontend/features/auth/domain/repositories/auth.dart';
import 'package:login_signup_frontend/service_locator.dart';

class AuthRepositoryImp extends AuthRepository {
  @override
  Future<Either> signUp(SignUpRequestParams signUpReq) async {
    Either result = await serviceLocator<AuthApiService>().signUp(signUpReq);

    return result.fold(
      (error) {
        return Left(error);
      },
      (data) async {
        Response response = data;
        final storage = const FlutterSecureStorage();
        final token = response.data['user']['tokens']['accessToken'] as String?;
        //final refreshToken = response.data['user']['tokens']['refreshToken'] as String?;

        await storage.write(key: 'access_token', value: token);

        //await storage.write(key: 'refresh_token', value: refreshToken);

        return Right(response);
      },
    );
  }

  @override
  Future<bool> isLoggedIn() async {
    return await serviceLocator<AuthLocalService>().isLoggedIn();
  }

  @override
  Future<Either> signIn(SignInRequestParams signInReq) async {
    Either result = await serviceLocator<AuthApiService>().signIn(signInReq);

    return result.fold(
      (error) {
        return Left(error);
      },
      (data) async {
        Response response = data;
        final storage = const FlutterSecureStorage();
        final token = response.data['accessToken'] as String?;

        await storage.write(key: 'access_token', value: token);

        return Right(response);
      },
    );
  }
}
