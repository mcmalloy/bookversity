import 'dart:async';
import 'dart:io';

import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Constants/custom_textstyle.dart';
import 'package:bookversity/Constants/enums.dart';
import 'package:bookversity/Models/Cards/bookCard.dart';
import 'package:bookversity/Models/Cards/deleteBookCard.dart';
import 'package:bookversity/Models/Objects/book.dart';
import 'package:bookversity/Services/auth_service.dart';
import 'package:bookversity/Services/firestore_service.dart';
import 'package:bookversity/Widgets/shapes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyBooksListView extends StatefulWidget {
  @override
  _MyBooksListViewState createState() => _MyBooksListViewState();
}

class _MyBooksListViewState extends State<MyBooksListView> {
  FireStoreService _fireStoreService = FireStoreService();
  AuthService _authService = AuthService();

  CustomShapes _shapes = CustomShapes();
  List<Book> booksForSale = new List();
  List<String> bookImageURLs = new List();
  bool isDeleting = false;
  bool isLoading = false;
  bool showForm = false;
  bool _showUploadIndicator = false;
  ListingType listingType;

  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listingType = ListingType.myBooksForSale;
    showProgressIndicator(true);
    getBooks();
  }

  @override
  void dispose() {
    super.dispose();
  }


  showProgressIndicator(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  Future<void> getBooks() async {
    List<Book> books = await _fireStoreService.getMyBooks();
    if (books.isNotEmpty) {
      setState(() {
        booksForSale.clear();
        booksForSale = books;
        getBookImageURLs();
      });
    } else {
      showProgressIndicator(false);
    }
  }

  Future<void> getBookImageURLs() async {
    if (booksForSale.length >= 1) {
      List<String> urls =
          await _fireStoreService.getMyBooksImages(booksForSale);
      setState(() {
        bookImageURLs = urls;
        showProgressIndicator(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.materialLightGreen,
        body: Container(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
              width: double.infinity,
              child: Container(color: Colors.white),
            ),
            topBar(),
            isLoading
                ?
            Center(
                child: CircularProgressIndicator(
                  backgroundColor: CustomColors.materialYellow,
                )) : _loadedContent(),
          ],
        ),
        ));
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
              isDeleting
                  ? CustomTextStyle("Fjern Annonce", 36, Colors.red[700])
                  : CustomTextStyle(
                      "Mine Annoncer", 36, CustomColors.materialDarkGreen),
              isDeleting
                  ? CustomTextStyle("Tryk på et opslag for at fjerne det", 14,
                      Colors.red[700])
                  : CustomTextStyle("Tryk på et opslag for at redigere det", 14,
                      CustomColors.materialDarkGreen)
            ],
          ),
          Row(
            children: [
              IconButton(
                iconSize: 40,
                icon: Icon(Icons.delete),
                color: isDeleting
                    ? Colors.red[700]
                    : CustomColors.materialDarkGreen,
                onPressed: () {
                  setState(() {
                    isDeleting = !isDeleting;
                    _loadedContent();
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _loadedContent() {
    if (booksForSale.isEmpty) {
      return createBookListingWidget();
    }
    if (isDeleting && bookImageURLs.isNotEmpty) {
      listingType = ListingType.deleteBooksForSale;
      return booksListView();
    } else if (!isDeleting && bookImageURLs.isNotEmpty) {
      listingType = ListingType.myBooksForSale;
      return booksListView();
    }
  }

  Widget booksListView() {
    return Expanded(
      flex: 10,
      child: new ListView.builder(
          shrinkWrap: true,
          itemCount: booksForSale.length,
          padding: const EdgeInsets.all(0),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return determineCardType(index);
          }),
    );
  }

  Widget determineCardType(int index) {
    if (listingType == ListingType.myBooksForSale) {
      print("printing book");
      return BookCard(booksForSale[index], _shapes.customListShapeLeft(),
          "left", bookImageURLs[index], true);
    } else if (listingType == ListingType.deleteBooksForSale) {
      return InkWell(
        onTap: () async {
          await deleteDialog(booksForSale[index], context);
        },
        child: DeleteBookCard(booksForSale[index],
            _shapes.customListShapeLeft(), bookImageURLs[index]),
      );
    }
    return null;
  }

  Widget deleteBookItemButton() {
    return RaisedButton(
      onPressed: () {

      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: CustomColors.materialYellow,
      elevation: 3.0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child:
            CustomTextStyle("Slet Opslag", 18, CustomColors.materialDarkGreen),
      ),
    );
  }

  Widget setListToDelete() {}

  Widget setListToUpdate() {}

  Widget createBookListingWidget() {
    return Column(
      children: [
        showForm
            ? Container(
                height: 0,
              )
            : Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 4,
                    left: 15,
                    right: 15,
                    bottom: 15),
                child: CustomTextStyle(
                    "Øv... Du har på nuværende tidspunkt ingen bøger til salg. "
                    "For at komme igang med at sælge din bog, tryk på 'Sælg nu'",
                    18,
                    CustomColors.materialYellow),
              ),
        SizedBox(
          height: 95,
        ),
        animateTest()
      ],
    );
  }

  Widget animateTest() {
    return AnimatedCrossFade(
      crossFadeState:
          !showForm ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: Duration(milliseconds: 1500),
      firstChild: createListingButton(),
      secondChild: createListingForm(),
    );
  }

  Widget createListingButton() {
    return RaisedButton(
      shape: _shapes.customButtonShape(),
      color: CustomColors.materialYellow,
      child: Center(
          child: CustomTextStyle(
              "Opret Annonce", 18, CustomColors.materialDarkGreen)),
      onPressed: () {
        setState(() {
          showForm = true;
        });
      },
    );
  }

  Widget createListingForm() {
    return SingleChildScrollView(child: bookForm());
  }

  Widget bookForm() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
          child: formObject(TextInputType.text, "book", Icons.book, "Bogtitel"),
        ),
        Container(height: 1, color: Colors.grey[400]),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
          child: formObject(
              TextInputType.number, "isbn", Icons.library_books, "ISBN Kode"),
        ),
        Container(height: 1, color: Colors.grey[400]),
        Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
            child: formObject(
                TextInputType.number, "price", Icons.attach_money, "Pris")),
        Container(height: 1, color: Colors.grey[400]),
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 20, left: 25, right: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextStyle(
                  "Indsæt billede", 22, CustomColors.materialYellow),
              Padding(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 20, left: 25, right: 25),
                  child: InkWell(
                    onTap: () {
                      print("Image is != null statement: ${_image != null}");
                      _imgFromGallery(ImageSource.gallery);
                    },
                    child: Container(
                        height: 150,
                        width: 220,
                        padding: EdgeInsets.only(top: 40),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.withOpacity(1)),
                        child: _image == null
                            ? Column(
                                children: [
                                  Icon(Icons.cloud_upload),
                                  Center(
                                    child: CustomTextStyle(
                                        "Tryk for at åbne billeder fra galleri",
                                        16,
                                        CustomColors.materialYellow),
                                  )
                                ],
                              )
                            : showImage()),
                  )),
              RaisedButton(
                onPressed: () async {
                  // Create book object
                  Book book = new Book(
                      _bookNameController.text,
                      _isbnController.text,
                      int.parse(_priceController.text),
                      _authService.getCurrentUser().uid,
                      _pickedImage,
                      null);
                  //TODO: Set loading animation
                  setState(() {
                    _showUploadIndicator = true;
                  });
                  bool uploadResult = await _fireStoreService.uploadBook(book);
                  if (uploadResult) {
                    //TODO: Finish loading animation and pop container
                    setState(() {
                      showForm = false;
                      _showUploadIndicator = false;
                      getBooks();
                    });
                  } else {
                    //TODO: Display alertdialog with error
                  }
                },
                color: CustomColors.materialYellow,
                child: _showUploadIndicator
                    ? CircularProgressIndicator()
                    : CustomTextStyle(
                        "Opret Annonce", 20, CustomColors.materialDarkGreen),
              ),
            ],
          ),
        )
      ],
    );
  }

  void showUploadedSnackbar() {
    final snackBar = SnackBar(
        backgroundColor: CustomColors.materialYellow,
        content: CustomTextStyle(
            "Din bog er nu sat til salg!", 18, CustomColors.materialDarkGreen));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Image showImage() {
    return Image(
      image: _image,
      fit: BoxFit.contain,
    );
  }

  final ImagePicker _picker = ImagePicker();
  FileImage _image;
  File _pickedImage;
  //Open gallery
  Future<void> _imgFromGallery(ImageSource source) async {
    try {
      PickedFile pickedImage = await _picker.getImage(source: source);
      setState(() {
        _image = FileImage(File(pickedImage.path));
        _pickedImage = File(pickedImage.path);
      });
    } catch (e) {
      print(e);
    }
  }

  TextEditingController determineController(String type) {
    if (type == "book") {
      return _bookNameController;
    } else if (type == "isbn") {
      return _isbnController;
    } else {
      return _priceController;
    }
  }

  Widget formObject(TextInputType textInputType, String type, IconData formIcon,
      String hintText) {
    return Container(
        padding: EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: TextFormField(
          keyboardType: textInputType,
          controller: determineController(type),
          style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 16.0,
              color: CustomColors.materialDarkGreen),
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(
              formIcon,
              color: Colors.black,
              size: 22.0,
            ),
            hintText: "$hintText",
            hintStyle: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 22.0,
                color: CustomColors.materialDarkGreen),
          ),
          onChanged: (controller) {
            print("Changed ${controller.toString()}");
          },
        ));
  }

  Future<void> deleteDialog(Book book, BuildContext context) {
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
                child: CustomTextStyle("Slet Annonce", 16, Colors.red),
                onPressed: () async {
                  Navigator.of(context).pop();
                  print("Attempting to delete '${book.bookTitle}'");
                  bool result = await _fireStoreService.deleteBookListing(book.bookTitle);
                  print("Result of deletion: result");
                  if(result){
                    setState(() {
                      isDeleting = false;
                      booksForSale.removeWhere((books) => books.bookTitle == book.bookTitle);
                      getBookImageURLs();
                    });
                    //showSnackBar();
                    //getBooks();
                  }
                },
              ),
              FlatButton(
                child: CustomTextStyle(
                    "Behold Annonce", 16, CustomColors.materialLightGreen),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void showSnackBar(){
    Scaffold.of(context).showSnackBar(getSnackbar());
  }

  Widget getSnackbar(){
    return SnackBar(
      backgroundColor: CustomColors.materialYellow,
      content: Text(
        'Din bog samt tilhørende samtaler er nu fjernet fra bookversity!',
        style: montSerratFont(CustomColors.materialDarkGreen),
      ),
    );
  }
  montSerratFont(Color color) {
    return TextStyle(color: color, fontFamily: "Montserrat", fontSize: 20);
  }
}
