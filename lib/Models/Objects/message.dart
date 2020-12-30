
class Message {
  String message;
  String sentByID;
  bool isBuyer;
  DateTime messageSentTime;
  Message(this.message, this.sentByID, this.isBuyer, this.messageSentTime);

  Message.fromJson(Map<String, dynamic> json)
      :
        message = json['message'],
        sentByID = json['sentByID'],
        isBuyer = json['isBuyer'],
        messageSentTime = json['messageSentTime'];

  Map<String, dynamic> toJson() => {
    'message' : message,
    'sentByID' : sentByID,
    'isBuyer' : isBuyer,
    'messageSentTime' : messageSentTime,
  };
   
}




