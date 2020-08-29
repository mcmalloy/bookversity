import 'package:bookversity/Constants/profile_clipper.dart';
import 'package:bookversity/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Constants/custom_colors.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 2,
          child: topSection()
        ),
        Flexible(
            flex: 1,
            child: middleSection()
        ),
        Flexible(
            flex: 2,
            child: bottomSection())
      ],
    );
  }

  Widget topSection(){
    print("TOPSECTION");
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(15.0),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: new Icon(
            FontAwesomeIcons.facebookF,
            color: Color(0xFF0084ff),
          ),
        )
      ],
    );
  }
  Widget middleSection(){
    return Row(

    );
  }
  Widget bottomSection(){
    return Row(

    );
  }
}
