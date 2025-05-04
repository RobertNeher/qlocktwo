import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qlocktwo/src/helper.dart';

class ClockFace extends StatefulWidget {
  final Map<String, dynamic> settings;

  ClockFace({super.key, required this.settings}) {}

  @override
  State<ClockFace> createState() => _ClockFaceState();
}

class _ClockFaceState extends State<ClockFace> {
  int hour = 0;
  int minute = 0;
  String time = '';
  late TextStyle activeStyle;
  late TextStyle inActiveStyle;
  List<Widget> tileList = [];
  DateFormat timeFormat = DateFormat('HH:mm');

  @override
  void initState() {
    super.initState();

    time = timeFormat.format(DateTime.now());
    hour = int.parse(time.substring(0, 2));
    minute = roundMinute(5);

    Timer _ = Timer.periodic(const Duration(minutes: 5), (_) {
      setState(() {
        time = timeFormat.format(DateTime.now());
        hour = int.parse(time.substring(0, 2));
        minute = int.parse(time.substring(3, 5));
      });
    });

    TextStyle activeStyle = TextStyle(
      fontFamily: widget.settings['font'],
      fontSize: widget.settings['fontSize'],
      fontWeight: FontWeight.w100,
      color: colorFromString(widget.settings['charColorActive']),
      // shadows: <Shadow>[
      //   Shadow(
      //     offset: Offset(10.0, 10.0),
      //     blurRadius: 3.0,
      //     color: colorFromString(widget.settings['charShadowColorActive']),
      //   ),
      // ],
    );
    TextStyle inActiveStyle = TextStyle(
      fontFamily: widget.settings['font'],
      fontSize: widget.settings['fontSize'],
      fontWeight: FontWeight.w100,
      color: colorFromString(widget.settings['charColorInActive']),
      // shadows: <Shadow>[
      //   Shadow(
      //     offset: Offset(10.0, 10.0),
      //     blurRadius: 3.0,
      //     color: colorFromString(widget.settings['charShadowColorInActive']),
      //   ),
      // ],
    );

    String charRow = '';
    List mask =
        widget.settings['fiveMinutesMapping'][(minute / 5).round()][minute
            .toString()];

    for (int row = 0; row < widget.settings['qlockTwoChars'].length; row++) {
      charRow = widget.settings['qlockTwoChars'][row];

      for (int col = 0; col < charRow.length; col++) {
        if (mask[row][col] == "0") {
          tileList.add(
            Container(
              alignment: Alignment.center,
              child: Text(charRow[col], style: inActiveStyle),
            ),
          );
        } else {
          // if (mask[row][col] == "1") {
          tileList.add(
            Container(
              alignment: Alignment.center,
              child: Text(charRow[col], style: activeStyle),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: widget.settings['qlockTwoChars'][0].length,
      children: tileList,
    );
  }
}
