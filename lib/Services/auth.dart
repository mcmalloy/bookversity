import 'dart:math';

import 'package:bookversity/Constants/loginType.dart';
import 'package:bookversity/Services/state_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin facebookSignIn = FacebookLogin();
  final StateStorageService _storageService = StateStorageService();
  static LoginType _loginType;
  static String facebookUID;
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
  Future<int> createEmailUser(String email,String password) async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    user.sendEmailVerification();
  }
  // Sign in with email and password
  Future<FirebaseUser> emailSignIn(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    if(user != null){
      _loginType = LoginType.facebookSignIn;
      return user;
    }
    return null;
  }
  Future<int> forgotPassword(String email) async {
    try{
      await _auth.sendPasswordResetEmail(email: email);
      return 200;
    } catch(e){
      return 400;
    }

  }



  Future<FacebookLoginStatus> facebookLogin() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
      if(result.status == FacebookLoginStatus.loggedIn){
        _loginType = LoginType.facebookSignIn;
        final FacebookAccessToken accessToken = result.accessToken;
        _storageService.saveFacebookUID(accessToken.userId);
        facebookUID = accessToken.userId;
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

  String getProfilePictureUri() {
    return "http://graph.facebook.com/$facebookUID/picture?type=square";
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Firestore _db = Firestore.instance;
  Future<bool> googleLogin() async {
    print("Trying to log in");
    GoogleSignInAccount user = await _googleSignIn.signIn();
    if(user != null){
      _loginType = LoginType.googleSignIn;
      return true;
    }
    else{
      return false;
    }
  }

  LoginType getSignInType(){
    return _loginType;
  }


}