
import 'dart:io';

import 'package:bookversity/Models/Objects/book.dart';
import 'package:bookversity/Services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
class FireStoreService {
  AuthService _authService = AuthService();
  static List<Book> booksForSale = new List();
  
  

  Future<bool> uploadBook(Book book) async {
    User user = _authService.getCurrentUser();
    print("uid: " + user.uid);
    if (await setBookForSale(book, user.uid)) {
      print("Total upload succeess");
      return true;
    }
    return false;
  }

  Future<bool> setBookForSale(Book book, String id) async {
    CollectionReference books = FirebaseFirestore.instance.collection(
        "booksForSale");
    String imageURL = await uploadBookToStorage(book, id);
    books.add({
      'bookOwnerUID': id,
      'bookTitle': book.bookTitle,
      'isbnCode': book.isbnCode,
      'price': book.price,
      'imageURL' : imageURL
    }).then((value) {
      print("Book added");
      return true;
    }).catchError((onError) {
      print(onError);
      return false;
    });
    return true;
  }

  Future<String> uploadBookToStorage(Book book, String id) async {
    try {
      StorageReference reference = FirebaseStorage.instance.ref().child(id).child(book.bookTitle);
      StorageUploadTask uploadTask = reference.putFile(book.bookImage);
      await uploadTask.onComplete;
      print("The image reference is stored at: ${reference.path}");
      print("Book has been uploaded to storage successfully");
      getBooksFromUser();
      return reference.path;
    } catch (e) {
      print(e);
      return "false";
    }
  }

  Future<List<String>> getMyBooksImages(List<Book> myBooksForSale) async{
    String id = myBooksForSale[0].userID;
    StorageReference imageLocation;
    List<String> urls = new List();
    for(int i = 0; i<myBooksForSale.length; i++){
      imageLocation = FirebaseStorage.instance.ref().child(id).child(myBooksForSale[i].bookTitle);
      urls.add(await imageLocation.getDownloadURL());
    }
    return urls;
  }

  Future<List<String>> getBooksFromStorage(List<Book> bookList) async {
    StorageReference imageLocation;
    List<String> urls = new List();
    for(int i = 0; i<bookList.length; i++){
      imageLocation = FirebaseStorage.instance.ref().child(bookList[i].userID).child(bookList[i].bookTitle);
      print("book: ${bookList[i].bookTitle}");
      urls.add(await imageLocation.getDownloadURL());
    }
    return urls;
  }


  Future<bool> hasBooksForSale() async {
    User user = _authService.getCurrentUser();
    String uid = user.uid;

    return true;
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
        print("Found matching book for user");
        myBooks.add(allBooks[i]);
      }
    }
    return myBooks;
  }
  Future<List<Book>> getAllBooks() async {
    String uid = _authService.getCurrentUser().uid;
    List<Book> bookList = new List();
    FirebaseFirestore rootRef = FirebaseFirestore.instance;
    CollectionReference booksReference = rootRef.collection("booksForSale");

    final QuerySnapshot result = await booksReference.get();
    final List<DocumentSnapshot> documents = result.docs;
    for(int i = 0; i<documents.length; i++){
        bookList.add(new Book(
            documents[i].get("bookTitle"),
            documents[i].get("isbnCode"),
            documents[i].get("price"),
            documents[i].get("bookOwnerUID"),
            null, // Get the picture of the book from storage
            documents[i].get("imageURL")
        ));
    }
    booksForSale = bookList;
    return bookList;
  }

  Future<List<Book>> getBooksSortedByPrice(bool cheapToExpensive) async {
    String uid = _authService.getCurrentUser().uid;
    List<Book> bookList = new List();
    FirebaseFirestore rootRef = FirebaseFirestore.instance;
    CollectionReference booksReference = rootRef.collection("booksForSale");
    final QuerySnapshot result = await booksReference.orderBy("price",descending: cheapToExpensive ? false : true).get();
    final List<DocumentSnapshot> documents = result.docs;
    for(int i = 0; i<documents.length; i++){
      bookList.add(new Book(
          documents[i].get("bookTitle"),
          documents[i].get("isbnCode"),
          documents[i].get("price"),
          documents[i].get("bookOwnerUID"),
          null, // Get the picture of the book from storage
          documents[i].get("imageURL")
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
    for(int i = 0; i<documents.length; i++){
      if(documents[i].get("bookTitle") == bookTitle && documents[i].get("bookOwnerUID") == uid){
        String deletePath = result.docs[i].reference.toString();
        print("Found $bookTitle ... deleting...");
        print(deletePath);
        await deleteChatIfExists(documents[i].get("bookTitle"));
        await result.docs[i].reference.delete(); // Delete documents
        await FirebaseStorage.instance.ref().child(uid).child(bookTitle).delete();
        return true;
      }
    }
    return false;
  }
  Future<void> deleteBookFromStorage(String bookTitle, String id) async {
    StorageReference imageLocation;
    imageLocation = FirebaseStorage.instance.ref().child(id).child(bookTitle);
    imageLocation.delete();
  }
  Future<void> deleteChatIfExists(String bookTitle) async {
    String uid = _authService.getCurrentUser().uid;
    FirebaseFirestore rootRef = FirebaseFirestore.instance;
    CollectionReference booksReference = rootRef.collection("chats");
    final QuerySnapshot result = await booksReference.get();
    final List<DocumentSnapshot> documents = result.docs;
    for(int i = 0; i<documents.length; i++){
      if(documents[i].get("chatID") == "${uid}-${documents[i].get("buyerID")}-$bookTitle"){
        String deletePath = result.docs[i].reference.toString();
        print("delete path for chat: "+deletePath);
        await result.docs[i].reference.delete(); // Delete documents
        break;
      }
    }
  }

}



























