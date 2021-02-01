import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeseries_charts/models/person_model.dart';
import 'package:timeseries_charts/visualizations/vis_settings.dart';
import 'package:timeseries_charts/visualizations/vis_utils.dart';

class DimensionalScatterplotPainter extends CustomPainter {
  PersonModel personModel;
  VisSettings visSettings;
  int timePoint;
  DimensionalScatterplotPainter(
      {@required this.personModel,
      this.timePoint,
      @required this.visSettings}) {
    axisPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;
  }

  Offset center;
  double width;
  double height;
  double radius;

  Paint axisPaint;

  int get varLength => visSettings.variablesNames.length;

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
    double arousalValue;
    double dominanceValue;
    for (var i = 0; i < varLength; i++) {
      switch (i) {
        case 0:
          arousalValue =
              personModel.mtSerie.at(timePoint, visSettings.variablesNames[i]);
          break;
        case 1:
          valenceValue =
              personModel.mtSerie.at(timePoint, visSettings.variablesNames[i]);
          break;
        case 2:
          dominanceValue =
              personModel.mtSerie.at(timePoint, visSettings.variablesNames[i]);
          break;

        default:
          break;
      }
    }

    double valenceCanvasValue = VisUtils.toNewRange(valenceValue,
        visSettings.lowerLimit, visSettings.upperLimit, -radius, radius);
    double arousalCanvasValue = VisUtils.toNewRange(arousalValue,
        visSettings.lowerLimit, visSettings.upperLimit, -radius, radius);

    double dominanceRadiusValue;
    if (varLength == 3)
      dominanceRadiusValue = VisUtils.toNewRange(dominanceValue,
          visSettings.lowerLimit, visSettings.upperLimit, 2, 10);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    if (varLength == 3)
      canvas.drawCircle(Offset(valenceCanvasValue, arousalCanvasValue),
          dominanceRadiusValue, axisPaint);
    else
      canvas.drawCircle(
          Offset(valenceCanvasValue, arousalCanvasValue), 4, axisPaint);
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
