import 'package:flutter/material.dart';
import 'package:qlocktwo/src/helper.dart';

class Background extends StatelessWidget {
  final Map<String, dynamic> settings;
  final double size;
  Alignment colorAlignment = Alignment.center;

  Background({super.key, required this.settings, required this.size});

  @override
  Widget build(BuildContext context) {
    String orientation = settings['backgroundColorOrientation']?.toUpperCase() ?? "BL";
    final Map<String, Alignment> alignments = {
      "BL": Alignment.bottomLeft,
      "BC": Alignment.bottomCenter,
      "BR": Alignment.bottomRight,
      "CENTER": Alignment.center,
      "TL": Alignment.topLeft,
      "TC": Alignment.topCenter,
      "TR": Alignment.topRight,
    };

    colorAlignment = alignments[orientation] ?? Alignment.topLeft;

    List<Color> colorList = [];
    for (String colorString in settings['backgroundColor']) {
      colorList.add(colorFromString(colorString));
    }

    // Ensure we have at least 2 colors
    if (colorList.length < 2) {
      colorList = [Colors.brown, Colors.orange];
    }

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: colorAlignment,
          end: Alignment(colorAlignment.x * -1, colorAlignment.y * -1),
          colors: colorList,
          stops: _calculateStops(colorList.length),
          tileMode: TileMode.clamp,
        ),
      ),
      child: Stack(
        children: [
          // Radial highlight to simulate a light source
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.3, -0.3),
                radius: 1.2,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Subtle "brushed" texture effect using many fine lines could be overkill,
          // but a faint overlay can help.
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.02),
              backgroundBlendMode: BlendMode.overlay,
            ),
          ),
        ],
      ),
    );
  }

  List<double> _calculateStops(int count) {
    if (count <= 1) return [0.0];
    return List.generate(count, (i) => i / (count - 1));
  }
}
