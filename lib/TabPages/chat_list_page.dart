import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Constants/custom_textstyle.dart';
import 'package:bookversity/Models/Objects/chat.dart';
import 'package:bookversity/Services/firebase_chat_service.dart';
import 'package:bookversity/Services/firestore_service.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  ChatService chatService = new ChatService();

  List<Chat> chatList = new List();
  bool hasChats = false;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showLoading(true);
    fetchChatList();
  }

  void showLoading(bool show){
    setState(() {
      isLoading = show;
    });
  }

  Future<void> fetchChatList() async {
    print("Fetching chats");
    List<Chat> chatsResult = await chatService.fetchChats();
    showLoading(false);
    if(chatsResult.isEmpty){
      // display no chats
    }
    else{
      setState(() {
        chatList = chatsResult;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.materialLightGreen,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              topBar(),
              isLoading ? CircularProgressIndicator() : loadedContent()
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
          "Mine Samtaler", 36, CustomColors.materialDarkGreen)
    );
  }

  Widget loadedContent(){
    if(chatList.isEmpty){
      return showEmptyBody();
    }
    else if(chatList.isNotEmpty){
      return showChatList();
    }
  }

  Widget showEmptyBody(){
    return Container(
      child: CustomTextStyle(
          "Øv... Du har på nuværende tidspunkt ingen bøger til salg. "
              "For at komme igang med at sælge din bog, tryk på 'Sælg nu'",
          18,
          CustomColors.materialYellow),
    );
  }

  Widget showChatList(){
    return Container();
  }

}
