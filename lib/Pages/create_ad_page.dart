import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Pages/camera_page.dart';
import 'package:bookversity/Widgets/shapes.dart';
import 'package:flutter/material.dart';

class CreateAddPage extends StatefulWidget {
  @override
  _CreateAddPageState createState() => _CreateAddPageState();
}

class _CreateAddPageState extends State<CreateAddPage> {
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  CustomShapes _shapes = CustomShapes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("List your book"),
          leading: new Icon(Icons.arrow_back,
              size: 30, color: CustomColors.materialYellow),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 40)),
              Card(
                  color: Colors.grey[300],
                  elevation: 2,
                  shape: _shapes.customBoxShape1(),
                  child: bookForm()),
            ],
          ),
        ));
  }

  Widget bookForm() {
    return Container(
        width: 250,
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
              child: formObject("book", Icons.book, "Bogtitel"),
            ),
            Container(height: 1, color: Colors.grey[400]),
            Padding(
              padding:
                  EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
              child: formObject("isbn", Icons.library_books, "ISBN Kode"),
            ),
            Container(height: 1, color: Colors.grey[400]),
            Padding(
                padding:
                    EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
                child: formObject("price", Icons.attach_money, "Pris")),
            Container(height: 1, color: Colors.grey[400]),
            Padding(
              padding:
                  EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.camera_enhance,
                    color: Colors.black,
                    size: 22.0,
                  ),
                  hintText: "Tag billede",
                  hintStyle: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 22.0,
                      color: CustomColors.materialDarkGreen),
                ),
                onTap: () {
                  //TODO: Open camera view
                },
              ),
            )
          ],
        ));
  }

  Widget formObject(String type, IconData formIcon, String hintText) {
    return TextFormField(
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
    );
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
}
