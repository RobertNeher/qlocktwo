import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qlocktwo/src/helper.dart';

class ClockFace extends StatefulWidget {
  final Map<String, dynamic> settings;
  final Map<String, dynamic> languageSettings;

  const ClockFace({
    super.key,
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

  @override
  void initState() {
    super.initState();

    activeStyle = TextStyle(
      fontFamily: widget.settings['font'],
      fontSize: widget.settings['fontSize'].toDouble(),
      fontWeight: FontWeight.bold,
      color: colorFromString(widget.settings['charColorActive']),
      // shadows: <Shadow>[
      //   Shadow(
      //     offset: Offset(10.0, 10.0),
      //     blurRadius: 3.0,
      //     color: colorFromString(widget.settings['charShadowColorActive']),
      //   ),
      // ],
    );
    inActiveStyle = TextStyle(
      fontFamily: widget.settings['font'],
      fontSize: widget.settings['fontSize'].toDouble(),
      fontWeight: FontWeight.w200,
      color: colorFromString(widget.settings['charColorInActive']),
      shadows: <Shadow>[
        Shadow(
          offset: Offset(3.0, 3.0),
          blurRadius: 2.0,
          color: colorFromString(widget.settings['charShadowColorInActive']),
        ),
        Shadow(
          offset: Offset(-3.0, -3.0),
          blurRadius: 2.0,
          color: colorFromString(widget.settings['charShadowColorActive']),
        ),
      ],
    );

    hour = DateTime.now().hour % 12 + 1;
    minute = roundMinute(5);
    // hour = 6;
    // minute = 0;
    Timer _ = Timer.periodic(const Duration(seconds: 300), (timer) {
      setState(() {
        hour = DateTime.now().hour % 12;
        minute = roundMinute(5);

        if (hour != 0 && minute >= 30) {
          hour += 1;
        }
        // else {
        //   hour -= 1;
        // }

        if (hour == 0) {
          hour = 12;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    tileList = <Widget>[];
    minuteMaskRow = '';
    minuteMask =
        widget.languageSettings['fiveMinutesMapping'][(minute / 5)
            .round()][minute.toString()];
    hourMask = widget.languageSettings['hoursMapping'][hour][hour.toString()];

    for (
      int row = 0;
      row < widget.languageSettings['qlockTwoChars'].length;
      row++
    ) {
      minuteMaskRow = widget.languageSettings['qlockTwoChars'][row];

      for (int col = 0; col < minuteMaskRow.length; col++) {
        if (minuteMask[row][col] == "1" || (hourMask[row][col] == "1")) {
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
