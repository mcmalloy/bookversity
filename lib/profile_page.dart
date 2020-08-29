import 'package:bookversity/Constants/profile_clipper.dart';
import 'package:bookversity/Services/auth.dart';
import 'package:flutter/material.dart';

import 'Constants/custom_colors.dart';

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
          child: Container(
            color: CustomColors.materialYellow,
            child: RaisedButton(
              color: CustomColors.materialDarkGreen,
              onPressed: () async {
                _authService.facebookLogout();
              },
            ),
          ),
        ),
        Flexible(
            flex: 1,
            child: Container(
              color: CustomColors.materialLightGreen,
            )),
        Flexible(
            flex: 2,
            child: Container(
              color: CustomColors.materialDarkGreen,
            ))
      ],
    );
  }
}
