import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  int hour = int.parse(args[0].substring(0, 2)) % 12;

  if (hour == 0) {
    hour++;
  }
}
