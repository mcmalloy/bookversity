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

  final StateStorageService _storageService = StateStorageService();
  static LoginType _loginType;
  static String facebookUID;
  // Credential variables
  User user;
  UserCredential userCredential;
  String accessToken;
  String idToken;

  // Social Media Sign in
  final FacebookLogin facebookSignIn = FacebookLogin();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in anonymously
  Future<User> anonSignIn() async {
    try{
      _auth.signInAnonymously();
      UserCredential userCredential = await _auth.signInAnonymously();
      user = userCredential.user;
      print("Firebase response: $userCredential");
      print("Firebase user: $user");
      return user;
    } catch(e){
      print(e.toString());
      return null;
    }
  }
  Future<int> createEmailUser(String email,String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    user = userCredential.user;
    user.sendEmailVerification();
  }
  // Sign in with email and password
  Future<User> emailSignIn(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    user = userCredential.user;
    if(user != null){
      _loginType = LoginType.emailSignIn;
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
  Future<User> googleLogin() async {

    final GoogleSignInAccount signInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication authentication = await signInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken);

    userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;

    /*
    AuthCredential credential;
    GoogleSignInAccount signInAccount = await _googleSignIn.signIn().then((result){
      result.authentication.then((googleKey){
         idToken = googleKey.idToken;
         accessToken = googleKey.accessToken;
        credential = GoogleAuthProvider.credential(idToken: idToken,accessToken: accessToken);
        print("google credential is: $credential");
      }).catchError((e){
        print(e);
      });
    }).catchError((err){
      print(e);
    });
    print("google credential is1: $credential");
    userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
     */
  }
  Future<User> facebookLogin() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
      if(result.status == FacebookLoginStatus.loggedIn){
        // Set the accessToken and use it for signing in with Firebase as a firebase user
        final FacebookAccessToken accessToken = result.accessToken;
        // Set the loginType to facebookSignIn, such that the profile page will load a profile image
        _loginType = LoginType.facebookSignIn;
        _storageService.saveFacebookUID(accessToken.userId);
        print("Retrieving authCredentials from accesToken: ${accessToken.token}");
        // Authenticate the facebook user with firebase and officially log in as a firebase User
        AuthCredential credential= FacebookAuthProvider.credential(accessToken.token);
        userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;
      }
      else if(result.status == FacebookLoginStatus.cancelledByUser){
        print('Login cancelled by the user.');
        return null;
      }
      else{
        print('Something went wrong with the login process.. ${result.errorMessage}');
        return null;
      }
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

  Future<bool> fireBaseLogOut() async {
    await _auth.signOut();
    User currentUser = _auth.currentUser;
    if(currentUser == null){
      print("Logged out succesfully");
      return true;
    }
    return false;
  }

  String getProfilePictureUri() {
    return "http://graph.facebook.com/$facebookUID/picture?type=square";
  }


  LoginType getSignInType(){
    return _loginType;
  }


}