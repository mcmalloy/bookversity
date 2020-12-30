
import 'package:bookversity/Models/Objects/chat.dart';
import 'package:bookversity/Models/Objects/message.dart';
import 'package:bookversity/Services/auth.dart';
import 'package:bookversity/Services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService{
  FirebaseFirestore chatReference = FirebaseFirestore.instance;
  AuthService _authService = AuthService();

  Future<bool> createChat(String sellerID, String buyerID, String firstMessage) async{
    DateTime lastActivityDate = DateTime.now();
    Message message = new Message(firstMessage, buyerID, true,lastActivityDate);
    List<Message> messages = [];
    messages.add(message);
    messages.add(message);

    CollectionReference newConversation = chatReference.collection("chats");
    newConversation.add({
      'lastActivityDate' : lastActivityDate.toString(),
      'lastMessage' : firstMessage,
      'sellerID': sellerID,
      'buyerID': buyerID,
      'messages' : messages.map((message) => message.toJson()).toList()
    }).then((value) {
      return true;
    }).catchError((onError) {
      print(onError);
      return false;
    });
    return true;
  }

  Future<void> sendMessage(String message) async {

  }

  Future<List<Chat>> fetchChats() async {
    String uid = _authService.getCurrentUser().uid;
    Query query = FirebaseFirestore.instance.collection("chats");
    List<Chat> chats = [];

    query = query.where("sellerID", isEqualTo: uid);
    final QuerySnapshot result = await query.get();
    final List<DocumentSnapshot> documents = result.docs;

    //Find all chats with users uid
    for(int i = 0; i<documents.length; i++){
      List<dynamic> message = documents[i].get("messages");
      chats.add(new Chat(
          convertToList(message),
          documents[i].get("lastMessage"),
          DateTime.parse(documents[i].get("lastActivityDate")),
          documents[i].get("buyerID"),
          documents[i].get("sellerID"),
        ));
    }
    return chats;
  }

  List<Message> convertToList(List<dynamic> messages){
    List<Message> beskeder = [];
    for(int i = 0; i<messages.length; i++){
      beskeder.add(Message.fromJson(messages[i]));
    }
    return beskeder;
  }

}