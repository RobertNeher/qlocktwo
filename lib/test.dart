import 'dart:convert';
import 'dart:io';


void main(List<String> args) async {
  Map<String, dynamic> settings =
      json.decode(
        File('assets/settings/settings.json').readAsStringSync(),
      )['settings'];
  Map<String, dynamic> language = json.decode(
    File('assets/settings/${args[0]}.json').readAsStringSync(),
  );

  int hour = int.parse(args[1].split(':')[0]);
  int minute = int.parse(args[1].split(':')[1]);

  if (hour != 0 && minute >= 30) {
    hour += 1;
  }
  if (hour == 0) {
    hour = 12;
  }
  if (hour > 0 && minute < 30) {
  }


  print('$hour:$minute');
}
