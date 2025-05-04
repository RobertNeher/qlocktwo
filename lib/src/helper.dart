import 'dart:math';
import 'package:flutter/material.dart';

// colorString is expected in following format:
// '#<red in hex><green in hex><blue in hex>', eg. '#262626'
Color colorFromString(String colorString) {
  String color = '0xff${colorString.substring(1)}';
  return Color(int.parse(color));
}

Color complimentaryColor(Color color) {
  return Color.fromARGB(
    255 - color.alpha,
    255 - color.red,
    255 - color.blue,
    255 - color.green,
  );
}

Color randomColor() {
  return Color.fromARGB(
    255,
    Random().nextInt(256),
    Random().nextInt(256),
    Random().nextInt(256),
  );
}

int roundMinute(int denominator) {
  int minute = DateTime.now().minute;
  int roundedTime = (minute / denominator).round();
  roundedTime *= denominator;
  return roundedTime;
}
