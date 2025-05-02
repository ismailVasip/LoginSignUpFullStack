
part of 'auth_cubit.dart';

sealed class AuthState {}

final class AppInitialState extends AuthState{}

final class Authenticated extends AuthState{}

final class Unauthenticated extends AuthState{}