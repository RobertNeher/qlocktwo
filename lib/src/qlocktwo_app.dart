import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    qlockTwoActiveStyle = TextStyle(
      color: colorFromString(widget.settings['backgroundColor'][0]),
      fontSize: widget.settings['charSize'].toDouble(),
    );
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
    Alignment colorAlignment;
    String orientation =
        widget.settings['backgroundColorOrientation'].toUpperCase();
    if (orientation == "BL") {
      colorAlignment = Alignment.bottomLeft;
    }
    if (orientation == "BC") {
      colorAlignment = Alignment.bottomCenter;
    }
    if (orientation == "BR") {
      colorAlignment = Alignment.bottomRight;
    }
    if (orientation == "CENTER") {
      colorAlignment = Alignment.center;
    }
    if (orientation == "TL") {
      colorAlignment = Alignment.topLeft;
    }
    if (orientation == "TC") {
      colorAlignment = Alignment.bottomRight;
    }
    if (orientation == "TR") {
      colorAlignment = Alignment.topCenter;
    } else {
      colorAlignment = Alignment.topLeft;
    }

    List<Color> colorList = [];
    for (String colorString in widget.settings['backgroundColor']) {
      colorList.add(colorFromString(colorString));
    }

    double windowSize = widget.settings['clockSize'].toDouble();

    if (MediaQuery.of(context).size.width >
        MediaQuery.of(context).size.height) {
      windowSize = MediaQuery.of(context).size.height;
    } else {
      windowSize = MediaQuery.of(context).size.width;
    }
    if (windowSize < widget.settings['clockSize'].toDouble()) {
      windowSize = widget.settings['clockSize'].toDouble();
    }
    print(windowSize);
    return Container(
      height: windowSize,
      width: windowSize,
      padding: EdgeInsets.all(70),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: colorAlignment,
          end: Alignment(0.8, 1),
          colors: colorList,
          tileMode: TileMode.clamp,
        ),
      ),
      child: ClockFace(settings: widget.settings),
    );
  }
}
