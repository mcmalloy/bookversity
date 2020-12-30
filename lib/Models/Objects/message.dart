
class Message {
  String message;
  String sentByID;
  bool isBuyer;
  DateTime messageSentTime;
  Message(this.message, this.sentByID, this.isBuyer, this.messageSentTime);

  factory Message.fromJson(Map<String, dynamic> json){
    return Message(
      json['message'],
      json['sentByID'],
      json['isBuyer'] as bool,
      DateTime.parse(json['messageSentTime']),
    );
  }
  /*
   message : json['message'],
        sentByID : json['sentByID'],
        isBuyer : json['isBuyer'],
        messageSentTime : DateTime.parse(json['messageSentTime'])
   */


  Map<String, dynamic> toJson() => {
    'message' : message,
    'sentByID' : sentByID,
    'isBuyer' : isBuyer,
    'messageSentTime' : messageSentTime.toString(),
  };
   
}




