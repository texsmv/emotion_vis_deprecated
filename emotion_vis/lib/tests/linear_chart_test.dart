import 'package:emotion_vis/models/edata.dart';
import 'package:emotion_vis/models/temporal_edata.dart';
import 'package:emotion_vis/visualizations/single_temporal/linear_chart/linear_chart.dart';
import 'package:emotion_vis/visualizations/single_temporal/linear_chart/linear_chart_painter.dart';
import 'package:flutter/material.dart';

class LinearChartTest extends StatefulWidget {
  TemporalEData temporalEData;
  LinearChartTest({Key key, this.temporalEData}) : super(key: key);

  @override
  _LinearChartTestState createState() => _LinearChartTestState();
}

class _LinearChartTestState extends State<LinearChartTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                // color: Colors.green,
                // height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                height: 300,
                width: 650,
                child: TemporalLinearChart(
                  emotions: widget.temporalEData,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
