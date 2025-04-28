import 'package:get_it/get_it.dart';
import 'package:login_signup_frontend/core/network/dio_client.dart';
import 'package:login_signup_frontend/features/auth/data/datasources/auth_api_service.dart';
import 'package:login_signup_frontend/features/auth/data/repositories/auth.dart';
import 'package:login_signup_frontend/features/auth/domain/repositories/auth.dart';
import 'package:login_signup_frontend/features/auth/domain/usecases/signup.dart';

final serviceLocator = GetIt.instance;

void setUpServiceLocator() {
  serviceLocator.registerSingleton<DioClient>(DioClient());

  //Service
  serviceLocator.registerSingleton<AuthApiService>(
    AuthApiServiceImpl()
  );

  //Repositories
  serviceLocator.registerSingleton<AuthRepository>(
    AuthRepositoryImp()
  );

  //Usecases
  serviceLocator.registerSingleton<SignUpUseCase>(
    SignUpUseCase()
  );
}