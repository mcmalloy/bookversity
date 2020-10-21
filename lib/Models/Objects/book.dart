import 'dart:io';

class Book{

  String bookTitle;
  String isbnCode;
  String price;
  String userID;
  File bookImage;
  String imageURL;

  Book(this.bookTitle, this.isbnCode, this.price, this.userID, this.bookImage,this.imageURL){
    this.bookTitle = bookTitle;
    this.isbnCode = isbnCode;
    this.price = price;
    this.userID = userID;
    this.bookImage = bookImage;
    this.imageURL = imageURL;
  }

  Book.fromJson(Map<String, dynamic> json)
  : bookTitle = json['bookTitle'],
  isbnCode = json['isbnCode'],
  price = json['price'],
  userID = json['userID'],
  imageURL = json['imageURL'];



}