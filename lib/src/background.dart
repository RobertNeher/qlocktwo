import 'package:flutter/material.dart';
import 'package:qlocktwo/src/helper.dart';

class Background extends StatelessWidget {
  final Map<String, dynamic> settings;
  Alignment colorAlignment = Alignment.center;
  double windowSize = 0;

  Background({super.key, required this.settings}) {
    windowSize = settings['clockSize'].toDouble();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width >
        MediaQuery.of(context).size.height) {
      windowSize = MediaQuery.of(context).size.height;
    } else {
      windowSize = MediaQuery.of(context).size.width;
    }
    if (windowSize < settings['clockSize'].toDouble()) {
      windowSize = settings['clockSize'].toDouble();
    }

    String orientation = settings['backgroundColorOrientation'].toUpperCase();
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
    for (String colorString in settings['backgroundColor']) {
      colorList.add(colorFromString(colorString));
    }

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
    );
  }
}
