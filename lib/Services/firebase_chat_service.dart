
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

    CollectionReference newConversation = chatReference.collection("chats");
    newConversation.add({
      'lastActivityDate' : lastActivityDate,
      'lastMessage' : firstMessage,
      'sellerID': sellerID,
      'buyerID': buyerID,
      'messages' : messages.map((message) => message.toJson()).toList()
    }).then((value) {
      print("Chat has been created with id: ${newConversation.id}");
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
    CollectionReference conversations = chatReference.collection("chats");
    //final QuerySnapshot result = await conversations.get();
    print("establishing query....");
    query = query.where("sellerID", isEqualTo: uid);
    final QuerySnapshot result = await query.get();
    final List<DocumentSnapshot> documents = result.docs;
    print("query successful");
    print("document: ${documents.toString()}");
    //Find all chats with users uid
    for(int i = 0; i<documents.length; i++){
      print(documents[i].get("messages"));
      List<Message> messages = Message.fromJson(documents[i].get("messages"));
        chats.add(new Chat(
          messages,
          //documents[i].get("messages"),
          documents[i].get("lastMessage"),
          documents[i].get("lastActivityDate"),
          documents[i].get("buyerID"),
          documents[i].get("sellerID"),
        ));
        print(chats[i].toJson());
    }

    return chats;
    
  }












}