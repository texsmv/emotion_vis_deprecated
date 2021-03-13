import 'package:emotion_vis/models/person_model.dart';
import 'package:flutter/material.dart';

import '../../vis_settings.dart';
import 'temporal_glyph_painter.dart';

class TemporalGlyph extends StatelessWidget {
  PersonModel personModel;
  VisSettings visSettings;
  double borderOffset;
  TemporalGlyph({
    Key key,
    @required this.personModel,
    @required this.visSettings,
    this.borderOffset = 17,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(personModel.mtSerie.timeSeries[visSettings.variablesNames[0]].values);
    return Container(
      padding: EdgeInsets.all(17),
      child: CustomPaint(
        painter: TemporalGlyphPainter(
          personModel: personModel,
          visSettings: visSettings,
          borderOffset: borderOffset,
        ),
      ),
    );
  }
}
