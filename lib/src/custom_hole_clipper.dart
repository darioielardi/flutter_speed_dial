import 'package:flutter/material.dart';

class InvertedClipper extends CustomClipper<Path> {
  var height;
  var width;
  var dx;
  var dy;

  InvertedClipper({this.width, this.height, this.dy, this.dx});

  @override
  Path getClip(Size size) {
    return Path()
  ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
  ..addRRect(RRect.fromRectAndRadius(
  Rect.fromLTWH(dx, dy, width, height),
              Radius.circular(40)))
  ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}