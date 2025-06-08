import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  Map<String, dynamic> language = json.decode(
    File('assets/settings/${args[0]}.json').readAsStringSync(),
  );

  print('${args[0]} ${(language['qlockTwoChars']).length}');

  for (int hour = 0; hour < 13; hour += 1) {
    print(
      'Hour $hour: ${(language['hoursMapping'][hour][hour.toString()]).length}',
    );
  }
  for (int minute = 0; minute < 60; minute += 5) {
    print(
      'Minute $minute: ${(language['fiveMinutesMapping'][(minute / 5).round()][minute.toString()]).length}',
    );
  }
}
