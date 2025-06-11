import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qlocktwo/src/helper.dart';

class ClockFace extends StatefulWidget {
  final Map<String, dynamic> settings;
  final Map<String, dynamic> languageSettings;
  int hour;
  int minute;

  ClockFace({
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
  // int hour = 0;
  // int minute = 0;
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
      fontFamily: widget.settings['fontActive'],
      fontSize: widget.settings['fontSizeActive'].toDouble(),
      fontWeight: FontWeight.bold,
      color: colorFromString(widget.settings['charColorActive']),
    );
    inActiveStyle = TextStyle(
      fontFamily: widget.settings['fontInActive'],
      fontSize: widget.settings['fontSizeInActive'].toDouble(),
      fontWeight: FontWeight.w200,
      foreground:
          Paint()
            ..color = colorFromString(widget.settings['charColorInActive'])
            ..strokeWidth = 3
            ..strokeCap = StrokeCap.butt
            ..style = PaintingStyle.stroke,
    );

    widget.hour = DateTime.now().hour % 12;
    widget.minute = roundMinute(5);

    if (widget.hour != 0 && widget.minute >= 30) {
      widget.hour += 1;
    }

    if (widget.hour == 0) {
      widget.hour = 12;
    }

    if (widget.settings['debugMode'] ?? true) {
      timer = Timer.periodic(
        Duration(milliseconds: widget.settings['debugPeriod']),
        (timer) {
          setState(() {
            widget.minute += 5;
            if (widget.minute >= 60) {
              widget.minute = 0;
              widget.hour += 1;
              widget.hour %= 12;

              if (widget.hour != 0 && widget.minute >= 30) {
                widget.hour += 1;
              }

              if (widget.hour == 0) {
                widget.hour = 12;
              }
            }
          });
        },
      );
    } else {
      timer = Timer.periodic(const Duration(seconds: 5 * 60), (timer) {
        setState(() {
          widget.hour = DateTime.now().hour % 12;
          widget.minute = roundMinute(5);

          if (widget.hour != 0 && widget.minute >= 30) {
            widget.hour += 1;
          }

          if (widget.hour == 0) {
            widget.hour = 12;
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
        '${widget.hour.toString().padLeft(2, '0')}:${widget.minute.toString().padLeft(2, '0')}',
      );
    }
    tileList = <Widget>[];
    minuteMaskRow = '';
    minuteMask =
        widget.languageSettings['fiveMinutesMapping'][(widget.minute / 5)
            .round()][widget.minute.toString()];
    hourMask =
        widget.languageSettings['hoursMapping'][widget.hour][widget.hour
            .toString()];

    if (widget.settings['debugMode'] ?? true) {
      print(
        '${widget.hour.toString().padLeft(2, '0')}:${widget.minute.toString().padLeft(2, '0')}',
      );
    }

    for (
      int row = 0;
      row < widget.languageSettings['qlockTwoChars'].length;
      row++
    ) {
      if (widget.languageSettings['language'] == 'fr' &&
          [0, 12].contains(widget.hour) &&
          widget.minute == 0) {
        continue;
      }

      minuteMaskRow = widget.languageSettings['qlockTwoChars'][row];

      for (int col = 0; col < minuteMaskRow.length; col++) {
        if (minuteMask[row][col] == "1" || hourMask[row][col] == "1") {
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
