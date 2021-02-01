import 'package:emotion_vis/models/person_model.dart';
import 'package:flutter/material.dart';

import '../../vis_settings.dart';
import 'dimensional_scatterplot_painter.dart';

class DimensionalScatterplot extends StatelessWidget {
  PersonModel personModel;
  VisSettings visSettings;
  int timePoint;
  DimensionalScatterplot({
    Key key,
    @required this.personModel,
    @required this.visSettings,
    @required this.timePoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DimensionalScatterplotPainter(
        personModel: personModel,
        visSettings: visSettings,
        timePoint: timePoint,
      ),
    );
  }
}
