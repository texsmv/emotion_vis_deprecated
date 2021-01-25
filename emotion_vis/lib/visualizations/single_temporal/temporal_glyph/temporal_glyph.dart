import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/time_series/models/MTSerie.dart';
import 'package:emotion_vis/visualizations/single_temporal/temporal_glyph/temporal_glyph_painter.dart';
import 'package:flutter/material.dart';

class TemporalGlyph extends StatelessWidget {
  PersonModel personModel;
  TemporalGlyph({Key key, @required this.personModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: TemporalGlyphPainter(personModel: personModel),
      ),
    );
  }
}
