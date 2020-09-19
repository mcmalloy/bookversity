
import 'dart:io';

import 'package:bookversity/Models/book.dart';
import 'package:bookversity/Services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class FireStoreService{
  AuthService _authService = AuthService();


  Future<bool> uploadBook(Book book) async {
    User user = _authService.getCurrentUser();
    print("uid: "+user.uid);
    if(await upload(book,user.uid) && await uploadBookToStorage(book,user.uid)){
      print("Total upload succeess");
      return true;
    }
    return false;
  }

  Future<bool> uploadBookToCollection(Book book,String id) async{
    final dbRef = FirebaseDatabase.instance.reference().child("booksForSale");

    dbRef.push().set({
      "bookTitle": book.booktitle,
      "isbnCode": book.isbnCode == null ? "" : book.isbnCode,
      "price": book.price,
      "bookOwnerUID": id
    }).catchError((onError) {
      print(onError);
      return false;
    });
    print("upload to collection success");
    return true;
  }

  Future<bool> upload(Book book,String id) async {
    CollectionReference books = FirebaseFirestore.instance.collection("booksForSale");
    books.add({
      'bookOwnerUID': id,
      'bookTitle': book.booktitle,
      'isbnCode': book.isbnCode,
      'price': book.price
    }).then((value){
      print("Book added");
      return true;
    }).catchError((onError) {
      print(onError);
      return false;
    });
    return true;
  }

  Future<bool> uploadBookToStorage(Book book, String id) async {
    try{
      StorageReference reference = FirebaseStorage.instance.ref().child(book.booktitle+"_"+id);
      StorageUploadTask uploadTask = reference.putFile(book.bookImage);
      await uploadTask.onComplete;
      print("The image reference is stored at: ${reference.path}");
      print("Book has been uploaded to storage successfully");
      getBooksFromUser();
      return true;
    } catch (e){
      print(e);
      return false;
    }
  }

  bool hasBooksForSale(){
    User user = _authService.getCurrentUser();

    return false;
  }

  Future<void> getBooksFromUser() async {
    User user = _authService.getCurrentUser();

    FirebaseFirestore dbRef = FirebaseFirestore.instance;
    dbRef.collectionGroup("booksForSale");
    print("printing reference: ${dbRef.toString()}");
  }
}