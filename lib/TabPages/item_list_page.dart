
import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    //getBooks();
    return Scaffold(
      backgroundColor: CustomColors.materialLightGreen,
      body: SafeArea(
        child: Column(
          children: [
            f()
          ],
        ),
      ),
    );
  }

  Widget getBookList(){
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container();
        }
        return ListView.builder(
          itemCount: projectSnap.data.length,
          itemBuilder: (context, index) {
            List<Book> bookList = projectSnap.data[index];
            return Column(
              children: <Widget>[
              ],
            );
          },
        );
      },
      future: getBooks(),
    );
  }
  Future<void> getBooks() async {
    Query query = FirebaseFirestore.instance.collectionGroup("booksForSale");
    WriteBatch batch = FirebaseFirestore.instance.batch();
    await query.get().then((querySnapshot) async{
      print(querySnapshot.toString());
    });

    return null;
  }

  Widget f(){
    // XVFovlmshXhsxUpo06yGs2MkHJV2

   CollectionReference books = FirebaseFirestore.instance.collection(" ");
    return FutureBuilder<DocumentSnapshot>(
      future: books.doc().get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          print("Loaded data: ${data.toString()}");
          return Text("Full Name: ");
        }

        return Text("loading");
      },
    );
  }

}
