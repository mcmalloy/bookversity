
import 'package:bookversity/Models/Objects/chat.dart';
import 'package:bookversity/Models/Objects/message.dart';
import 'package:bookversity/Services/auth_service.dart';
import 'package:bookversity/Services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatService{
  FirebaseFirestore chatReference = FirebaseFirestore.instance;
  AuthService _authService = AuthService();

  Future<bool> createChat(String sellerID, String buyerID, String firstMessage, String imageURL, String bookTitle) async{
    DateTime lastActivityDate = DateTime.now();
    Message message = new Message(firstMessage, buyerID, true,lastActivityDate);
    List<Message> messages = [];
    messages.add(message);

    chatReference.collection("chats").doc("${sellerID}-${buyerID}-${bookTitle}").set({
      'lastActivityDate' : lastActivityDate.toString(),
      'lastMessage' : firstMessage,
      'sellerID': sellerID,
      'buyerID': buyerID,
      'messages' : messages.map((message) => message.toJson()).toList(),
      'imageURL' : imageURL,
      'bookTitle' : bookTitle,
      'chatID' : "${sellerID}-${buyerID}-${bookTitle}"
    }).then((value) {
      return true;
    }).catchError((onError) {
      print(onError);
      return false;
    });
    return true;
  }

  Future<void> sendMessage(Message message, Chat chat) async {
    String uid = _authService.getCurrentUser().uid;
    String chatID = "${chat.sellerID}-${chat.buyerID}-${chat.bookTitle}";
    chat.messages.add(message);
    print("Sending message!");
    final firestoreInstance = FirebaseFirestore.instance;
    firestoreInstance.collection("chats").doc(chatID).update({
      'messages' : chat.messages.map((message) => message.toJson()).toList(),
      'lastActivityDate' : DateTime.now().toString(),
      'lastMessage' : message.message
    });
  }
  Future<List<Chat>> fetchChats(String idType) async {
    String uid = _authService.getCurrentUser().uid;
    Query query = FirebaseFirestore.instance.collection("chats");
    List<Chat> chats = [];

    query = query.where(idType, isEqualTo: uid);
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
          documents[i].get("imageURL"),
          documents[i].get("bookTitle")
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

  Future<Chat> fetchChat(String chatID) async {
    final firestoreInstance = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await firestoreInstance.collection("chats").doc(chatID).get();
    List<dynamic> message = snapshot.get("messages");

    return new Chat(
        convertToList(message),
        snapshot.get("lastMessage"),
        DateTime.parse(snapshot.get("lastActivityDate")),
        snapshot.get("buyerID"),
        snapshot.get("sellerID"),
        snapshot.get("imageURL"),
        snapshot.get("bookTitle")
    );
  }

  Future<void> sendNotification() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  }

}