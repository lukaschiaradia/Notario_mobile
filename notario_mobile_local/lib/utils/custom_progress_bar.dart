import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CustomProgressBar extends StatelessWidget {
  final double progress;

  CustomProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Center(
          child: CircularPercentIndicator(
            radius: 40.0,
            lineWidth: 8.0,
            percent: progress,
            center: Text(
              "${(progress * 100).toInt()}%",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            progressColor: Color.fromARGB(255, 65, 106, 243),
          ),
        ),
    );
  }
}