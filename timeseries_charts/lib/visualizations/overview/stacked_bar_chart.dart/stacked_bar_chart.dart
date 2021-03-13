import 'package:flutter/material.dart';
import 'package:timeseries_charts/models/MTSerie.dart';
import 'package:timeseries_charts/visualizations/overview/stacked_bar_chart.dart/stacked_bar_chart_painter.dart';
import 'package:timeseries_charts/visualizations/vis_settings.dart';
import 'package:timeseries_charts/touchable/touchable.dart';

class StackedBarChart extends StatefulWidget {
  MTSerie mtSerie;
  VisSettings visSettings;
  StackedBarChart({
    Key key,
    @required this.mtSerie,
    @required this.visSettings,
  }) : super(key: key);

  @override
  _StackedBarChartState createState() => _StackedBarChartState();
}

class _StackedBarChartState extends State<StackedBarChart> {
  @override
  Widget build(BuildContext context) {
    return CanvasTouchDetector(
      builder: (touchyContext) => CustomPaint(
        painter: StackedBarChartPainter(
          context: touchyContext,
          mtSerie: widget.mtSerie,
          visSettings: widget.visSettings,
        ),
      ),
    );
  }
}
