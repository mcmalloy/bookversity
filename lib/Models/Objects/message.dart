
class Message {
  String message;
  String sentByID;
  bool isBuyer;
  DateTime messageSentTime;
  Message(this.message, this.sentByID, this.isBuyer, this.messageSentTime);

  Map<String, dynamic> toJson() => {
    'message' : message,
    'sentByID' : sentByID,
    'isBuyer' : isBuyer,
    'messageSentTime' : messageSentTime,
  };
}


