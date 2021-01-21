import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Pages/tab_pages.dart';
import 'file:///C:/Users/Mark/StudioProjects/bookversity/lib/Pages/Chats/chat_list_page.dart';
import 'file:///C:/Users/Mark/StudioProjects/bookversity/lib/Pages/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


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

        ),
      routes: {
          '/chatListPage' : (BuildContext context) => new TabPages(selectedIndex: 2,)
      },
    );
  }
}
