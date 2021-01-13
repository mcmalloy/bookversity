import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Constants/custom_textstyle.dart';
import 'package:bookversity/Constants/enums.dart';
import 'package:bookversity/Models/Cards/bookCard.dart';
import 'package:bookversity/Models/Objects/book.dart';
import 'package:bookversity/Services/firestore_service.dart';
import 'package:bookversity/Widgets/shapes.dart';
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
  List<String> bookImageURLs = new List();
  String _pageTitle;
  bool isLoading = false;

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
    setState(() {
      booksForSale = books;
      getBookURLs();
    });
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
                child: Row(
                  children: [
                    _listPageType == ListingType.allBooksForSale
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : IconButton(
                            icon: Icon(FontAwesomeIcons.arrowLeft),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                    Container(
                        padding: EdgeInsets.only(top: 15, left: 25),
                        alignment: Alignment.center,
                        child: CustomTextStyle(
                            _pageTitle, 26, CustomColors.materialYellow))
                  ],
                )),
            isLoading
                ? Expanded(
                    flex: 10,
                    child: Center(child: CircularProgressIndicator(backgroundColor: CustomColors.materialYellow,),),
                  )
                : _loadedContent()
          ],
        ),
      ),
    );
  }

  Widget _loadedContent() {
    if (bookImageURLs.isNotEmpty) {
      return booksListView();
    }
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
              return BookCard(
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
