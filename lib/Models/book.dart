
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

class Book{

  String booktitle;
  String isbnCode;
  String price;
  String userID;
  File bookImage;

  Book(this.booktitle, this.isbnCode, this.price, this.userID, this.bookImage){
    this.booktitle = booktitle;
    this.isbnCode = isbnCode;
    this.price = price;
    this.userID = userID;
    this.bookImage = bookImage;
  }

  Book.fromJson(Map<String, dynamic> json)
  : booktitle = json['bookTitle'],
  isbnCode = json['isbnCode'],
  price = json['price'],
  userID = json['userID'];



}