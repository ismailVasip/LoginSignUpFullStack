import 'package:dartz/dartz.dart';
import 'package:login_signup_frontend/core/usecase/usecase.dart';
import 'package:login_signup_frontend/features/home/domain/repositories/user_repo.dart';
import 'package:login_signup_frontend/service_locator.dart';

class LogoutUseCase implements Usecase<Either,dynamic>{
  @override
  Future<Either> call({ param}) async{
    return await serviceLocator<UserRepo>().logout();
  }
  
}