import 'package:emotion_vis/interfaces/constants/colors.dart';
import 'package:flutter/material.dart';

class SummaryVisualizationView extends StatelessWidget {
  const SummaryVisualizationView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: pColorBackground,
        border: Border.all(color: pColorPrimary, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
