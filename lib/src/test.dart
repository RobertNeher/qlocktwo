import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  String jsonData = await File('assets/settings/settings.json').readAsString();
  Map<String, dynamic> settings = json.decode(jsonData)['settings'];
  int minute = roundTime(args[1], 5);
  List mask =
      settings['fiveMinutesMapping'][(minute / 5).round()][minute.toString()];
  print(mask[0]);
}

int roundTime(String timeString, int denominator) {
  int minute = int.parse(timeString);
  int roundedTime = (minute / denominator).round();
  roundedTime *= denominator;
  return roundedTime;
}
