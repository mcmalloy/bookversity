import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Services/auth.dart';
import 'package:bookversity/Widgets/shapes.dart';
import 'package:flutter/material.dart';

class CustomDialogs {
AuthService _authService;
TextEditingController _email = TextEditingController();
CustomColors _colors = new CustomColors();
CustomShapes _shapes = new CustomShapes();

  Widget resetPasswordDialog(BuildContext context){
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Reset Password"),
            content: Container(
              height: 150,
              width: 175,
              child: Column(
                children: [
                  Text("Enter email address to reset your password"),
                  Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: TextFormField(
                        controller: _email,
                        style: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 16.0,
                            color: Colors.black),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.email,
                            color: Colors.black,
                            size: 22.0,
                          ),
                          hintText: "Email Address",
                          hintStyle:
                          TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                        ),
                        obscureText: false,
                      )
                  ),
                  RaisedButton(
                    shape: _shapes.customButtonShape(),
                    color: CustomColors.materialYellow,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () async {
                      _authService.forgotPassword(_email.text);
                      Navigator.pop(context);
                    },
                    child: Text("Resend password",
                        style: TextStyle(
                            color: CustomColors.materialDarkGreen,
                            fontSize: 16,
                            fontFamily: "WorkSansSemiBold")),
                  )
                ],
              ),
            ),
            actions: [

            ],
          );
        }
    );
}
}
