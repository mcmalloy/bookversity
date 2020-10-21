
import 'package:bookversity/Services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService{
  FirebaseFirestore chatReference = FirebaseFirestore.instance;

  Future<bool> createChat(String sellerID, String buyerID, String firstMessage) async{
    CollectionReference newChat = chatReference.collection("chats");
    newChat.add({
      'sellerID': sellerID,
      'buyerID': buyerID,
    }).then((value) {
      print("Chat has been created with id: ${newChat.id}");
      return true;
    }).catchError((onError) {
      print(onError);
      return false;
    });
    return true;
  }

  Future<bool> sendFirstMessage(String sellerID, String buyerID, String firstMessage) async{
    FirebaseFirestore messageReference = FirebaseFirestore.instance;


  }










}