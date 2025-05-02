import 'package:login_signup_frontend/core/usecase/usecase.dart';
import 'package:login_signup_frontend/features/auth/domain/repositories/auth.dart';
import 'package:login_signup_frontend/service_locator.dart';

class IsLoggedInUseCase implements Usecase<bool,dynamic>{
  @override
  Future<bool> call({dynamic param}) async{
    return serviceLocator<AuthRepository>().isLoggedIn();
  }
}