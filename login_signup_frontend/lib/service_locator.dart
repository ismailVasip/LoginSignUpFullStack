import 'package:get_it/get_it.dart';
import 'package:login_signup_frontend/core/network/dio_client.dart';
import 'package:login_signup_frontend/features/auth/data/datasources/auth_api_service.dart';
import 'package:login_signup_frontend/features/auth/data/datasources/auth_local_service.dart';
import 'package:login_signup_frontend/features/auth/data/repositories/auth.dart';
import 'package:login_signup_frontend/features/auth/domain/repositories/auth.dart';
import 'package:login_signup_frontend/features/auth/domain/usecases/forgot_password.dart';
import 'package:login_signup_frontend/features/auth/domain/usecases/reset_password.dart';
import 'package:login_signup_frontend/features/auth/domain/usecases/signin.dart';
import 'package:login_signup_frontend/features/auth/domain/usecases/verify_code.dart';
import 'package:login_signup_frontend/features/home/data/datasources/user_api_service.dart';
import 'package:login_signup_frontend/features/home/data/repositories/user_repo.dart';
import 'package:login_signup_frontend/features/home/domain/repositories/user_repo.dart';
import 'package:login_signup_frontend/features/home/domain/usecases/get_users.dart';
import 'package:login_signup_frontend/features/auth/domain/usecases/is_logged_in.dart';
import 'package:login_signup_frontend/features/auth/domain/usecases/signup.dart';
import 'package:login_signup_frontend/features/home/domain/usecases/logout.dart';

final serviceLocator = GetIt.instance;

void setUpServiceLocator() {
  serviceLocator.registerSingleton<DioClient>(DioClient());

  //Service
  serviceLocator.registerSingleton<AuthApiService>(
    AuthApiServiceImpl()
  );

  serviceLocator.registerSingleton<AuthLocalService>(
    AuthLocalServiceImpl()
  );

  serviceLocator.registerSingleton<UserApiService>(
    UserApiDatasourceImpl()
  );


  //Repositories
  serviceLocator.registerSingleton<AuthRepository>(
    AuthRepositoryImp()
  );

  serviceLocator.registerSingleton<UserRepo>(
    UserRepoImp()
  );

  //Usecases
  serviceLocator.registerSingleton<SignUpUseCase>(
    SignUpUseCase()
  );

  serviceLocator.registerSingleton<IsLoggedInUseCase>(
    IsLoggedInUseCase()
  );

  serviceLocator.registerSingleton<GetUsersUseCase>(
    GetUsersUseCase()
  );
  serviceLocator.registerSingleton<LogoutUseCase>(
    LogoutUseCase()
  );
  serviceLocator.registerSingleton<SignInUseCase>(
    SignInUseCase()
  );
  serviceLocator.registerSingleton<ForgotPasswordUseCase>(
    ForgotPasswordUseCase()
  );
  serviceLocator.registerSingleton<VerifyCodeUseCase>(
    VerifyCodeUseCase()
  );
  serviceLocator.registerSingleton<ResetPasswordUseCase>(
    ResetPasswordUseCase()
  );
}