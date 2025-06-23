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
  // int minute = DateTime.now().minute;
  int minute = roundMinute(int.parse(args[2]), 5);
  // print(
  //   language['fiveMinutesMapping'][(minute / 5).round()][minute.toString()],
  // settings['fiveMinutesMapping'][(minute / 5).round()][minute.toString()],
  // );
  // ignore: unused_local_variable
  String midiMinuitMask = '';
  int hour = int.parse(args[1]);
  print(hour.round());
  // if (widget.languageSettings['language'] == 'fr'){
  if ((hour == 12 || hour == 0) && minute == 0) {
    midiMinuitMask = language['hoursMapping'][hour.round()][0];
  }
  // }
}

int roundMinute(int minute, int denominator) {
  // int minute = DateTime.now().minute;
  int roundedTime = (minute / denominator).round();
  roundedTime *= denominator;
  return roundedTime;
}
