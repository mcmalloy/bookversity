
import 'dart:io';

import 'package:bookversity/Services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FireStoreService{
  AuthService _authService = AuthService();


  Future<void> uploadBook(String bookTitle, String isbnCode, String price, File image) async {
    User user = _authService.user;
    print("Attempting to upload picture from user ${user.toString()}");
    StorageReference reference = FirebaseStorage.instance.ref().child("books/");
    
    StorageUploadTask uploadTask = reference.putFile(image);
    await uploadTask.onComplete;
    print("Book has been uploaded");

  }

  bool hasBooksForSale(){
    return false;
  }


}