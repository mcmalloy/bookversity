
import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Constants/custom_textstyle.dart';
import 'package:bookversity/Models/Objects/chat.dart';
import 'package:bookversity/Services/auth.dart';
import 'package:flutter/material.dart';

class ChatDetailsPage extends StatefulWidget {
  Chat chat;
  ChatDetailsPage(this.chat);
  @override
  _ChatDetailsPageState createState() => _ChatDetailsPageState(chat);
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  Chat chat;
  String uid;
  AuthService _authService = AuthService();
  _ChatDetailsPageState(this.chat);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      uid = _authService.getCurrentUser().uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                topBar(),
                loadedContent()
              ],
            ),
          ),
        )
    );
  }

  Widget topBar(){
    return Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: CustomColors.materialDarkGreen, offset: Offset(2.0, 2.0))
        ]),
        width: double.infinity,
        padding: EdgeInsets.only(left: 16, bottom: 5, right: 12),
        child: CustomTextStyle(
          chat.buyerID == uid ?
            "Salg af ${chat.bookTitle}" : "Køb af ${chat.bookTitle}", 32, CustomColors.materialDarkGreen)
    );
  }

  Widget loadedContent() {
    return Container();
  }
}
