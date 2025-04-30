import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_signup_frontend/core/usecase/usecase.dart';

part 'button_state.dart';

class ButtonCubit extends Cubit<ButtonState> {
  ButtonCubit() : super(ButtonInitialState());

  void execute({dynamic params, required Usecase usecase}) async {

    emit(ButtonLoadingState());
    await Future.delayed(const Duration(seconds: 3));
    try {
      Either result = await usecase.call(param: params);

      result.fold(
        (error) {
          emit(ButtonFailureState(errorMessage: error.toString()));
        },
        (data) {
          emit(ButtonSuccessState());
        },
      );
    } catch (e) {
      emit(ButtonFailureState(errorMessage: e.toString()));
    }
  }
}
