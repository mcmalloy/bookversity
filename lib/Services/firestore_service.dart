
import 'package:bookversity/Services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreService{
  AuthService _authService = AuthService();


  Future<void> uploadBook() async {
    User user = _authService.user;
    print("Attempting to upload picture from user ${user.toString()}");

  }

  bool hasBooksForSale(){
    return false;
  }


}