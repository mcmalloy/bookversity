
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
    'messages' :messages.map((message) => message.toJson()).toList(),
    'lastMessage' : messages.last.toJson(),
    'lastActivityDate' : lastActivityDate,
    'buyerID' : buyerID,
    'sellerID' : sellerID,
  };

}

