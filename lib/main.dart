import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlocktwo/src/helper.dart';
import 'package:qlocktwo/src/qlocktwo_app.dart';

void main() =>
    runApp(MaterialApp(home: QlockTwo(), debugShowCheckedModeBanner: false));

class QlockTwo extends StatefulWidget {
  const QlockTwo({super.key});
  final String appBarTitle = 'QlockTwo powered by Flutter';
  @override
  State<QlockTwo> createState() => _QlockTwoState();
}

class _QlockTwoState extends State<QlockTwo> with TickerProviderStateMixin {
  Map<String, dynamic> settings = {};
  Map<String, dynamic> languageSet = {};

  @override
  void initState() {
    _loadSettings();

    super.initState();
  }

  Future<void> _loadSettings() async {
    String jsonData = await rootBundle.loadString(
      'assets/settings/settings.json',
    );
    settings = json.decode(jsonData)['settings'];
  
    if (settings['language'].length() >= 2) {
      jsonData = await rootBundle.loadString(
        'assets/settings/${settings['language']}.json',
      );
      languageSet = json.decode(jsonData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
              strokeWidth: 5,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return DefaultTextStyle(
            style: TextStyle(
              fontFamily: settings['font'],
              fontSize: settings['fontSize'].toDouble(),
              fontWeight: FontWeight.w100,
              color: colorFromString(settings['charColorInActive']),
            ),
            child: Center(
              child: QlockTwoApp(
                settings: settings,
                languageSettings: languageSet,
              ),
            ),
          );
        } else {
          return const Text(
            'Something went wrong!',
            style: TextStyle(
              // fontFamily: 'Railway',
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.red,
            ),
          );
        }
      },
    );
  }
}
