import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_signup_frontend/features/auth/domain/usecases/is_logged_in.dart';
import 'package:login_signup_frontend/service_locator.dart';

part 'auth_state.dart';

class AuthStateCubit extends Cubit<AuthState>{
  AuthStateCubit() : super(AppInitialState());

  void appStarted()async{
    var isLoggedIn = await serviceLocator<IsLoggedInUseCase>().call();

    if(isLoggedIn){
      emit(Authenticated());
    }else{
      emit(Unauthenticated());
    }
  }
}