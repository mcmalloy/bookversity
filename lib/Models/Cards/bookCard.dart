import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Constants/custom_textstyle.dart';
import 'package:bookversity/Constants/enums.dart';
import 'package:bookversity/Models/book.dart';
import 'package:flutter/material.dart';

class BookCard extends StatefulWidget {
  RoundedRectangleBorder shape;
  String symmetry;
  Book book;

  BookCard(this.book, this.shape, this.symmetry);

  @override
  _BookCardState createState() => _BookCardState(book, shape, symmetry);
}

class _BookCardState extends State<BookCard> {
  RoundedRectangleBorder shape;
  String symmetry;
  Book book;

  _BookCardState(
    this.book,
    this.shape,
    this.symmetry,
  );
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //TODO: GO TO BOOK DETAILS PAGE

      },
      child: Container(
          height: 120,
          child: Card(
              margin: EdgeInsets.all(15),
              shape: shape,
              color: Colors.purple,
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
              child: Image.network('https://imgcdn.saxo.com/_9780307278821'),
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
              child: Image.network('https://imgcdn.saxo.com/_9780307278821'),
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTextStyle(book.booktitle, 18, CustomColors.materialYellow),
        CustomTextStyle(
            "Pris: ${book.price}kr", 16, CustomColors.materialYellow),
      ],
    );
  }

  static void deleteDialog(Book book,BuildContext context){
    showDialog(context: context,
    builder: (context) {
      return AlertDialog(
        title: CustomTextStyle("Fjern opslag",22,CustomColors.materialDarkGreen),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        content: CustomTextStyle("Er du sikker på at du vil fjerne ${book.booktitle}",18,CustomColors.materialDarkGreen)
      );
    }
    );
  }
}