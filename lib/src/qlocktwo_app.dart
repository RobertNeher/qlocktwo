import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:qlocktwo/src/background.dart';
import 'package:qlocktwo/src/clock_face.dart';
import 'package:qlocktwo/src/helper.dart';
import 'package:qlocktwo/src/select_language._dart';

class QlockTwoApp extends StatefulWidget {
  Map<String, dynamic> settings = {};
  Map<String, dynamic> languageSettings = {};

  QlockTwoApp({
    super.key,
    required this.settings,
    required this.languageSettings,
  });

  @override
  State<QlockTwoApp> createState() => _QlockTwoAppState();
}

class _QlockTwoAppState extends State<QlockTwoApp> {
  TextStyle? qlockTwoActiveStyle;
  Timer? timer;
  DateFormat timeFormat = DateFormat('HH:mm');
  int hour = DateTime.now().hour;
  int minute = roundMinute(5);

  @override
  void initState() {
    qlockTwoActiveStyle = TextStyle();
    timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      setState(() {
        hour = DateTime.now().hour;
        minute = roundMinute(5);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Background(settings: widget.settings),
        ClockFace(
          hour: hour,
          minute: minute,
          settings: widget.settings,
          languageSettings: widget.languageSettings,
        ),
      ],
    );
  }
}
