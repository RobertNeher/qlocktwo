import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlocktwo/src/helper.dart';
import 'package:qlocktwo/src/qlocktwo_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() =>
    runApp(MaterialApp(home: QlockTwo(), debugShowCheckedModeBanner: false));

class QlockTwo extends StatefulWidget {
  QlockTwo({super.key});
  late SharedPreferences prefs;
  late String language;
  final String appBarTitle = 'QlockTwo powered by Flutter';
  @override
  State<QlockTwo> createState() => _QlockTwoState();
}

class _QlockTwoState extends State<QlockTwo>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Map<String, dynamic> settings = {};
  Map<String, dynamic> languageSet = {};

  @override
  void initState() {
    _loadSettings();

    super.initState();
  }

  Future<void> _loadSettings() async {
    widget.prefs = await SharedPreferences.getInstance();
    widget.language = widget.prefs.getString('language') ?? 'de';

    String jsonData = await rootBundle.loadString(
      'settings/settings.json',
    );
    settings = json.decode(jsonData)['settings'];

    if (widget.language.length >= 2) {
      jsonData = await rootBundle.loadString(
        'settings/${widget.language}.json',
      );
      languageSet = json.decode(jsonData);
    }
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      await widget.prefs.setString('language', widget.language);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
