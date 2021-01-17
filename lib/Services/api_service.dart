import 'package:http/http.dart' as http;

class ApiService {
  // https://www.googleapis.com/books/v1/volumes?q=${978-1-118-55421-0}&maxResults=39&startIndex=0
  Future<bool> checkISBN(String isbn) async {
    try{
      var url = 'https://www.googleapis.com/books/v1/volumes?q=ISBN%${isbn}&maxResults=5&startIndex=0';
      print("searching url: $url");
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print("body test: ${response.body[response.body.length-4]} and test statement: ${int.parse(response.body[response.body.length-4]) > 0}");
      if(response.statusCode == 200 && int.parse(response.body[response.body.length-4]) > 0){
        return true;
      }
      return false;
    } catch (e){
      print("Exception caught: $e");
     return false;
    }
  }


}