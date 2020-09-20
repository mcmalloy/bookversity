import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Constants/custom_textstyle.dart';
import 'package:bookversity/Models/book.dart';
import 'package:bookversity/Services/firestore_service.dart';
import 'package:bookversity/Widgets/shapes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  FireStoreService _fireStoreService = FireStoreService();
  CustomShapes _shapes = CustomShapes();
  List<Book> booksForSale = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBooks();
  }

  Future<void> getBooks() async {
    List<Book> books = await _fireStoreService.getAllBooks();
    setState(() {
      booksForSale = books;
    });
  }

  @override
  Widget build(BuildContext context) {
    //getBooks();
    return Scaffold(
      backgroundColor: CustomColors.materialLightGreen,
      body: SafeArea(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(top: 15),
                alignment: Alignment.center,
                child: CustomTextStyle(
                    "Alle Annoncer", 26, CustomColors.materialYellow)),
            booksForSale.isEmpty
                ? Container(
                    // Show a logo saying it couldn't find books'
                    height: 0,
                  )
                : booksListView()
          ],
        ),
      ),
    );
  }

  Widget booksListView() {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: booksForSale.length,
          padding: const EdgeInsets.all(0),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (index % 2 == 0) {
              return bookAdCard(
                  booksForSale[index], _shapes.customListShapeRight(), "right");
            } else {
              return bookAdCard(
                  booksForSale[index], _shapes.customListShapeLeft(), "left");
            }
          }),
    );
  }

  Widget bookAdCard(Book book, RoundedRectangleBorder shape, String symmetry) {
    return InkWell(
      onTap: (){
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
        bookInfoText(book),
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.black,
          child: Image.network('https://imgcdn.saxo.com/_9780307278821'),
        )
      ],
    );
  }

  Widget leftRow(Book book) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.black,
          child: Image.network('https://imgcdn.saxo.com/_9780307278821'),
        ),
       bookInfoText(book)
      ],
    );
  }

  Widget bookInfoText(Book book){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTextStyle(book.booktitle, 18, CustomColors.materialYellow),
        CustomTextStyle("Pris: ${book.price}kr", 16, CustomColors.materialYellow),
      ],
    );
  }
}
