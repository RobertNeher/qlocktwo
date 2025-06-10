import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlocktwo/src/qlocktwo_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  int hour = 0;
  int minute = 0;

  @override
  void initState() {
    _loadSettings();

    super.initState();
  }

  Future<void> _loadSettings() async {
    String pathPrefix = '';
    if (kIsWeb) {
      pathPrefix = '';
    } else {
      pathPrefix = 'assets/';
    }
    widget.prefs = await SharedPreferences.getInstance();
    widget.language = widget.prefs.getString('language') ?? 'de';

    String jsonData = await rootBundle.loadString(
      '${pathPrefix}settings/settings.json',
    );
    settings = json.decode(jsonData)['settings'];

    if (widget.language.length >= 2) {
      jsonData = await rootBundle.loadString(
        '${pathPrefix}settings/${widget.language}.json',
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

  void _handleClick(int item) {
    switch (item) {
      case 0: // German
        widget.prefs.setString('language', 'de');
        widget.language = 'de';
        break;
      case 1: // English
        widget.prefs.setString('language', 'en');
        widget.language = 'en';
        break;
      case 2: // French
        widget.prefs.setString('language', 'fr');
        widget.language = 'fr';
        break;
    }
    setState(() {});
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
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.appBarTitle),
              backgroundColor: Colors.transparent,
              centerTitle: true,
              automaticallyImplyLeading: true,
              bottomOpacity: 0.5,
              toolbarHeight: 60,
              actions: <Widget>[
                PopupMenuButton<int>(
                  padding: const EdgeInsets.all(20),
                  constraints: const BoxConstraints(
                    minWidth: 50,
                    maxWidth: 105,
                  ),
                  elevation: 20,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  onSelected: (item) => _handleClick(item),
                  itemBuilder:
                      (BuildContext context) => [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset('assets/icons/de.png', height: 15),
                              SizedBox(width: 10),
                              Text('German'),
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset('assets/icons/en.png', height: 15),
                              SizedBox(width: 10),
                              Text('English'),
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset('assets/icons/fr.png', height: 15),
                              SizedBox(width: 10),
                              Text('French'),
                            ],
                          ),
                        ),
                      ],
                ),
              ],
            ),
            body: QlockTwoApp(
              settings: settings,
              languageSettings: languageSet,
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
