import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // https://www.googleapis.com/books/v1/volumes?q=${978-1-118-55421-0}&maxResults=39&startIndex=0
  Future<bool> checkISBN(String isbn) async {
    try{
      var url = 'https://www.googleapis.com/books/v1/volumes?q=ISBN%{${isbn}}&maxResults=5&startIndex=0';
      print("searching url: $url");
      final response = await http.get(url);
      print(response.body);
      Map<String, dynamic> map = jsonDecode(response.body);
      print("Json: ${map['totalItems']}");
      int totalItems = map['totalItems'];
      print("totalItems: $totalItems");
      if(response.statusCode == 200 &&  totalItems > 0){
        return true;
      }
      return false;
    } catch (e){
      print("Exception caught: $e");
     return false;
    }
  }


}