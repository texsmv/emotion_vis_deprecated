import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/time_series/models/MTSerie.dart';
import 'package:emotion_vis/visualizations/single_temporal/linear_chart/linear_chart_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:touchable/touchable.dart';

import 'cluster_linear_chart_painter.dart';

class ClusterLinearChart extends StatefulWidget {
  List<PersonModel> blueCluster;
  List<PersonModel> redCluster;
  String variableName;
  ClusterLinearChart(
      {Key key,
      @required this.blueCluster,
      @required this.variableName,
      @required this.redCluster})
      : super(key: key);

  @override
  _ClusterLinearChartState createState() => _ClusterLinearChartState();
}

class _ClusterLinearChartState extends State<ClusterLinearChart> {
  @override
  Widget build(BuildContext context) {
    return CanvasTouchDetector(
      builder: (context) => CustomPaint(
        painter: ClusterLinearChartPainter(
          context: context,
          blueCluster: widget.blueCluster,
          redCluster: widget.redCluster,
          variableName: widget.variableName,
        ),
      ),
    );
  }
}
