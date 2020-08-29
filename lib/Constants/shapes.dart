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
}
