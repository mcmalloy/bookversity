import 'dart:io';

import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Constants/enums.dart';
import 'package:bookversity/Models/Objects/book.dart';
import 'package:bookversity/Pages/Books/my_book_listings_page.dart';
import 'package:bookversity/Services/auth.dart';
import 'package:bookversity/Services/firestore_service.dart';
import 'package:bookversity/Services/state_storage.dart';
import 'package:bookversity/Widgets/shapes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDashBoard extends StatefulWidget {
  @override
  _ProfileDashBoardState createState() => _ProfileDashBoardState();
}

class _ProfileDashBoardState extends State<ProfileDashBoard> {
  bool _showAdBox = false;
  bool _showUploadIndicator = false;

  AuthService _authService = AuthService();
  FireStoreService _fireStoreService = FireStoreService();
  final StateStorageService _storageService = StateStorageService();
  CustomShapes _shapes = CustomShapes();
  LoginType _type;
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getSignInType();
  }

  void getSignInType() {
    setState(() {
      _type = _authService.getSignInType();
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        backgroundColor: CustomColors.materialLightGreen,
        body: SafeArea(
          bottom: true,
            child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                new Image(
                  alignment: Alignment.topLeft,
                  height: 80,
                  width: 80,
                  fit: BoxFit.fill,
                  image:
                      new AssetImage('assets/bookversity_facebook_profile.png'),
                ),
                Flexible(
                  flex: 2,
                  child: centerDashBoardWidget(),
                ),
                Flexible(
                  flex: 2,
                  child: topDashBoardWidgets(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 65),
                  child: logoutButton(),
                )
              ],
            ),
            _showAdBox
                ? Container(color: Colors.grey.withOpacity(0.9))
                : Container(
                    height: 0,
                  ),
            Container(
              child: createListingBox(),
            )
          ],
        )));
  }

  Widget topDashBoardWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /*
        dashBoardBox(
            160,
            160,
            customBoxShape(Colors.greenAccent[400], Colors.green[300]),
            "Mine\noplysninger",
            20,
            Icons.person_outline),
            SizedBox(
          width: 25,
        ),
         */
        InkWell(
          child: dashBoardBox(
              140,
              345,
              customBoxShape(CustomColors.materialYellow, Colors.orange[500]),
              "Ny annonce",
              21,
              Icons.attach_money),
          onTap: () {
            setState(() {
              _showAdBox = true;
            });
            createListingBox();
          },
        ),
      ],
    );
  }

  Widget centerDashBoardWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            print("Navigating to item list page");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyBooksListView()));
          },
          child: dashBoardBox(
              140,
              345,
              customBoxShape(Colors.blue[300], Colors.blue[700]),
              "Mine annoncer",
              22,
              Icons.book),
        ),
      ],
    );
  }

  customBoxShape(Color color1, Color color2) {
    return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [color1, color2],
        ),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(8)));
  }

  Widget dashBoardBox(double _height, double _width, dynamic shape,
      String tileText, double fontSize, IconData icon) {
    return Container(
      height: _height,
      width: _width,
      decoration: shape,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tileText,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Icon(
            icon,
            size: 60,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget logoutButton() {
    return RaisedButton(
        shape: _shapes.customButtonShape(),
        color: CustomColors.materialYellow,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () async {
          bool loggedOutSuccessfully = await _authService.fireBaseLogOut();
          if (loggedOutSuccessfully) {
            // TODO: LOG USER IN
            Navigator.pop(context);
          } else {
            // TODO: Display facebook login error
          }
        },
        child: Text(
          "Logout",
          style: TextStyle(
              fontSize: 18,
              fontFamily: "Montserrat",
              color: CustomColors.materialDarkGreen),
        ));
  }

  Widget createListingBox() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 600),
      top: _showAdBox ? 30 : -MediaQuery.of(context).size.height,
      left: 50,
      right: 50,
      bottom: _showAdBox ? 20 : MediaQuery.of(context).size.height,
      curve: Curves.easeInOutCubic,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    padding: EdgeInsets.only(top: 18, left: 25),
                    iconSize: 34,
                    icon: Icon(Icons.keyboard_return),
                    onPressed: () {
                      setState(() {
                        _showAdBox = !_showAdBox;
                      });
                    },
                  )
                ],
              ),
              bookForm(),
            ],
          ),
        ),
      ),
    );
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
              Text("Indsæt billede",
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 22.0,
                      color: CustomColors.materialDarkGreen)),
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
                            color: Colors.grey.withOpacity(0.5)),
                        child: _image == null
                            ? Column(
                                children: [
                                  Icon(Icons.cloud_upload),
                                  Text(
                                    "Tryk for at åbne billeder fra galleri",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 16.0,
                                        color: CustomColors.materialDarkGreen),
                                    textAlign: TextAlign.center,
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
                      _priceController.text,
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
                      _showAdBox = !_showAdBox;
                      _showUploadIndicator = !_showUploadIndicator;
                    });
                    final snackBar = SnackBar(
                      backgroundColor: CustomColors.materialYellow,
                      content: Text(
                        'Din bog er nu sat til salg!',
                        style: montSerratFont(CustomColors.materialDarkGreen),
                      ),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                  } else {
                    //TODO: Display alertdialog with error
                  }
                },
                color: CustomColors.materialYellow,
                child: _showUploadIndicator
                    ? CircularProgressIndicator()
                    : Text(
                        "Opret Annonce",
                        style: montSerratFont(CustomColors.materialDarkGreen),
                      ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget formObject(TextInputType textInputType, String type, IconData formIcon,
      String hintText) {
    return Container(
        padding: EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.withOpacity(0.5)),
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
      print("Returning from gallery");
      print("File path: ${pickedImage.path}");
      setState(() {
        _image = FileImage(File(pickedImage.path));
        _pickedImage = File(pickedImage.path);
        print("File has been picked");
      });
    } catch (e) {
      print(e);
    }
  }

  montSerratFont(Color color) {
    return TextStyle(color: color, fontFamily: "Montserrat", fontSize: 20);
  }

  Widget getBookList() {
    List<Book> lists = List<Book>();
    final dbRef = FirebaseDatabase.instance.reference().child("booksForSale");

    return FutureBuilder(
        future: dbRef.once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            lists.clear();
            Map<dynamic, dynamic> values = snapshot.data.value;
            values.forEach((key, values) {
              lists.add(values);
            });
            return new ListView.builder(
                shrinkWrap: true,
                itemCount: lists.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Book Title: " + lists[index].bookTitle),
                        Text("ISBN Code: " + lists[index].isbnCode),
                        Text("Price: " + lists[index].price),
                      ],
                    ),
                  );
                });
          }
          return CircularProgressIndicator();
        });
  }
}
