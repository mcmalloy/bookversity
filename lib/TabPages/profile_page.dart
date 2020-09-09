import 'package:bookversity/Constants/loginType.dart';
import 'package:bookversity/Pages/create_ad_page.dart';
import 'package:bookversity/Services/auth.dart';
import 'package:bookversity/Services/firestore_service.dart';
import 'package:bookversity/Services/state_storage.dart';
import 'package:bookversity/Widgets/shapes.dart';
import 'package:flutter/material.dart';
import '../Constants/custom_colors.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _showAdBox = false;

  AuthService _authService = AuthService();
  FireStoreService _fireStoreService = FireStoreService();
  final StateStorageService _storageService = StateStorageService();
  String profilePictureLink;
  CustomShapes _shapes = CustomShapes();
  LoginType _type;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getSignInType();
    getProfileID();
  }

  void getSignInType() {
    setState(() {
      _type = _authService.getSignInType();
    });
  }

  Future<void> getProfileID() async {
    String _profilePictureLink = await _storageService.getFacebookUID();
    setState(() {
      profilePictureLink = _profilePictureLink;
      print("profile link acquired!");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        leading: new Icon(
          Icons.arrow_back,
          size: 30,
          color: CustomColors.materialLightGreen,
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            child: determineTopLayout(),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 4,
            child: bookDashBoard(),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2,
            child: RaisedButton(
              shape: _shapes.customBoxShape1(),
              color: CustomColors.materialLightGreen,
              child: Text(
                "Opret annonce",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  _showAdBox = true;
                });
                //Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAddPage()));
              },
            ),
          ),
          _showAdBox
              ? Container(color: Colors.grey.withOpacity(0.7))
              : Container(
                  height: 0,
                ),
          Container(
            child: createAdBox(),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 10,
            child: bottomSection(),
          )
        ],
      ),
    );
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: CustomColors.materialLightGreen,
    );
  }

  Widget bookDashBoard() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 30),
      width: MediaQuery.of(context).size.width - 30,
      decoration: ShapeDecoration(
          color: CustomColors.materialDarkGreen,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: Column(
        children: [
          Text(
            "Mine opslag",
            style: montSerratFont(),
          ),
          SizedBox(
            height: 25,
          ),
          _fireStoreService.hasBooksForSale()
              ? Container(
                  height: 1,
                ) // Show listview of books
              : Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Du har på nuværende tidspunkt ingen bøger til salg... Tryk på 'Sælg Bog' for at uploade",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Montserrat",
                        color: Colors.white),
                  ),
                )
          //ListView()
        ],
      ),
    );
  }

  montSerratFont() {
    return TextStyle(
        color: Colors.white, fontFamily: "Montserrat", fontSize: 20);
  }

  Widget bottomSection() {
    return Container(
        height: 50,
        width: 200,
        padding: EdgeInsets.only(top: 15),
        child: _showAdBox
            ? Container(
                height: 1,
              )
            : RaisedButton(
                shape: _shapes.customButtonShape(),
                color: CustomColors.materialYellow,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () async {
                  bool loggedOutSuccessfully =
                      await _authService.fireBaseLogOut();
                  if (loggedOutSuccessfully) {
                    // TODO: LOG USER IN
                    Navigator.pop(context);
                  } else {
                    // TODO: Display facebook login error
                  }
                },
                child: Text(
                  "Logout",
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Montserrat",
                      color: CustomColors.materialDarkGreen),
                ),
              ));
  }

  Widget logoutButton() {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: new Icon(
          Icons.exit_to_app,
          color: Color(0xFF0084ff),
        ),
      ),
      onTap: () async {
        bool loggedOutSuccessfully = await _authService.fireBaseLogOut();
        if (loggedOutSuccessfully) {
          // TODO: LOG USER IN
          Navigator.pop(context);
        } else {
          // TODO: Display facebook login error
        }
      },
    );
  }

  Widget determineTopLayout() {
    if (_type == LoginType.facebookSignIn) {
      return Column(children: <Widget>[
        Container(
            color: CustomColors.materialLightGreen,
            child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  profilePictureLink == null
                      ? CircularProgressIndicator()
                      : CircleAvatar(
                          backgroundImage: NetworkImage(
                              "http://graph.facebook.com/$profilePictureLink/picture?type=large"),
                          radius: 50.0,
                        ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  )
                ])))
      ]);
    } else if (_type == LoginType.googleSignIn) {
      return Container();
    } else if (_type == LoginType.emailSignIn) {
      return Container();
    }
  }

  Widget createAdBox() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 600),
      top: _showAdBox ? 30 : -MediaQuery.of(context).size.height,
      left: 50,
      right: 50,
      bottom: _showAdBox ? 20 : MediaQuery.of(context).size.height,
      curve: Curves.easeInOutCubic,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.only(top: 18, left: 25),
                  iconSize: 34,
                  icon: Icon(Icons.keyboard_return),
                  onPressed: () {
                    setState(() {
                      _showAdBox = !_showAdBox;
                    });
                  },
                )
              ],
            ),
            bookForm()
            //TODO: Form goes in here
          ],
        ),
      ),
    );
  }

  Widget bookForm() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
          child: formObject("book", Icons.book, "Bogtitel"),
        ),
        Container(height: 1, color: Colors.grey[400]),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
          child: formObject("isbn", Icons.library_books, "ISBN Kode"),
        ),
        Container(height: 1, color: Colors.grey[400]),
        Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
            child: formObject("price", Icons.attach_money, "Pris")),
        Container(height: 1, color: Colors.grey[400]),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                Icons.camera_enhance,
                color: Colors.black,
                size: 22.0,
              ),
              hintText: "Tag billede",
              hintStyle: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 22.0,
                  color: CustomColors.materialDarkGreen),
            ),
            onTap: () {
              //TODO: Open camera view
            },
          ),
        )
      ],
    );
  }

  Widget formObject(String type, IconData formIcon, String hintText) {
    return Container(
      padding: EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.withOpacity(0.5)),
        child: TextFormField(
          controller: determineController(type),
          style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 16.0,
              color: CustomColors.materialDarkGreen),
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(
              formIcon,
              color: Colors.black,
              size: 22.0,
            ),
            hintText: "$hintText",
            hintStyle: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 22.0,
                color: CustomColors.materialDarkGreen),
          ),
          onChanged: (controller) {
            print("Changed ${controller.toString()}");
          },
        ));
  }

  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  TextEditingController determineController(String type) {
    if (type == "book") {
      return _bookNameController;
    } else if (type == "isbn") {
      return _isbnController;
    } else {
      return _priceController;
    }
  }
}
