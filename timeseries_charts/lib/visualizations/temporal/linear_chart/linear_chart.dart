import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeseries_charts/models/person_model.dart';
import 'package:timeseries_charts/visualizations/vis_settings.dart';
import 'package:timeseries_charts/touchable/touchable.dart';

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
