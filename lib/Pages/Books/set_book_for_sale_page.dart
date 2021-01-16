import 'dart:io';

import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Models/Objects/book.dart';
import 'package:bookversity/Services/auth.dart';
import 'package:bookversity/Services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateListingBox extends StatefulWidget {
  @override
  _CreateListingBoxState createState() => _CreateListingBoxState();
}

class _CreateListingBoxState extends State<CreateListingBox> {
  AuthService _authService = AuthService();
  FireStoreService _fireStoreService = FireStoreService();

  bool _showAdBox = false;
  bool _showUploadIndicator = false;

  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _showAdBox = true;
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
    print("hey");
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
          child: formObject(TextInputType.text,"book", Icons.book, "Bogtitel"),
        ),
        Container(height: 1, color: Colors.grey[400]),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
          child: formObject(TextInputType.number,"isbn", Icons.library_books, "ISBN Kode"),
        ),
        Container(height: 1, color: Colors.grey[400]),
        Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
            child: formObject(TextInputType.number,"price", Icons.attach_money, "Pris")),
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
                      _showAdBox = !_showAdBox;
                      _showUploadIndicator = !_showUploadIndicator;
                    });
                    final snackBar = SnackBar(
                      backgroundColor: CustomColors.materialYellow,
                      content: Text('Din bog er nu sat til salg!',style: montSerratFont(CustomColors.materialDarkGreen),),
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
  Widget formObject(TextInputType textInputType, String type, IconData formIcon, String hintText) {
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
  montSerratFont(Color color) {
    return TextStyle(color: color, fontFamily: "Montserrat", fontSize: 20);
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
  Image showImage() {
    return Image(
      image: _image,
      fit: BoxFit.contain,
    );
  }
}
