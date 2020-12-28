
import 'package:bookversity/Models/Objects/message.dart';
import 'dart:convert';

class Chat{
  List<Message> messages;
  String lastMessage;
  DateTime lastActivityDate;
  String buyerID;
  String sellerID;

  Chat(this.messages, this.lastMessage, this.lastActivityDate, this.buyerID,
      this.sellerID);

  Map<String, dynamic> toJson() => {
    'messages' : messages.toList(),
    'lastMessage' : messages.last,
    'lastActivityDate' : lastActivityDate,
    'buyerID' : buyerID,
    'sellerID' : sellerID,
  };
}