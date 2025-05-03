import 'package:login_signup_frontend/features/home/domain/entities/user.dart';

sealed class UsersDisplayState {}

final class UsersLoadingState extends UsersDisplayState {}

final class UsersLoadedState extends UsersDisplayState {
  final List<UserEntity> listUsers;

  UsersLoadedState({required this.listUsers});
}
final class LoadUsersFailureState extends UsersDisplayState {
  final String errorMessage;

  LoadUsersFailureState({required this.errorMessage});
}