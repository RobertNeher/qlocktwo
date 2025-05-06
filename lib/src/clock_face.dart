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
    hour = int.parse(time.substring(0, 2)) % 12;
    minute = roundMinute(5);

    Timer timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        time = timeFormat.format(DateTime.now());
        hour = int.parse(time.substring(0, 2)) % 12;
        minute = roundMinute(5);
      });
    });

    TextStyle activeStyle = TextStyle(
      fontFamily: widget.settings['font'],
      fontSize: widget.settings['fontSize'].toDouble(),
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
      fontSize: widget.settings['fontSize'].toDouble(),
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

    String minuteMaskRow = '';
    // String hourMaskRow = '';
    List minuteMask =
        widget.settings['fiveMinutesMapping'][(minute / 5).round()][minute
            .toString()];
    List hourMask = widget.settings['hoursMapping'][hour][hour.toString()];

    for (int row = 0; row < widget.settings['qlockTwoChars'].length; row++) {
      minuteMaskRow = widget.settings['qlockTwoChars'][row];

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
  }

  @override
  Widget build(BuildContext context) {
    print(time);
    return GridView.count(
      shrinkWrap: true,
      primary: true,
      crossAxisCount: widget.settings['qlockTwoChars'][0].length,
      children: tileList,
    );
  }
}
