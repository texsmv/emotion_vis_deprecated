import 'package:emotion_vis/models/person_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:touchable/touchable.dart';

import '../../vis_settings.dart';
import 'linear_chart_painter.dart';

class TemporalLinearChart extends StatefulWidget {
  PersonModel personModel;
  VisSettings visSettings;
  int segmentsNumber;
  TemporalLinearChart({
    Key key,
    @required this.personModel,
    @required this.visSettings,
    this.segmentsNumber = 10,
  }) : super(key: key);

  @override
  _TemporalLinearChartState createState() => _TemporalLinearChartState();
}

class _TemporalLinearChartState extends State<TemporalLinearChart> {
  @override
  Widget build(BuildContext context) {
    print("<METADTA]=====");
    print(widget.visSettings.colors);
    print(widget.visSettings.variablesNames);
    return CanvasTouchDetector(
      builder: (touchyContext) => CustomPaint(
        painter: LinearChartPainter(
          context: touchyContext,
          personModel: widget.personModel,
          visSettings: widget.visSettings,
          segmentsNumber: widget.segmentsNumber,
        ),
      ),
    );
  }
}
