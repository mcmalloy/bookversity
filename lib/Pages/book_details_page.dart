import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Constants/custom_textstyle.dart';
import 'package:bookversity/Models/book.dart';
import 'package:bookversity/Services/auth.dart';
import 'package:bookversity/Services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookDetailsPage extends StatefulWidget {
  Book book;
  String imageURL;
  BookDetailsPage(this.book,this.imageURL);

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState(book,imageURL);
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  Book book;
  String imageURL;
  _BookDetailsPageState(this.book,this.imageURL);
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.materialLightGreen,
      body: Container(
        child: Column(
          children: [
            customSpace(),
            topBar(),
            bookBody(),
            contactSellerButton()
          ],
        ),
      ),
    );
  }

  Widget customSpace(){
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Container(color: Colors.white),
    );
  }
  Widget topBar() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: CustomColors.materialDarkGreen, offset: Offset(2.0, 2.0))
      ]),
      width: double.infinity,
      padding: EdgeInsets.only(left: 16, bottom: 5, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
                  CustomTextStyle(
                  "Kontakt Sælger", 36, CustomColors.materialDarkGreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget bookBody(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 300,
          padding: EdgeInsets.only(left: 25),
          child: Image.network(imageURL),
        ),
        Column(
          children: [
            Container(
              child: CustomTextStyle("Bogtitel: ${book.bookTitle}",16,CustomColors.materialYellow),
            ),
            Container(
              child: CustomTextStyle("Pris: ${book.price}",16,CustomColors.materialYellow),
            ),
            Container(
              child: CustomTextStyle("ISBN Kode: ${book.isbnCode}",16,CustomColors.materialYellow),
            ),
          ],
        )
      ],
    );
  }

  Widget contactSellerButton(){
    return RaisedButton(
      color: CustomColors.materialYellow,
      onPressed: (){
      //TODO: Open chat message screen
        String uid = _authService.getCurrentUser().uid;

        print("Open initiate chat between user: $uid and ${book.userID}");
      },
      child: Container(
        child: CustomTextStyle("Skriv til sælger",20,CustomColors.materialDarkGreen),
      ),
    );
  }

}
