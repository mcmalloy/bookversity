import 'package:flutter/material.dart';

class CustomShapes {
  RoundedRectangleBorder customBoxShape1() {
    return RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(12)));
  }

  RoundedRectangleBorder customBoxShape2() {
    return RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(12),
            bottomLeft: Radius.circular(20)));
  }

  RoundedRectangleBorder customButtonShape(){
    return RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(38),
            topRight: Radius.circular(38),
            bottomRight: Radius.circular(40),
            bottomLeft: Radius.circular(40)));
  }

  RoundedRectangleBorder customListShape(){
    return RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
            bottomRight: Radius.circular(40),
            bottomLeft: Radius.circular(40)));
  }
}
