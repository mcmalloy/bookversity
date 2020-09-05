import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Services/auth.dart';
import 'package:bookversity/Widgets/shapes.dart';
import 'package:flutter/material.dart';

class CustomDialogs {
  AuthService _authService = AuthService();
  TextEditingController _email = TextEditingController();
  CustomColors _colors = new CustomColors();
  CustomShapes _shapes = new CustomShapes();

  Widget resetPasswordDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Reset Password"),
      shape: _shapes.customBoxShape1(),
      content: Container(
        height: 200,
        width: 200,
        child: Column(
          children: [
            Text("Enter email address to reset your password"),
            resetPasswordDialogBody(),
            resetPasswordButton(context)
          ],
        ),
      ),
      actions: [],
    );
  }

  Widget resetPasswordDialogBody() {
    return Padding(
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
        ));
  }

  Widget resetPasswordButton(BuildContext context) {
    AuthService service = AuthService();
    return RaisedButton(
      shape: _shapes.customButtonShape(),
      color: CustomColors.materialYellow,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () async {
        print("Sending to forgotPassword with email: ${_email.text}");
        await service.forgotPassword(_email.text);
        Navigator.pop(context);
      },
      child: Text("Resend password",
          style: TextStyle(
              color: CustomColors.materialDarkGreen,
              fontSize: 16,
              fontFamily: "WorkSansSemiBold")),
    );
  }
}
