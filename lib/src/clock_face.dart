import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qlocktwo/src/helper.dart';

class ClockFace extends StatefulWidget {
  final Map<String, dynamic> settings;
  final Map<String, dynamic> languageSettings;
  final int hour;
  final int minute;
  final double size;

  const ClockFace({
    super.key,
    required this.hour,
    required this.minute,
    required this.settings,
    required this.languageSettings,
    required this.size,
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
  }

  void _updateStyles() {
    final double fontSize = widget.size * 0.07;
    
    activeStyle = TextStyle(
      fontFamily: widget.settings['fontActive'],
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: colorFromString(widget.settings['charColorActive']),
      shadows: [
        Shadow(
          blurRadius: widget.size * 0.017,
          color: colorFromString(widget.settings['charShadowColorActive']),
          offset: Offset(0, 0),
        ),
        Shadow(
          blurRadius: widget.size * 0.034,
          color: colorFromString(widget.settings['charShadowColorActive']).withOpacity(0.5),
          offset: Offset(0, 0),
        ),
      ],
    );
    
    inActiveStyle = TextStyle(
      fontFamily: widget.settings['fontInActive'],
      fontSize: fontSize,
      fontWeight: FontWeight.w100,
      foreground:
          Paint()
            ..color = colorFromString(widget.settings['charColorInActive']).withOpacity(0.15)
            ..strokeWidth = widget.size * 0.0017
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _updateStyles();
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

    return Padding(
      padding: EdgeInsets.all(widget.size * 0.03),
      child: Container(
        color: Colors.transparent,
        width: widget.size,
        height: widget.size,
        alignment: Alignment.center,
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          primary: true,
          crossAxisCount: widget.languageSettings['qlockTwoChars'][0].length,
          children: tileList,
        ),
      ),
    );
  }
}
