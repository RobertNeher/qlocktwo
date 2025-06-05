import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qlocktwo/src/helper.dart';

class ClockFace extends StatefulWidget {
  final Map<String, dynamic> settings;
  final Map<String, dynamic> languageSettings;
  final int hour;
  final int minute;

  const ClockFace({
    super.key,
    required this.hour,
    required this.minute,
    required this.settings,
    required this.languageSettings,
  });

  @override
  State<ClockFace> createState() => _ClockFaceState();
}

class _ClockFaceState extends State<ClockFace> {
  int hour = 0;
  int minute = 0;
  String time = '';
  TextStyle? activeStyle;
  TextStyle? inActiveStyle;
  List<Widget> tileList = [];
  DateFormat timeFormat = DateFormat('HH');
  String minuteMaskRow = '';
  List minuteMask = [];
  List hourMask = [];
  late Timer timer;

  @override
  void initState() {
    super.initState();

    activeStyle = TextStyle(
      fontFamily: widget.settings['font'],
      fontSize: widget.settings['fontSize'].toDouble(),
      fontWeight: FontWeight.bold,
      color: colorFromString(widget.settings['charColorActive']),
    );
    inActiveStyle = TextStyle(
      fontFamily: widget.settings['font'],
      fontSize: widget.settings['fontSize'].toDouble(),
      fontWeight: FontWeight.w200,
      foreground:
          Paint()
            ..color = colorFromString(widget.settings['charColorInActive'])
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
      shadows: <Shadow>[
        Shadow(
          offset: Offset(2.0, 2.0),
          blurRadius: 1.0,
          color: colorFromString(widget.settings['charShadowColorInActive']),
        ),
      ],
    );

    hour = DateTime.now().hour % 12;
    minute = roundMinute(5);

    if (hour != 0 && minute >= 30) {
      hour += 1;
    }

    if (hour == 0) {
      hour = 12;
    }

    if (widget.settings['debugMode'] ?? true) {
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

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.settings['debugMode'] ?? true) {
      print(
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
      );
    }
    tileList = <Widget>[];
    minuteMaskRow = '';
    minuteMask =
        widget.languageSettings['fiveMinutesMapping'][(minute / 5)
            .round()][minute.toString()];
    hourMask = widget.languageSettings['hoursMapping'][hour][hour.toString()];

    if (widget.settings['debugMode'] ?? true) {
      print(
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
      );
    }

    for (
      int row = 0;
      row < widget.languageSettings['qlockTwoChars'].length;
      row++
    ) {
      minuteMaskRow = widget.languageSettings['qlockTwoChars'][row];

      for (int col = 0; col < minuteMaskRow.length; col++) {
        if (minuteMask[row][col] == "1" || (hourMask[row][col] == "1" ||
            )) {
          tileList.add(
            Container(
              alignment: Alignment.center,
              child: Text(minuteMaskRow[col], style: activeStyle),
            ),
          );
          continue;
        } else {
          tileList.add(
            Container(
              alignment: Alignment.center,
              child: Text(minuteMaskRow[col], style: inActiveStyle),
            ),
          );
        }
      }
    }

    return GridView.count(
      shrinkWrap: true,
      primary: true,
      crossAxisCount: widget.languageSettings['qlockTwoChars'][0].length,
      children: tileList,
    );
  }
}
