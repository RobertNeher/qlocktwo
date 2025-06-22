import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:qlocktwo/src/background.dart';
import 'package:qlocktwo/src/clock_face.dart';
import 'package:qlocktwo/src/helper.dart';

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

class _QlockTwoAppState extends State<QlockTwoApp> with WidgetsBindingObserver {
  double height = 0;
  double width = 0;
  TextStyle? qlockTwoActiveStyle;
  Timer? timer;
  DateFormat timeFormat = DateFormat('HH:mm');
  int hour = DateTime.now().hour;
  int minute = roundMinute(5);

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    qlockTwoActiveStyle = TextStyle();

    if (widget.settings['debugMode']) {
      hour = 0;
      minute = 0;

      if (widget.settings['debugPeriod'] == 0) {
        timer = Timer.periodic(const Duration(seconds: 5 * 60), (timer) {
          setState(() {
            hour = DateTime.now().hour % 12;
            minute = roundMinute(5);

            if (hour != 0 && minute >= 30) {
              hour += 1;
            }
            if (hour == 0) {
              hour = 12;
            }
          });
        });
      } else if (widget.settings['debugPeriod'] > 0) {
        timer = Timer.periodic(
          Duration(milliseconds: widget.settings['debugPeriod']),
          (timer) {
            setState(() {
              minute += 5;
              if (minute >= 60) {
                minute = 0;
                hour += 1;
                hour %= 12;

                if (hour != 0 && minute >= 30) {
                  hour += 1;
                }

                if (hour == 0) {
                  hour = 12;
                }
              }
            });
          },
        );
      } else {
        timer = Timer.periodic(const Duration(seconds: 5 * 60), (timer) {
          setState(() {
            hour = DateTime.now().hour % 12;
            minute = roundMinute(5);

            if (hour != 0 && minute >= 30) {
              hour += 1;
            }
            if (hour == 0) {
              hour = 12;
            }
          });
        });
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    setState(() {
      // width = View.of(context).physicalSize.width;
      // height = View.of(context).physicalSize.height;
      width = widget.settings['clockSize']?.toDouble() ?? 300;
      height = widget.settings['clockSize']?.toDouble() ?? 300;
    });
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
