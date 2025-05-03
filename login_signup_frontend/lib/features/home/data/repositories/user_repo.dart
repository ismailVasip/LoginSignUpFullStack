import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:login_signup_frontend/features/home/data/datasources/user_api_service.dart';
import 'package:login_signup_frontend/features/home/data/models/user.dart';
import 'package:login_signup_frontend/features/home/domain/repositories/user_repo.dart';
import 'package:login_signup_frontend/service_locator.dart';

class UserRepoImp implements UserRepo {
  @override
  Future<Either> getUsers() async{
    Either result = await serviceLocator<UserApiService>().getUsers();

    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        final Response response = data;

        final List<UserModel> modelList = (response.data as List).map((item) => UserModel.fromMap(item as Map<String,dynamic>)).toList();

        final entityList = modelList.map((item) => item.toEntity()).toList();
    
        return Right(entityList);
      }
    );
  }
  
  @override
  Future<Either> logout() async{
    return await serviceLocator<UserApiService>().logout();
  }
}