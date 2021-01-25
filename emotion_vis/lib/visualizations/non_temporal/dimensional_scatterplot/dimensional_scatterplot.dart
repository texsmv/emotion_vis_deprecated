import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/time_series/models/MTSerie.dart';
import 'package:flutter/material.dart';

import 'dimensional_scatterplot_painter.dart';

class DimensionalScatterplot extends StatelessWidget {
  final PersonModel personModel;
  const DimensionalScatterplot({Key key, @required this.personModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DimensionalScatterplotPainter(personModel: personModel),
    );
  }
}
