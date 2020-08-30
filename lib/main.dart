import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: CustomColors.materialLightGreen,
        backgroundColor: CustomColors.materialLightGreen,
      ),
      home: SplashScreen.navigate(
        name: 'assets/BookAnimation3.flr',
        next: (_) => LoginPage(),
        isLoading: true,
        startAnimation: '1',
        loopAnimation: '1',
        endAnimation: '5',
        backgroundColor: CustomColors.materialLightGreen,

      )
    );
  }
}
/*
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MySplashScreen(),
    );
  }
}

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 5)).then((_) => setState(() {
          _isLoading = false;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen.navigate(
      name: 'assets/BookAnimation.flr',
      next: (context) => LoginPage(),
      startAnimation: '1',
      loopAnimation: '1',
      isLoading: _isLoading,
      endAnimation: '1',
      backgroundColor: CustomColors.materialLightGreen,
    );
  }
}
 */
