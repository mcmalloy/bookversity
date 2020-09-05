import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
