import 'dart:math';

import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/time_series/models/MTSerie.dart';
import 'package:emotion_vis/utils/utils.dart';
import 'package:emotion_vis/visualizations/vis_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:touchable/touchable.dart';

class ClusterLinearChartPainter extends CustomPainter {
  String variableName;
  List<PersonModel> blueCluster;
  List<PersonModel> redCluster;
  BuildContext context;
  VisSettings visSettings;

  ClusterLinearChartPainter({
    @required this.blueCluster,
    @required this.redCluster,
    @required this.variableName,
    @required this.context,
    @required this.visSettings,
  });

  Paint valuesPaint;
  Paint rectPaint;

  double _width;
  double _height;
  double _dateHorizontalSpace;
  double _leftOffset = 30;
  double _rightOffset = 70;
  double _topOffset = 20;
  double _bottomOffset = 20;

  double get graphicWidth => (_width - _rightOffset - _leftOffset);
  double get graphicHeight => (_height - _topOffset - _bottomOffset);

  Path linePath;
  TouchyCanvas myCanvas;
  SeriesController _seriesController = Get.find();

  @override
  void paint(Canvas canvas, Size size) {
    myCanvas = TouchyCanvas(context, canvas);

    _width = size.width;
    _height = size.height;
    // TODO check this
    _dateHorizontalSpace = graphicWidth / (_seriesController.windowLength - 1);

    valuesPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    rectPaint = Paint()
      ..color = Colors.blue.withAlpha(120)
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    drawLines(canvas);
  }

  void drawCanvasInfo(Canvas canvas) {
    for (int i = 0; i <= 10; i++) {
      canvas.drawLine(
          Offset(0, emotionValue2Heigh(visSettings.upperLimit / 10.0 * i)),
          Offset(graphicWidth,
              emotionValue2Heigh(visSettings.upperLimit / 10.0 * i)),
          valuesPaint);
    }
    for (int i = 0; i <= 10; i++) {
      canvas.drawLine(
          Offset(-40, emotionValue2Heigh(visSettings.upperLimit / 10.0 * i)),
          Offset(graphicWidth + _leftOffset,
              emotionValue2Heigh(visSettings.upperLimit / 10.0 * i)),
          valuesPaint);

      double value = (visSettings.upperLimit / 10.0 * i);
      TextSpan span = new TextSpan(
          style: new TextStyle(color: Colors.grey[800], fontSize: 12),
          text: value.toStringAsFixed(1));
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(
          canvas,
          new Offset(
              -60, emotionValue2Heigh(visSettings.upperLimit / 10.0 * i) - 8));
    }
    canvas.save();
    canvas.translate(-10, emotionValue2Heigh(0));
    canvas.rotate(pi / 2);

    canvas.restore();
  }

  void drawLines(Canvas canvas) {
    String emotion = variableName;

    Paint bluePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    Paint redPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    linePath = Path();

    canvas.save();
    canvas.translate(_rightOffset, _topOffset);

    drawCanvasInfo(canvas);
    for (var k = 0; k < blueCluster.length; k++) {
      // todo check this
      for (int i = 0; i < _seriesController.windowLength - 1; i++) {
        canvas.drawLine(
          Offset(i * _dateHorizontalSpace,
              emotionValue2Heigh(blueCluster[k].mtSerie.at(i, emotion))),
          Offset((i + 1) * _dateHorizontalSpace,
              emotionValue2Heigh(blueCluster[k].mtSerie.at(i + 1, emotion))),
          bluePaint,
        );
      }
    }

    for (var k = 0; k < redCluster.length; k++) {
      // todo check this
      for (int i = 0; i < _seriesController.windowLength - 1; i++) {
        canvas.drawLine(
          Offset(i * _dateHorizontalSpace,
              emotionValue2Heigh(redCluster[k].mtSerie.at(i, emotion))),
          Offset((i + 1) * _dateHorizontalSpace,
              emotionValue2Heigh(redCluster[k].mtSerie.at(i + 1, emotion))),
          redPaint,
        );
      }
    }
    canvas.restore();
  }

  double emotionValue2Heigh(double value) {
    return graphicHeight - (value / visSettings.upperLimit * graphicHeight);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
