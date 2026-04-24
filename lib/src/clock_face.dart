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
  // Remove local hour/minute state and use widget.hour/minute instead
  // double width = 0;
  // double height = 0;
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
      fontFamily: widget.settings['fontActive'],
      fontSize: widget.settings['fontSizeActive'].toDouble(),
      fontWeight: FontWeight.bold,
      color: colorFromString(widget.settings['charColorActive']),
      shadows: [
        Shadow(
          blurRadius: 10,
          color: colorFromString(widget.settings['charShadowColorActive']),
          offset: Offset(0, 0),
        ),
        Shadow(
          blurRadius: 20,
          color: colorFromString(widget.settings['charShadowColorActive']).withOpacity(0.5),
          offset: Offset(0, 0),
        ),
      ],
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

    // Dimensions are handled in build or can be set here if needed, 
    // but better to use settings directly to ensure it stays in sync.
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tileList = <Widget>[];
    minuteMaskRow = '';
    
    // Ensure minute is within bounds (0-55) for mapping
    int displayMinute = (widget.minute / 5).round() * 5;
    if (displayMinute >= 60) displayMinute = 0;
    
    minuteMask =
        widget.languageSettings['fiveMinutesMapping'][(displayMinute / 5)
            .round()][displayMinute.toString()];
    hourMask = widget.languageSettings['hoursMapping'][widget.hour][widget.hour.toString()];


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

    return Container(
      color: Colors.transparent,
      width: widget.settings['clockSize']?.toDouble() ?? 300,
      height: widget.settings['clockSize']?.toDouble() ?? 300,
      alignment: Alignment.center,
      child: GridView.count(
        shrinkWrap: true,
        primary: true,
        crossAxisCount: widget.languageSettings['qlockTwoChars'][0].length,
        children: tileList,
      ),
    );
  }
}
