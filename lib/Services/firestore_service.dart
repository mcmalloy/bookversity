
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
import 'package:path/path.dart';
class FireStoreService {
  AuthService _authService = AuthService();
  static List<Book> booksForSale = new List();
  
  

  Future<bool> uploadBook(Book book) async {
    User user = _authService.getCurrentUser();
    print("uid: " + user.uid);
    if (await upload(book, user.uid) &&
        await uploadBookToStorage(book, user.uid)) {
      print("Total upload succeess");
      return true;
    }
    return false;
  }

  Future<bool> uploadBookToCollection(Book book, String id) async {
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

  Future<bool> upload(Book book, String id) async {
    CollectionReference books = FirebaseFirestore.instance.collection(
        "booksForSale");
    books.add({
      'bookOwnerUID': id,
      'bookTitle': book.booktitle,
      'isbnCode': book.isbnCode,
      'price': book.price
    }).then((value) {
      print("Book added");
      return true;
    }).catchError((onError) {
      print(onError);
      return false;
    });
    return true;
  }

  Future<bool> uploadBookToStorage(Book book, String id) async {
    try {
      StorageReference reference = FirebaseStorage.instance.ref().child(
          book.booktitle + "_" + id);
      StorageUploadTask uploadTask = reference.putFile(book.bookImage);
      await uploadTask.onComplete;
      print("The image reference is stored at: ${reference.path}");
      print("Book has been uploaded to storage successfully");
      getBooksFromUser();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  List<Book> hasBooksForSale() {
    User user = _authService.getCurrentUser();
    List<Book> postedBooks = new List();
    String uid = user.uid;
      for(int i = 0; i<booksForSale.length; i++){
        if(booksForSale[i].userID == uid){
          postedBooks.add(booksForSale[i]);
          print("Found a matching book: "+booksForSale[i].price);
        }
      }
    return postedBooks == null ? null : postedBooks;
  }

  Future<void> getBooksFromUser() async {
    User user = _authService.getCurrentUser();

    FirebaseFirestore dbRef = FirebaseFirestore.instance;
    dbRef.collectionGroup("booksForSale");
    print("printing reference: ${dbRef.toString()}");
  }

  Future<List<Book>> getMyBooks() async{
    List<Book> myBooks = new List();
    List<Book> allBooks = await getAllBooks();
    String uid = _authService.getCurrentUser().uid;
    for(int i = 0; i<allBooks.length; i++){
      if(uid ==  allBooks[i].userID){
        myBooks.add(allBooks[i]);
      }
    }
    return myBooks;
  }
  Future<List<Book>> getAllBooks() async {
    List<Book> bookList = new List();
    FirebaseFirestore rootRef = FirebaseFirestore.instance;
    CollectionReference booksReference = rootRef.collection("booksForSale");

    final QuerySnapshot result = await booksReference.get();
    final List<DocumentSnapshot> documents = result.docs;
    for(int i = 0; i<documents.length; i++){
      print("booksForSale name: ${documents[i].get("bookTitle")}");
      bookList.add(new Book(
          documents[i].get("bookTitle"),
          documents[i].get("isbnCode"),
          documents[i].get("price"),
          documents[i].get("bookOwnerUID"),
          null // Get the picture of the book from storage
      ));
    }
    booksForSale = bookList;
    return bookList;
  }

  Future<bool> deleteBookListing(String bookTitle) async {
    String uid = _authService.getCurrentUser().uid;
    FirebaseFirestore rootRef = FirebaseFirestore.instance;
    CollectionReference booksReference = rootRef.collection("booksForSale");
    final QuerySnapshot result = await booksReference.get();
    final List<DocumentSnapshot> documents = result.docs;
    print("current bookTitle to delete $bookTitle , and current UID: $uid");
    for(int i = 0; i<documents.length; i++){
      if(documents[i].get("bookTitle") == bookTitle && documents[i].get("bookOwnerUID") == uid){
        print("Removing book with title: "+result.docs[i].get("bookTitle"));
        print("Document reference: "+result.docs[i].reference.toString());
        await rootRef.doc(result.docs[i].reference.toString()).delete(); // DELETES BOOK
      }
    }
  }
}



























