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
        Flexible(flex: 1, child: Container(child: topSection(),color: CustomColors.materialLightGreen,)),
        Flexible(flex: 2, child:Container(child: middleSection(),color: CustomColors.materialYellow,)),
        Flexible(flex: 3, child: Container(child: bottomSection(),color: CustomColors.materialDarkGreen,))
      ],
    );
  }

  Widget topSection() {
    print("TOPSECTION");
    return Row(
      children: [
        Container(
            height: 20,
            width: 300
        ),
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: new Icon(
            Icons.exit_to_app,
            color: Color(0xFF0084ff),
          ),
        )
      ],
    );
  }

  Widget middleSection() {
    return Row();
  }

  Widget bottomSection() {
    return Row();
  }
}
