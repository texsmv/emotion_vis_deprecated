import 'dart:math';

import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/time_series/models/MTSerie.dart';
import 'package:emotion_vis/utils/utils.dart';
import 'package:emotion_vis/visualizations/non_temporal/radar/radar_painter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DimensionalScatterplotPainter extends CustomPainter {
  final PersonModel personModel;
  DimensionalScatterplotPainter({@required this.personModel}) {
    axisPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;
  }

  SeriesController _seriesController = Get.find();

  Offset center;
  double width;
  double height;
  double radius;

  Paint axisPaint;

  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;
    radius = min(size.width / 2, size.height / 2);
    center = Offset(size.width / 2, size.height / 2);

    drawAxis(canvas);
    drawPoint(canvas);
  }

  void drawPoint(Canvas canvas) {
    double valenceValue;
    double dominanceValue;
    double arousalValue;
    for (var i = 0; i < _seriesController.dimensions.length; i++) {
      EmotionDimension emotionDimension =
          emotionDimensionByname(_seriesController.dimensions[i].name);
      switch (emotionDimension.dimensionalDimension) {
        case DimensionalDimension.AROUSAL:
          arousalValue = personModel.values[i].last;
          break;
        case DimensionalDimension.VALENCE:
          valenceValue = personModel.values[i].last;
          break;
        case DimensionalDimension.DOMINANCE:
          dominanceValue = personModel.values[i].last;
          break;

          break;
        default:
      }
    }

    double valenceCanvasValue = rangeConverter(
        valenceValue,
        _seriesController.lowerBound,
        _seriesController.upperBound,
        -radius,
        radius);
    double arousalCanvasValue = rangeConverter(
        arousalValue,
        _seriesController.lowerBound,
        _seriesController.upperBound,
        -radius,
        radius);

    double dominanceRadiusValue = rangeConverter(dominanceValue,
        _seriesController.lowerBound, _seriesController.upperBound, 2, 10);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.drawCircle(Offset(valenceCanvasValue, arousalCanvasValue),
        dominanceRadiusValue, axisPaint);
    canvas.restore();
  }

  void drawAxis(Canvas canvas) {
    canvas.drawLine(
        center + Offset(-radius, 0), center + Offset(radius, 0), axisPaint);
    canvas.drawLine(
        center + Offset(0, -radius), center + Offset(0, radius), axisPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
