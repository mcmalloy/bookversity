import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin facebookSignIn = FacebookLogin();

  // Sign in anonymously
  Future<FirebaseUser> anonSignIn() async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      print("Firebase response: $result");
      print("Firebase user: $user");
      return user;
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future<FirebaseUser> emailSignIn(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    print("Additional user info: "+ result.additionalUserInfo.username);
    return user;
  }

  Future createEmailUser(String email,String password) async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    user.sendEmailVerification();
  }

  Future<FacebookLoginStatus> facebookLogin() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
      if(result.status == FacebookLoginStatus.loggedIn){
        final FacebookAccessToken accessToken = result.accessToken;
        print('''
         Logged in!
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        return result.status;
      }
      else if(result.status == FacebookLoginStatus.cancelledByUser){
        print('Login cancelled by the user.');
      }
      else{
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        return result.status;
      }
      return null;
  }

  Future<bool> facebookLogout() async {
    print(await facebookSignIn.isLoggedIn);
    await facebookSignIn.logOut();
    bool isLoggedIn = await facebookSignIn.isLoggedIn;
    print("Facebook isLoggedIn: $isLoggedIn");
    if(isLoggedIn){
      return true;
    }
    else{
      return false;
    }
  }



}