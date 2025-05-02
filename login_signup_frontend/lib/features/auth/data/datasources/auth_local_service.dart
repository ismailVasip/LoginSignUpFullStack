
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLocalService {
  Future<bool> isLoggedIn();
}

class AuthLocalServiceImpl extends AuthLocalService {
  @override
  Future<bool> isLoggedIn() async{
    final storage = const FlutterSecureStorage();

    var accessToken = await storage.read(key:'access_token');

    if(accessToken == null) {
      return false;
    } else{
      return true;
    }
  }

}