import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Constants/custom_textstyle.dart';
import 'package:bookversity/Constants/enums.dart';
import 'package:bookversity/Models/Objects/book.dart';
import 'package:bookversity/Services/firestore_service.dart';
import 'package:flutter/material.dart';

class DeleteBookCard extends StatefulWidget {
  RoundedRectangleBorder shape;
  Book book;
  String url;
  DeleteBookCard(this.book, this.shape,this.url);

  @override
  _DeleteBookCardState createState() => _DeleteBookCardState(book, shape, url);
}

class _DeleteBookCardState extends State<DeleteBookCard> {
  RoundedRectangleBorder shape;
  Book book;
  String url;
  FireStoreService fireStoreService = FireStoreService();
  _DeleteBookCardState(
    this.book,
    this.shape,
      this.url
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        child: Card(
            margin: EdgeInsets.all(15),
            shape: shape,
            color:Colors.red[700],
            child: leftRow(book)));
  }

  Widget leftRow(Book book) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          child: Expanded(
            flex: 1,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.black,
              child: Image.network(url),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.topCenter,
            child: bookInfoText(book),
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete_forever),
          iconSize: 36,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget bookInfoText(Book book) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTextStyle(book.bookTitle, 18, CustomColors.materialYellow),
      ],
    );
  }
   void deleteDialog(Book book, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: CustomTextStyle(
                  "Fjern opslag", 22, CustomColors.materialDarkGreen),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              content: CustomTextStyle(
                  "Er du sikker på at du vil fjerne ${book.bookTitle}",
                  18,
                  CustomColors.materialDarkGreen),
          elevation: 3,
            actions: [
              FlatButton(
                child: CustomTextStyle(
                  "Slet Annonce",
                  16,
                  Colors.red
                ),
                onPressed: () async {
                  print("Attempting to delete '${book.bookTitle}'");
                  fireStoreService.deleteBookListing(book.bookTitle);
                },
              ),
              FlatButton(
                child: CustomTextStyle(
                    "Behold Annonce",
                    16,
                    CustomColors.materialLightGreen
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
