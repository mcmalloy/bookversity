import 'dart:math';

import 'package:flutter/material.dart';

class ButtonSwitcher extends CustomPainter {
  Paint painter;
  final double horizontalTarget;
  final double horizontalStart;
  final double radius;
  final double dy;

  final PageController pageController;
  // Size of white button area is horizontalTarget = (Width - 2 dxEntry) / 2
  // horizontalStart is the spacing on both sides of transparent container
  ButtonSwitcher(
      {this.horizontalTarget = 140.0,
        this.horizontalStart = 25.0,
        this.radius = 21.0,
        this.dy = 25.0, this.pageController}) : super(repaint: pageController) {
    painter = new Paint()
      ..color = Color(0xFFFFFFFF) // white
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {

    final position = pageController.position;
    double fullExtent = (position.maxScrollExtent - position.minScrollExtent + position.viewportDimension);

    double pageOffset = position.extentBefore / fullExtent;

    bool moveToSignUp = horizontalStart < horizontalTarget;
    Offset start = new Offset(moveToSignUp ? horizontalStart: horizontalTarget, dy);
    Offset target = new Offset(moveToSignUp ? horizontalTarget : horizontalStart, dy);

    // Using Rect math inspired by https://github.com/huextrat/TheGorgeousLogin/blob/master/lib/utils/bubble_indication_painter.dart
    Path path = new Path();
    path.addArc(
        new Rect.fromCircle(center: start, radius: radius), 0.5 * pi, 1 * pi);
    path.addRect(
        new Rect.fromLTRB(start.dx, dy - radius, target.dx, dy + radius));
    path.addArc(
        new Rect.fromCircle(center: target, radius: radius), 1.5 * pi, 1 * pi);

    canvas.translate(size.width * pageOffset, 0.0);
    // Shadow under button
    //canvas.drawShadow(path, Color(0xFFfbab66), 3.0, true);
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(ButtonSwitcher oldDelegate) => true;
}