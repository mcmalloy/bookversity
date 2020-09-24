import 'file:///C:/Users/Mark/StudioProjects/bookversity/lib/Models/Cards/bookCard.dart';
import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Constants/custom_textstyle.dart';
import 'package:bookversity/Constants/enums.dart';
import 'package:bookversity/Models/book.dart';
import 'package:bookversity/Services/firestore_service.dart';
import 'package:bookversity/Widgets/shapes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ItemList extends StatefulWidget {
  ListingType _listPageType;
  ItemList(this._listPageType);
  @override
  _ItemListState createState() => _ItemListState(_listPageType);
}

class _ItemListState extends State<ItemList> {
  ListingType _listPageType;
  _ItemListState(this._listPageType);
  FireStoreService _fireStoreService = FireStoreService();
  CustomShapes _shapes = CustomShapes();
  List<Book> booksForSale = new List();
  String _pageTitle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBooks();
  }

  Future<void> getBooks() async {
    if (_listPageType == ListingType.myBooksForSale) {
      _pageTitle = "Mine annoncer";
      List<Book> books = await _fireStoreService.getMyBooks();
      setState(() {
        booksForSale = books;
      });
    } else if (_listPageType == ListingType.allBooksForSale) {
      _pageTitle = "Alle annoncer";
      List<Book> books = await _fireStoreService.getAllBooks();
      setState(() {
        booksForSale = books;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //getBooks();
    return Scaffold(
      backgroundColor: CustomColors.materialLightGreen,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
                child: Row(
                  children: [
                    _listPageType == ListingType.allBooksForSale ? Container(height: 0,width: 0,) :
                    IconButton(icon: Icon(FontAwesomeIcons.arrowLeft), onPressed: () { Navigator.pop(context); },),
                    Container(
                        padding: EdgeInsets.only(top: 15,left: 25),
                        alignment: Alignment.center,
                        child: CustomTextStyle(
                            _pageTitle, 26, CustomColors.materialYellow))
                  ],
                )),
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
      flex: 10,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: booksForSale.length,
          padding: const EdgeInsets.all(0),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (index % 2 == 0) {
              return BookCard(
                  booksForSale[index], _shapes.customListShapeRight(), "right");
            } else {
              // Switch to left or create symmetry later on
              return BookCard(
                  booksForSale[index], _shapes.customListShapeLeft(), "right");
            }
          }),
    );
  }
}
