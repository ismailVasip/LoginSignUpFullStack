import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:login_signup_frontend/core/constants/api_urls.dart';
import 'package:login_signup_frontend/core/network/dio_client.dart';
import 'package:login_signup_frontend/service_locator.dart';

abstract class UserApiService {
  Future<Either> getUsers();
  Future<Either> logout();
}

class UserApiDatasourceImpl implements UserApiService {
  @override
  Future<Either> getUsers() async {
    try {
      final storage = const FlutterSecureStorage();

      var accessToken = await storage.read(key: 'access_token');

      if (accessToken == null || JwtDecoder.isExpired(accessToken)) {
        return Left('Something wrong.\nPlease login again.');
      }

      final response = await serviceLocator<DioClient>().get(
        ApiUrls.getUsers,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return Right(response);
    } on DioException catch (e) {
      return Left(
        e.response?.data is Map
            ? e.response?.data['message']
            : e.message ?? 'Unexpected error',
      );
    }
  }
  
  @override
  Future<Either> logout() async{
    final storage = const FlutterSecureStorage();
    storage.delete(key: 'access_token');
    return const Right(true);
  }
}
