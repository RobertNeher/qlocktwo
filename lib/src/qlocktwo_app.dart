import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qlocktwo/src/background.dart';
import 'package:qlocktwo/src/clock_face.dart';
import 'package:qlocktwo/src/helper.dart';

class QlockTwoApp extends StatefulWidget {
  Map<String, dynamic> settings = {};
  String hour = '';
  String minute = '';

  QlockTwoApp({super.key, required this.settings});

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
      setState(() {
        String time = '';
        time = timeFormat.format(DateTime.now());
        widget.hour = time.substring(0, 2);
        widget.minute = time.substring(3, 5);
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
        ClockFace(settings: widget.settings),
      ],
    );
  }
}
