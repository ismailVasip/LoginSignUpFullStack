import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_signup_frontend/features/home/domain/usecases/get_users.dart';
import 'package:login_signup_frontend/features/home/presentation/bloc/users_display_state.dart';
import 'package:login_signup_frontend/service_locator.dart';

class UsersDisplayCubit extends Cubit<UsersDisplayState>{
  UsersDisplayCubit() :super(UsersLoadingState());

  void fetchUsers() async{
    var users = await serviceLocator<GetUsersUseCase>().call();

    users.fold(
      (error){
        emit(LoadUsersFailureState(errorMessage: error));
      },
      (data){
        emit(UsersLoadedState(listUsers: data));
      }
    );
  }
}