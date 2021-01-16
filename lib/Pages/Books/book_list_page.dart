import 'dart:io';

import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Constants/custom_textstyle.dart';
import 'package:bookversity/Constants/enums.dart';
import 'package:bookversity/Models/Cards/bookCard.dart';
import 'package:bookversity/Models/Objects/book.dart';
import 'package:bookversity/Services/firestore_service.dart';
import 'package:bookversity/Widgets/shapes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:collection/collection.dart';

class BookListPage extends StatefulWidget {
  final ListingType _listPageType;
  BookListPage(this._listPageType);
  @override
  _BookListPageState createState() => _BookListPageState(_listPageType);
}

class _BookListPageState extends State<BookListPage> {
  ListingType _listPageType;
  _BookListPageState(this._listPageType);
  FireStoreService _fireStoreService = FireStoreService();
  CustomShapes _shapes = CustomShapes();
  List<Book> booksForSale = new List();
  List<String> bookImageURLs = new List();
  String _pageTitle;
  bool isLoading = false;
  // Start default by only sorting alphabetically
  bool sortFromAToZ = false;
  bool sortFromCheapToExpensive = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBooks();
  }

  showProgressIndicator(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  Future<void> fetchBooks() async {
    showProgressIndicator(true);
    _pageTitle = "Alle annoncer";
    List<Book> books = await _fireStoreService.getAllBooks();
    booksForSale = books;
    await getBookURLs();

  }

  Future<void> getBookURLs() async {
    if (booksForSale.length >= 1) {
      List<String> urls =
          await _fireStoreService.getBooksFromStorage(booksForSale);
      setState(() {
        bookImageURLs = urls;
        showProgressIndicator(false);
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
                child: topBar()),
            isLoading
                ? new Expanded(
                    flex: 10,
                    child: Center(child: CircularProgressIndicator(backgroundColor: CustomColors.materialYellow,),),
                  )
                : _loadedContent()
          ],
        ),
      ),
    );
  }

  Widget topBar(){
    return Row(
      children: [
        Container(
            padding: EdgeInsets.only(top: 16, left: 20),
            alignment: Alignment.center,
            child: CustomTextStyle(
                _pageTitle, 26, CustomColors.materialYellow)),
        Container(
          padding: EdgeInsets.only(top: 16, left: 70),
          child: IconButton(
            iconSize: 28,
            icon: sortFromAToZ ? Icon(FontAwesomeIcons.sortAlphaDown) : Icon(FontAwesomeIcons.sortAlphaDownAlt),
            color: CustomColors.materialYellow,
            onPressed: () async {
              await sortAlphabetically();
              showProgressIndicator(false);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16, right: 10),
          child: InkWell(
            onTap: () async {
              await sortByPrice();
              showProgressIndicator(false);
            },
            child: Row(
              children: [
                Icon(
                  sortFromCheapToExpensive ? FontAwesomeIcons.arrowUp : FontAwesomeIcons.arrowDown, color: CustomColors.materialYellow,
                ),
                Icon(
                  FontAwesomeIcons.dollarSign, color: CustomColors.materialYellow,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> sortAlphabetically() async {
    showProgressIndicator(true);
    booksForSale.clear();
    List<Book> books = await _fireStoreService.getAllBooks();
    sleep(Duration(milliseconds: 250));
    setState(() {
      sortFromAToZ = !sortFromAToZ;
      sortFromAToZ ? print("Sorting from A to Z") : print("Sorting from Z to A");
      sortFromCheapToExpensive = false;
      sortFromAToZ ?
      books.sort((a, b) => a.bookTitle.compareTo(b.bookTitle)) :
      books.sort((a, b) => b.bookTitle.compareTo(a.bookTitle));
      booksForSale = books;
    });
  }
  Future<void> sortByPrice() async {
    showProgressIndicator(true);
    booksForSale.clear();
    List<Book> books = await _fireStoreService.getBooksSortedByPrice(!sortFromCheapToExpensive);
    sleep(Duration(milliseconds: 250));
    setState(() {
      sortFromAToZ = false;
      sortFromCheapToExpensive = !sortFromCheapToExpensive;
      sortFromCheapToExpensive ? print("Sorting from expensive to cheap") : print("Sorting from cheap to expensive");
      booksForSale = books;
    });
  }

  Widget _loadedContent() {
    if (bookImageURLs.isNotEmpty) {
      return booksListView();
    }
  }

  Widget booksListView() {
    return new Expanded(
      flex: 10,
      child: new ListView.builder(
          shrinkWrap: true,
          itemCount: booksForSale.length,
          padding: const EdgeInsets.all(0),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return new BookCard(
                booksForSale[index],
                _shapes.customListShapeRight(),
                "right",
                bookImageURLs[index],
                false
            );
          }),
    );
  }
}
