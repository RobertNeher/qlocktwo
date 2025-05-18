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

  String hourMask = '';

  print('${args[0]} ${(language['qlockTwoChars']).length}');

  for (int hour = 0; hour < 13; hour += 1) {
    print(
      'Hour $hour: ${(language['hoursMapping'][hour][hour.toString()]).length}',
    );
  }
}
