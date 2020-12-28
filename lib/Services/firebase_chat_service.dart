
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
    List<Message> messages = new List<Message>();
    messages.add(message);
    messages.add(Message("Second Message!", buyerID, true,lastActivityDate));

    Chat newChat = Chat(messages,firstMessage,lastActivityDate,buyerID,sellerID);
    print("chat json: ");
    print(newChat.toJson());

    CollectionReference newConversation = chatReference.collection("chats");
    newConversation.add({
      'lastActivityDate' : lastActivityDate,
      'lastMessage' : firstMessage,
      'sellerID': sellerID,
      'buyerID': buyerID,
      'messages' : firstMessage
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
    List<Chat> chats = new List<Chat>();
    CollectionReference conversations = chatReference.collection("chats");
    final QuerySnapshot result = await conversations.get();
    final List<DocumentSnapshot> documents = result.docs;
    
    //Find all chats with users uid
    for(int i = 0; i<documents.length; i++){
      if(documents[i].get("buyerID") == uid || documents[i].get("sellerID") == uid){
        chats.add(new Chat(
          documents[i].get("messages"),
          documents[i].get("lastMessage"),
          documents[i].get("lastActivityDate"),
          documents[i].get("buyerID"),
          documents[i].get("sellerID"),
        ));
      }
    }

    return chats;
    
  }












}