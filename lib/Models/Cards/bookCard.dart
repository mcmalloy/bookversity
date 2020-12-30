import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Constants/custom_textstyle.dart';
import 'package:bookversity/Constants/enums.dart';
import 'package:bookversity/Models/Objects/book.dart';
import 'package:bookversity/Pages/Books/book_details_page.dart';
import 'package:bookversity/Services/firestore_service.dart';
import 'package:flutter/material.dart';

class BookCard extends StatefulWidget {
  RoundedRectangleBorder shape;
  String symmetry;
  Book book;
  String url;
  bool myListings;

  BookCard(this.book, this.shape, this.symmetry,this.url,this.myListings);

  @override
  _BookCardState createState() => _BookCardState(book, shape, symmetry,url,myListings);
}

class _BookCardState extends State<BookCard> {
  RoundedRectangleBorder shape;
  String symmetry;
  Book book;
  String url;
  bool myListings;

  _BookCardState(
    this.book,
    this.shape,
    this.symmetry,
      this.url,
      this.myListings
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //TODO: GO TO BOOK DETAILS PAGE
        if(!myListings){
          print("Going to details!");
          Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetailsPage(book,url)));
        }
      },
      child: Container(
          height: 120,
          child: Card(
              margin: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
              color: Colors.white,
              child: symmetry == "right" ? rightRow(book) : leftRow(book))),
    );
  }

  Widget rightRow(Book book) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 3,
          child: bookInfoText(book),
        ),
        Container(
          child: Expanded(
            flex: 1,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.black,
              child: Image.network(url)
            ),
          ),
        )
      ],
    );
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
          flex: 3,
          child: bookInfoText(book),
        )
      ],
    );
  }

  Widget bookInfoText(Book book) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15),
          child:CustomTextStyle(book.bookTitle, 18, CustomColors.materialDarkGreen),
        ),
        SizedBox(height: 20,),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15),
          child:  CustomTextStyle("Pris: ${book.price}kr", 16, CustomColors.materialDarkGreen),
        )
      ],
    );
  }

  static void deleteDialog(Book book,BuildContext context){
    showDialog(context: context,
    builder: (context) {
      return AlertDialog(
        title: CustomTextStyle("Fjern opslag",22,CustomColors.materialDarkGreen),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        content: CustomTextStyle("Er du sikker på at du vil fjerne ${book.bookTitle}",18,CustomColors.materialDarkGreen)
      );
    }
    );
  }
}
