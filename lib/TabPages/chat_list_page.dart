import 'dart:async';

import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Constants/custom_textstyle.dart';
import 'package:bookversity/Models/Objects/chat.dart';
import 'package:bookversity/Pages/Chats/chat_details_page.dart';
import 'package:bookversity/Services/auth.dart';
import 'package:bookversity/Services/firebase_chat_service.dart';
import 'package:bookversity/Services/firestore_service.dart';
import 'package:bookversity/Services/state_storage.dart';
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
  AuthService _authService = AuthService();
  String uid;

  Timer timer;
  ChatService _chatService = ChatService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showLoading(true);
    fetchChatList();
    timer = new Timer(Duration(seconds: 5), () {
      refreshChat();
    });
  }

  void showLoading(bool show){
    setState(() {
      isLoading = show;
    });
  }

  Future<void> fetchChatList() async {
    print("Fetching chats");
    List<Chat> chatsResult = await chatService.fetchChats("sellerID") + await chatService.fetchChats("buyerID");
    showLoading(false);
    if(chatsResult.isEmpty){
      // display no chats
    }
    else{
      setState(() {
        uid = _authService.getCurrentUser().uid;
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
              isLoading ? Center(child: CircularProgressIndicator(),) : loadedContent()
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
      return Container(
        height: 600,
        width: 400,
        child: showChatList(),
      );
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
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 4),
      itemCount: chatList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            //TODO: Navigate to chat details
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetailsPage(chatList[index])));
          },
          child: Column(
            children: [
              Padding(padding: EdgeInsets.symmetric(vertical: 4),),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: chatList[index].lastMessage.isNotEmpty
                          ? BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        border: Border.all(
                          width: 2,
                          color: CustomColors.materialDarkGreen,
                        ),
                        // shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      )
                          : BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage("${chatList[index].imageURL}"),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.55,
                      padding: EdgeInsets.only(
                          left: 20
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                flex: 6,
                                child: Text(
                                  chatList[index].buyerID != uid ?
                                  "Salg af '${chatList[index].bookTitle}'" : "Køb af '${chatList[index].bookTitle}'",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Text(
                                  lastMessageDateString(chatList[index].lastActivityDate),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black54,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              chatList[index].lastMessage,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        );
      },
    );
  }

  String lastMessageDateString(DateTime lastActivityDate){
    String day = lastActivityDate.day.toString();
    String month = lastActivityDate.month.toString();
    String hour = lastActivityDate.hour.toString();
    String minute = lastActivityDate.minute.toString();
    return "${hour}:${minute}";
  }

  Future<void> refreshChat() async {
    List<Chat> _tempChatList = await chatService.fetchChats("sellerID") + await chatService.fetchChats("buyerID");
    setState(() {
      chatList = _tempChatList;
    });
    timer = new Timer(Duration(seconds: 5), () {
      refreshChat();
    });
  }

}
