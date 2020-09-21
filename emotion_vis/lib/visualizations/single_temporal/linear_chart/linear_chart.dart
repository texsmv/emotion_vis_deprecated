import 'package:emotion_vis/models/temporal_edata.dart';
import 'package:emotion_vis/visualizations/single_temporal/linear_chart/linear_chart_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:touchable/touchable.dart';

class TemporalLinearChart extends StatefulWidget {
  TemporalEData emotions;
  TemporalLinearChart({Key key, @required this.emotions}) : super(key: key);

  @override
  _TemporalLinearChartState createState() => _TemporalLinearChartState();
}

class _TemporalLinearChartState extends State<TemporalLinearChart> {
  @override
  Widget build(BuildContext context) {
    // rootBundle.loadString(key)
    return CanvasTouchDetector(
      builder: (context) => CustomPaint(
        painter:
            LinearChartPainter(context: context, emotions: widget.emotions),
      ),
    );
  }
}
