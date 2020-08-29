import 'package:flutter/widgets.dart';

class CustomColors{
  const CustomColors();

  static const Color loginGradientStart = const Color.fromRGBO(178,245,86,1);
  static const Color loginGradientEnd = const Color.fromRGBO(126,211,7,1);

  static const Color materialLightGreen = const Color.fromRGBO(119,168,75,1);
  static const Color materialDarkGreen = const Color.fromRGBO(104,159,56,1);
  static const Color materialYellow = const Color.fromRGBO(255,215,64,1);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}