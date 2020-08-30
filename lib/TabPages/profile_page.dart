import 'package:bookversity/Constants/profile_clipper.dart';
import 'package:bookversity/Services/auth.dart';
import 'package:bookversity/Services/state_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Constants/custom_colors.dart';
import '../Constants/custom_colors.dart';
import '../Constants/custom_colors.dart';
import '../Constants/custom_colors.dart';
import '../Constants/custom_colors.dart';
import '../Constants/custom_colors.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService _authService = AuthService();
  final StateStorageService _storageService = StateStorageService();
  String profilePictureLink;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getProfileID();
  }

  Future<void> getProfileID() async {
    profilePictureLink = await _storageService.getFacebookUID();
    print("profile link acquired!");
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
                child: topSection(),
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

  Widget topSection() {
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
                    ? Icon(Icons.person)
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
  }

  Widget middleSection() {
    return Row();
  }

  Widget bottomSection() {
    return Row();
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
        bool logoutResult = await _authService.facebookLogout();
        if (!logoutResult) {
          // TODO: LOG USER IN
          Navigator.pop(context);
        } else {
          // TODO: Display facebook login error
        }
      },
    );
  }
}
