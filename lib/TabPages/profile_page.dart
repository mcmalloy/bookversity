import 'package:bookversity/Constants/loginType.dart';
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
      body: Column(
        children: [
          Container(
            child: determineTopLayout(),
          ),
          SizedBox(height: 30,),
          Container(
            height: 220,
            child: bookDashBoard(),
          ),
          SizedBox(height: 30,),
          RaisedButton(
            shape: _shapes.customBoxShape1(),
            color: CustomColors.materialLightGreen,
            child: Text("Opret annonce"),
            onPressed: (){

            },
          ),
          SizedBox(height: 90,),
          Container(
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
      padding: EdgeInsets.only(left: 15, right: 15),
      width: MediaQuery.of(context).size.width - 30,
      decoration: ShapeDecoration(
          color: CustomColors.materialDarkGreen,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: Column(
        children: [
          Text("Mine opslag", style: montSerratFont()),
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
                      "Du har på nuværende tidspunkt ingen bøger til salg... Tryk på 'Sælg Bog' for at uploade"),
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
        child: RaisedButton(
          shape: _shapes.customButtonShape(),
          color: CustomColors.materialYellow,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () async {
            bool loggedOutSuccessfully = await _authService.fireBaseLogOut();
            if (loggedOutSuccessfully) {
              // TODO: LOG USER IN
              Navigator.pop(context);
            } else {
              // TODO: Display facebook login error
            }
          },
          child: Text("Logout",
              style: TextStyle(
                  color: CustomColors.materialDarkGreen,
                  fontSize: 16,
                  fontFamily: "WorkSansSemiBold")),
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
}
