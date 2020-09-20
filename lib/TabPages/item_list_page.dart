import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Constants/custom_textstyle.dart';
import 'package:bookversity/Models/book.dart';
import 'package:bookversity/Services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  FireStoreService _fireStoreService = FireStoreService();
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
          itemBuilder: (context,index){
            return bookAdCard(booksForSale[index]);
          }
      ),
    );
  }

  Widget bookAdCard(Book book){
    return CustomTextStyle(book.booktitle,29, CustomColors.materialYellow);
  }
}
