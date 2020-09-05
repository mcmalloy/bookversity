import 'dart:math';

import 'package:bookversity/Constants/button_switch_color_animation.dart';
import 'package:bookversity/Constants/loginType.dart';
import 'package:bookversity/Services/auth.dart';
import 'package:bookversity/Services/state_storage.dart';
import 'package:bookversity/Widgets/dialogs.dart';
import 'package:bookversity/Widgets/shapes.dart';
import 'package:bookversity/tab_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:bookversity/Constants/custom_colors.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();

  PageController _pageController;

  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailSignUpController = TextEditingController();
  TextEditingController _passwordSignUpController = TextEditingController();

  Color existingButtonColor;
  Color signUpButtonColor;

  CustomShapes _shapes = new CustomShapes();
  CustomDialogs _dialogs = new CustomDialogs();
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget loginSelector() {
    return Container(
        width: 330,
        height: 50,
        decoration: BoxDecoration(
          color: Color(0x552B2B2B),
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        child: CustomPaint(
          painter: ButtonSwitcher(pageController: _pageController),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (_pageController.hasClients) {
                      _pageController.animateToPage(0,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut);
                    }
                  },
                  child: Text("Existing"),
                ),
              ),
              Expanded(
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (_pageController.hasClients) {
                      _pageController.animateToPage(1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut);
                    }
                  },
                  child: Text("Sign up"),
                ),
              )
            ],
          ),
        ));
  }

  void signInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 400), curve: Curves.decelerate);
  }

  void signUpButtonPress() {
    _pageController.animateToPage(1,
        duration: Duration(milliseconds: 400), curve: Curves.decelerate);
  }

  @override
  Widget build(BuildContext context) {
    LoginType loginType;
    return Scaffold(
      backgroundColor: CustomColors.materialLightGreen,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height >= 775.0
              ? MediaQuery.of(context).size.height
              : 775.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(top: 75.0),
                  child: new Image(
                    height: 200,
                    width: 150,
                    fit: BoxFit.fill,
                    image: new AssetImage('assets/bookversity_mascot_logo.png'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: loginSelector(),
              ),
              Expanded(
                flex: 3,
                child: PageView(
                  controller: _pageController,
                  children: [_signInPage(), _signUpPage()],
                  onPageChanged: (i) {
                    if (i == 0) {
                      setState(() {
                        existingButtonColor = Colors.white;
                        signUpButtonColor = Colors.black;
                      });
                    } else if (i == 1) {
                      setState(() {
                        existingButtonColor = Colors.black;
                        signUpButtonColor = Colors.white;
                      });
                    }
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 110),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [facebookIconButton(), googleIconButton()],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget forgotPasswordText() {
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: InkWell(
          child: Text(
            "Forgot password?",
            style: TextStyle(fontSize: 14, color: CustomColors.materialYellow),
          ),
          onTap: () {
            //_authService.forgotPassword();
            showDialog(
                context: context,
                builder: (_) => _dialogs.resetPasswordDialog(context),
                barrierDismissible: true);
          },
        ));
  }

  Widget facebookIconButton() {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(right: 20),
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: new Icon(
            FontAwesomeIcons.facebookF,
            color: CustomColors.materialDarkGreen,
          ),
        ),
      ),
      onTap: () async {
        User userResult = await _authService.facebookLogin();
        if (userResult != null) {
          // TODO: LOG USER IN
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TabPages()));
        } else {
          // TODO: Display facebook login error
        }
      },
    );
  }

  Widget googleIconButton() {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(left: 20),
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: new Icon(
            FontAwesomeIcons.google,
            color: CustomColors.materialDarkGreen,
          ),
        ),
      ),
      onTap: () async {
        User userResult = await _authService.googleLogin();
        print("userResult from google sign in: $userResult");
        if (userResult!=null) {
          // TODO: LOG USER IN
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TabPages()));
        }
      },
    );
  }

  Widget _signInPage() {
    return Container(
      padding: EdgeInsets.only(top: 25, left: 25, right: 25),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Card(
                  elevation: 2,
                  shape: _shapes.customBoxShape1(),
                  child: loginInputTextField()),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            height: 40,
            width: 250,
            child: RaisedButton(
              shape: _shapes.customButtonShape(),
              color: CustomColors.materialYellow,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () async {
                print("Attempting login with " +
                    _emailTextController.text +
                    " : " +
                    _passwordController.text);
                FirebaseUser user = await _authService.emailSignIn(
                    _emailTextController.text, _passwordController.text);
                if (user != null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TabPages()));
                } else {
                  //TODO: Catch incorrect login
                }
                //FirebaseUser anonUser = await _authService.anonSignIn();
                //FirebaseUser emailUser = await _authService.emailSignIn("markmalloy96@yahoo.dk", "Test1234");
              },
              child: Text("Login",
                  style: TextStyle(
                      color: CustomColors.materialDarkGreen,
                      fontSize: 16,
                      fontFamily: "WorkSansSemiBold")),
            ),
          ),
          forgotPasswordText()
        ],
      ),
    );
  }

  Widget _signUpPage() {
    return Container(
      padding: EdgeInsets.only(top: 25, left: 25, right: 25),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Card(
                  elevation: 2,
                  shape: _shapes.customBoxShape2(),
                  child: signUpTextField())
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            height: 40,
            width: 250,
            child: MaterialButton(
              shape: _shapes.customButtonShape(),
              color: CustomColors.materialYellow,
              splashColor: Colors.transparent,
              highlightColor: CustomColors.loginGradientEnd,
              onPressed: () async {
                _authService.createEmailUser(_emailSignUpController.text,
                    _passwordSignUpController.text);
                //TODO: Show alertdialog that confirms "An email was sent to you for confirmation
              },
              child: Text(
                "Sign up",
                style: TextStyle(
                    color: CustomColors.materialDarkGreen,
                    fontSize: 16,
                    fontFamily: "WorkSansSemiBold"),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget loginInputTextField() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
          child: TextFormField(
            controller: _emailTextController,
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
          ),
        ),
        Container(height: 1, color: Colors.grey[400]),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
          child: TextFormField(
            controller: _passwordController,
            style: TextStyle(
                fontFamily: "WorkSansSemiBold",
                fontSize: 16.0,
                color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                Icons.lock_outline,
                color: Colors.black,
                size: 22.0,
              ),
              hintText: "Password",
              hintStyle:
                  TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
            ),
            obscureText: true,
          ),
        )
      ],
    );
  }

  Widget signUpTextField() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
          child: TextFormField(
            controller: _emailSignUpController,
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
          ),
        ),
        Container(height: 1, color: Colors.grey[400]),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
          child: TextFormField(
            controller: _passwordSignUpController,
            style: TextStyle(
                fontFamily: "WorkSansSemiBold",
                fontSize: 16.0,
                color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                Icons.lock_outline,
                color: Colors.black,
                size: 22.0,
              ),
              hintText: "Password",
              hintStyle:
                  TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
            ),
            obscureText: true,
          ),
        )
      ],
    );
  }
}
