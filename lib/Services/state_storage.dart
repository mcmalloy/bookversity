import 'package:shared_preferences/shared_preferences.dart';

class StateStorageService{

  String facebookUID;

  Future<void> saveFacebookUID(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Saving id: $id");
    prefs.setString("facebookUID", id);
  }

  Future<String> getFacebookUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("facebookUID");
    if(id!=null){
      print("Succesfully retrieved id: $id");
      return id;
    }
    return null;
  }




}