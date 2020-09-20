
import 'package:flutter/material.dart';

class CustomTextStyle extends StatelessWidget {
  String text;
  double fontSize;
  Color color;
  CustomTextStyle(this.text, this.fontSize, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
        ),
    );
  }
}
