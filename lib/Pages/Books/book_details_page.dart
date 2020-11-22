import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Constants/custom_textstyle.dart';
import 'package:bookversity/Models/Objects/book.dart';
import 'package:bookversity/Services/auth.dart';
import 'package:bookversity/Services/firebase_chat_service.dart';
import 'package:bookversity/Widgets/shapes.dart';
import 'package:flutter/material.dart';

class BookDetailsPage extends StatefulWidget {
  Book book;
  String imageURL;
  BookDetailsPage(this.book, this.imageURL);

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState(book, imageURL);
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  Book book;
  String imageURL;
  bool _showChatBox = false;
  bool _showUploadIndicator = false;
  final TextEditingController firstMessageController = TextEditingController();

  _BookDetailsPageState(this.book, this.imageURL);
  AuthService _authService = AuthService();
  ChatService chatService = ChatService();
  CustomShapes _shapes = CustomShapes();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.materialLightGreen,
      body: Container(
        child: Stack(
          children: [Column(
          children: [
            customSpace(),
            topBar(),
            SizedBox(
              height: 40,
            ),
            bookBody(),
            SizedBox(
              height: 80,
            ),
            contactSellerButton(),
            
          ],
        ),
        _showChatBox ?
             Container(color: Colors.grey.withOpacity(0.7))
             : Container(height: 0,),
             Container(

               child: createChatBox(),)
        ],
        )
      ),
    );
  }

  Widget customSpace() {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Container(color: Colors.white),
    );
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
              CustomTextStyle(
                  "Kontakt Sælger", 36, CustomColors.materialDarkGreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget bookBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: CustomTextStyle("Bogtitel: ${book.bookTitle}", 16,
                    CustomColors.materialDarkGreen),
                padding: textSeparatorPadding(),
              ),
              Container(
                child: CustomTextStyle(
                    "Pris: ${book.price}", 16, CustomColors.materialDarkGreen),
                padding: textSeparatorPadding(),
              ),
              Container(
                child: CustomTextStyle("ISBN Kode: ${book.isbnCode}", 16,
                    CustomColors.materialDarkGreen),
                padding: textSeparatorPadding(),
              ),
              Container(
                height: 300,
                child: Image.network(imageURL),
              ),
            ],
          ),
        ),
      ],
    );
  }

  textSeparatorPadding() {
    return EdgeInsets.only(bottom: 15);
  }

  Widget contactSellerButton() {
    return RaisedButton(
      shape: _shapes.customButtonShape(),
      color: CustomColors.materialYellow,
      onPressed: () {
        //TODO: Open chat message screen
        setState(() {
          _showChatBox = true;
        });
      },
      child: Container(
        child: CustomTextStyle(
            "Skriv til sælger", 20, CustomColors.materialDarkGreen),
      ),
    );
  }

  Widget createChatBox() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 600),
      top: _showChatBox ? 120 : -MediaQuery.of(context).size.height,
      left: 24,
      right: 24,
      bottom: _showChatBox ? 20 : MediaQuery.of(context).size.height,
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
                        _showChatBox = !_showChatBox;
                      });
                    },
                  )
                ],
              ),
              chatForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget chatForm() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
          child: Container(
              padding: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.withOpacity(0.5)),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: firstMessageController,
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 16.0,
                    color: CustomColors.materialDarkGreen),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.message,
                    color: Colors.black,
                    size: 22.0,
                  ),
                  hintStyle: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 22.0,
                      color: CustomColors.materialDarkGreen),
                ),
                onChanged: (controller) {
                  print("Changed ${controller.toString()}");
                },
              )),
        ),
        Container(height: 1, color: Colors.grey[400]),
        RaisedButton(
            onPressed: () async {
              // Create chat object

              //TODO: Set loading animation
              setState(() {
                _showUploadIndicator = true;
              });
              String uid = _authService.getCurrentUser().uid;
              print("Open initiate chat between user: $uid and ${book.userID}");
              bool uploadResult = await chatService.createChat(
                  uid, book.userID, "Hello World!");
              if (uploadResult) {
                //TODO: Finish loading animation and pop container
                setState(() {
                  _showChatBox = !_showChatBox;
                  _showUploadIndicator = !_showUploadIndicator;
                });
              } else {
                //TODO: Display alertdialog with error
              }
            },
            color: CustomColors.materialYellow,
            child: _showUploadIndicator
                ? CircularProgressIndicator()
                : Text("Send Besked"))
      ],
    );
  }
}
