import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  Map<String, dynamic> settings =
      json.decode(
        File('assets/settings/settings.json').readAsStringSync(),
      )['settings'];
  print(settings);
  Map<String, dynamic> language = json.decode(
    File('assets/settings/${settings['language']}.json').readAsStringSync(),
  );
  print(language['qlockTwoChars']);
  print(language['fiveMinutesMapping'][(5 / 5).round()]);
}
