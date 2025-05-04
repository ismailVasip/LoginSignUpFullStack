part of 'button_cubit.dart';


sealed class ButtonState {}

final class ButtonInitialState extends ButtonState {}

final class ButtonLoadingState extends ButtonState {}

final class ButtonSuccessState extends ButtonState {
  final String? email;

  ButtonSuccessState({this.email});
}

final class ButtonFailureState extends ButtonState {
  final String errorMessage;

  ButtonFailureState({required this.errorMessage });
}
