import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Constants/custom_textstyle.dart';
import 'package:bookversity/Models/Objects/chat.dart';
import 'package:bookversity/Models/Objects/message.dart';
import 'package:bookversity/Services/auth_service.dart';
import 'package:bookversity/Services/firebase_chat_service.dart';
import 'file:///C:/Users/Mark/StudioProjects/bookversity/lib/Pages/Chats/chat_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
import 'dart:async';

class ChatDetailsPage extends StatefulWidget {
  Chat chat;
  ChatDetailsPage(this.chat);
  @override
  _ChatDetailsPageState createState() => _ChatDetailsPageState(chat);
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  Chat chat;
  List<Message> messages = [];
  String uid;
  TextEditingController _chatController = TextEditingController();
  bool sendingChat = false;
  Timer timer;
  AuthService _authService = AuthService();
  ChatService _chatService = ChatService();
  _ChatDetailsPageState(this.chat);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      uid = _authService.getCurrentUser().uid;
      messages = chat.messages;
    });
    timer = new Timer(Duration(seconds: 5), () {
      refreshChat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
        backgroundColor: Color(0xffE7E7ED),
        body: SafeArea(
          child: Container(
            child: Column(
              children: [topBar(), loadedContent(), chatField()],
            ),
          ),
        )
    ), onWillPop: (){
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/chatListPage', (Route<dynamic> route) =>false);
    });
  }

  Widget topBar() {
    return Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: CustomColors.materialDarkGreen, offset: Offset(2.0, 2.0))
        ]),
        width: double.infinity,
        padding: EdgeInsets.only(left: 16, bottom: 5, right: 12),
        child: CustomTextStyle(
            chat.buyerID == uid
                ? "Køb af '${chat.bookTitle}'"
                : "Salg af '${chat.bookTitle}'",
            32,
            CustomColors.materialDarkGreen));
  }

  Widget loadedContent() {
    return Expanded(
      child: MediaQuery.removePadding(
          context: context, child: createChatBubbles()),
    );
  }

  Widget createChatBubbles() {
    return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 4),
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          return messages[index].sentByID == uid
              ? senderChatBubble(messages[index])
              : receiverChatbubble(messages[index]);
        });
  }

  String createDateString(DateTime time){
   String hour = time.hour.toString();
   String minute = time.minute.toString();

   return "${hour}:${minute}";
  }

  Widget senderChatBubble(Message chat) {
    return Column(
      children: [
        ChatBubble(
          clipper: ChatBubbleClipper2(type: BubbleType.sendBubble),
          alignment: Alignment.topRight,
          margin: EdgeInsets.only(top: 20),
          backGroundColor: CustomColors.materialDarkGreen,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Text(
              chat.message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 6, left: 340),
            child: Text(createDateString(chat.messageSentTime), style: TextStyle(color: Colors.grey[700], fontSize: 12.0),)),
      ],
    );
  }

  Widget receiverChatbubble(Message chat) {
    return Column(
      children: [
    ChatBubble(
    clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
    backGroundColor: CustomColors.materialYellow,
    margin: EdgeInsets.only(top: 20),
    child: Container(
    constraints: BoxConstraints(
    maxWidth: MediaQuery.of(context).size.width * 0.7,
    ),
    child: Text(
    chat.message,
    style: TextStyle(color: Colors.black),
    ),
    ),
    ),
        Padding(
            padding: EdgeInsets.only(top: 6, right: 340),
            child: Text(createDateString(chat.messageSentTime), style: TextStyle(color: Colors.grey[700], fontSize: 12.0),)),
      ],
    );
  }

  Widget messageList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 4),
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
            ),
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
                      decoration: BoxDecoration(
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
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              lastMessageDateString(
                                  messages[index].messageSentTime),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w300,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            messages[index].message,
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
        );
      },
    );
  }

  Widget chatField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: SizedBox(
        height: 60,
        child: chatInput(),
      ),
    );
  }

  Widget chatInput() {
    return Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Row(
            children: [
              Flexible(
                child: Container(
                  child: TextField(
                    controller: _chatController,
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                    decoration: InputDecoration.collapsed(
                        hintText: "Indtast Besked",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
              ),
              Material(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: sendingChat
                      ? CircularProgressIndicator()
                      : IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            if (_chatController.text.isNotEmpty) {
                              Message message = new Message(
                                  _chatController.text,
                                  uid,
                                  chat.buyerID == uid ? false : true,
                                  DateTime.now());
                              sendMessage(message);
                              _chatController.clear();
                              FocusScope.of(context).unfocus();
                              refreshChat();
                            }
                          },
                          color: Colors.black,
                        ),
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        width: double.infinity,
        height: 50.0,
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
              color: Colors.black.withOpacity(0.6),
              width: 0.5,
            )),
            color: Colors.white));
  }

  String lastMessageDateString(DateTime lastActivityDate) {
    String hour = lastActivityDate.hour.toString();
    String minute = lastActivityDate.minute.toString();
    return "${hour}:${minute}";
  }

  Future<void> sendMessage(Message message) async {
    await _chatService.sendMessage(message, chat);
  }

  Future<void> refreshChat() async {
    Chat _tempChat = await _chatService
        .fetchChat("${chat.sellerID}-${chat.buyerID}-${chat.bookTitle}");
    setState(() {
      chat = _tempChat;
      messages = chat.messages;
    });
    timer = new Timer(Duration(seconds: 5), () {
      refreshChat();
    });
  }
}
