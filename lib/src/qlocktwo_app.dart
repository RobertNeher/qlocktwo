import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:qlocktwo/src/background.dart';
import 'package:qlocktwo/src/clock_face.dart';

class QlockTwoApp extends StatefulWidget {
  Map<String, dynamic> settings = {};
  final Map<String, dynamic> languageSettings;

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

  @override
  void initState() {
    qlockTwoActiveStyle = TextStyle();
    timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      setState(() {});
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
          settings: widget.settings,
          languageSettings: widget.languageSettings,
        ),
      ],
    );
  }
}
