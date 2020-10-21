
import 'package:flutter/material.dart';

class ChatDetailsPage extends StatefulWidget {
  final String chatID;

  ChatDetailsPage(this.chatID);
  @override
  _ChatDetailsPageState createState() => _ChatDetailsPageState(chatID);
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  final String chatID;
  _ChatDetailsPageState(this.chatID);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
