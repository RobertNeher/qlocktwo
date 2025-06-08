import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class LanguageStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/assets/settings/language.json');
  }

  Future<String> readLanguage() async {
    try {
      final file = await _localFile;

      final languageJson = await file.readAsString();

      return "en";
      //json.decode(languageJson)['language'];
    } catch (e) {
      return '';
    }
  }

  Future<File> writeLanguage(String language) async {
    final file = await _localFile;

    Map<String, dynamic> languageJson = {"language": language};

    return file.writeAsString(json.encode(languageJson));
  }
}
