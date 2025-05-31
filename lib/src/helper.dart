import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

// colorString is expected in following format:
// '#<red in hex><green in hex><blue in hex>', eg. '#262626'
Color colorFromString(String colorString) {
  String color = '0xff${colorString.substring(1)}';
  return Color(int.parse(color));
}

Color complimentaryColor(Color color) {
  return Color.fromARGB(
    255 - color.a.round(),
    255 - color.r.round(),
    255 - color.b.round(),
    255 - color.g.round(),
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

String ampm(int hour, int minute) {
  String timeString = DateFormat.jm().format(
    DateFormat("hh:mm").parse('$hour:$minute'),
  );
  return timeString.substring(timeString.length - 2).toUpperCase();
}
