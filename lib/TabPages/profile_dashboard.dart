import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Services/auth.dart';
import 'package:bookversity/Services/firestore_service.dart';
import 'package:bookversity/Services/state_storage.dart';
import 'package:bookversity/Widgets/shapes.dart';
import 'package:flutter/material.dart';

class ProfileDashBoard extends StatefulWidget {
  @override
  _ProfileDashBoardState createState() => _ProfileDashBoardState();
}

class _ProfileDashBoardState extends State<ProfileDashBoard> {
  bool _showAdBox = false;

  AuthService _authService = AuthService();
  FireStoreService _fireStoreService = FireStoreService();
  final StateStorageService _storageService = StateStorageService();
  String profilePictureLink;
  CustomShapes _shapes = CustomShapes();



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 120,
          ),
          Flexible(
            flex: 2,
            child: topDashBoardWidgets(),
          ),
          SizedBox(
            height: 32,
          ),
          Flexible(
            flex: 3,
            child: centerDashBoardWidget(),
          )
        ],
      ),
    );
  }

  Widget topDashBoardWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        dashBoardBox(
            180,
            140,
            customBoxShape(Colors.green, Colors.lightGreenAccent),
            "Mine\noplysninger",
            20,
            Icons.person_outline),
        SizedBox(
          width: 25,
        ),
        dashBoardBox(200, 200, customBoxShape(Colors.red, Colors.orange),
            "Ny annonce", 21, Icons.attach_money),
      ],
    );
  }

  Widget centerDashBoardWidget() {
    // h140, w360, customBoxShape(Colors.purple, Colors.purpleaccent)
    return Column(
      children: [
        dashBoardBox(
        140,
        360,
        customBoxShape(Colors.purple, Colors.purpleAccent),
        "Mine annoncer",
        22,
        Icons.book),
        SizedBox(height: 30,),
        logoutButton()
      ],
    );
  }

  customBoxShape(Color color1, Color color2) {
    return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [color1, color2],
        ),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(8)));
  }

  Widget dashBoardBox(double _height, double _width, dynamic shape,
      String tileText, double fontSize, IconData icon) {
    return Container(
      height: _height,
      width: _width,
      decoration: shape,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tileText,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Icon(
            icon,
            size: 60,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget logoutButton(){
    return RaisedButton(
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
            color: CustomColors.materialDarkGreen),));
  }
}
