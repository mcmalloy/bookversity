
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

class Book{

  String booktitle;
  String isbnCode;
  String price;
  User user;
  File bookImage;

  Book(this.booktitle, this.isbnCode, this.price, this.user, this.bookImage){
    this.booktitle = booktitle;
    this.isbnCode = isbnCode;
    this.price = price;
    this.user = user;
    this.bookImage = bookImage;
  }


}