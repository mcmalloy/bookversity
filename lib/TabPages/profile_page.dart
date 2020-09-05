import 'package:bookversity/Constants/loginType.dart';
import 'package:bookversity/Services/auth.dart';
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
      backgroundColor: CustomColors.materialLightGreen,
      body: Column(
        children: [
          Flexible(
              flex: 4,
              child: Container(
                child: determineTopLayout(),
              )),
          Flexible(
              flex: 2,
              child: Container(
                child: middleSection(),
              )),
          Flexible(
              flex: 3,
              child: Container(
                child: bottomSection(),
              ))
        ],
      ),
    );
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: CustomColors.materialLightGreen,
    );
  }

  Widget middleSection() {
    return Row();
  }

  Widget bottomSection() {
    return Container(
      padding: EdgeInsets.only(top: 200),
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
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      CustomColors.materialDarkGreen,
                      CustomColors.materialDarkGreen
                    ])),
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
                        height: 10.0,
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
