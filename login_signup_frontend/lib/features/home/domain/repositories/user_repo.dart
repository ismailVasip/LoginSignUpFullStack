import 'package:dartz/dartz.dart';

abstract class UserRepo {
    Future<Either> getUsers();
    Future<Either> logout();
}
