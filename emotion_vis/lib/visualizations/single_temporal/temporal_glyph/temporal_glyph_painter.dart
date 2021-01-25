import 'dart:math';

import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/time_series/models/MTSerie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TemporalGlyphPainter extends CustomPainter {
  SeriesController _seriesController = Get.find();

  PersonModel personModel;

  Offset center;
  double width;
  double height;
  double radius;

  Paint dominanceLightPaint;
  Paint valenceLightPaint;
  Paint arousalLightPaint;
  Paint dominancePaint;
  Paint valencePaint;
  Paint arousalPaint;

  /// this variable is set in [drawArcsByValues]
  int seriesLenght;
  int segmentNumber = 8;

  double angleOffset = 0 - pi / 2;
  double arcSize = 2 * pi * 1 / 3;

  TemporalGlyphPainter({this.personModel}) {
    // print(
    //     "Lenght: ${mtSerie.timeSeries[dataProcesor.dimensions[0].value.name].tpoints.length}");
    dominanceLightPaint = Paint()
      ..color = _seriesController.dominanceColor.withOpacity(0.1)
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    dominancePaint = Paint()
      ..color = _seriesController.dominanceColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    valenceLightPaint = Paint()
      ..color = _seriesController.valenceColor.withOpacity(0.1)
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    valencePaint = Paint()
      ..color = _seriesController.valenceColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    arousalLightPaint = Paint()
      ..color = _seriesController.arousalColor.withOpacity(0.1)
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    arousalPaint = Paint()
      ..color = _seriesController.arousalColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;
    radius = min(size.width / 2, size.height / 2);
    center = Offset(size.width / 2, size.height / 2);
    drawBackground(canvas);
    drawArcsByValues(canvas);
    drawDivisions(canvas);
  }

  void drawArcsByValues(Canvas canvas) {
    for (var i = 0; i < _seriesController.dimensions.length; i++) {
      String dimensionName = _seriesController.dimensions[i].name;
      seriesLenght = personModel.values[dimensionName].length;
      double segmentArcSize = arcSize / seriesLenght;
      for (var j = 0; j < seriesLenght; j++) {
        int arcValue =
            segmentNumberByValue(personModel.values[dimensionName][j]);
        canvas.drawArc(
            Rect.fromCenter(
              center: center,
              width: radius * 2 * arcValue / segmentNumber,
              height: radius * 2 * arcValue / segmentNumber,
            ),
            angleOffset + (arcSize * i) + segmentArcSize * j,
            segmentArcSize,
            true,
            paintByDimension(
                _seriesController.dimensions[i].dimensionalDimension));
      }
    }
  }

  void drawDivisions(Canvas canvas) {
    Paint divisionPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    double divisionSize = 2 * pi / (seriesLenght * 3);
    for (var i = 0; i < seriesLenght * 3; i++) {
      canvas.drawArc(
          Rect.fromCenter(
              center: center, width: radius * 2, height: radius * 2),
          angleOffset + i * divisionSize,
          divisionSize,
          true,
          divisionPaint);
    }
    for (var i = 0; i < segmentNumber; i++) {
      canvas.drawCircle(center, radius * i / 8, divisionPaint);
    }
  }

  void drawBackground(Canvas canvas) {
    for (var i = 0; i < _seriesController.dimensions.length; i++) {
      canvas.drawArc(
          Rect.fromCenter(
            center: center,
            width: radius * 2,
            height: radius * 2,
          ),
          angleOffset + (arcSize * i),
          arcSize,
          true,
          lightPaintByDimension(
              _seriesController.dimensions[i].dimensionalDimension));
    }
  }

  int segmentNumberByValue(double oldValue) {
    double oldMin = _seriesController.lowerBound;
    double oldMax = _seriesController.upperBound;
    double newMax = segmentNumber.toDouble();

    double newValue =
        (((oldValue - oldMin) * (newMax - 1)) / (oldMax - oldMin)) + 1;
    return newValue.toInt();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Paint paintByDimension(DimensionalDimension dimensionalDimension) {
    switch (dimensionalDimension) {
      case DimensionalDimension.VALENCE:
        return valencePaint;
      case DimensionalDimension.DOMINANCE:
        return dominancePaint;
      case DimensionalDimension.AROUSAL:
        return arousalPaint;

        break;
      default:
    }
  }

  Paint lightPaintByDimension(DimensionalDimension dimensionalDimension) {
    switch (dimensionalDimension) {
      case DimensionalDimension.VALENCE:
        return valenceLightPaint;
      case DimensionalDimension.DOMINANCE:
        return dominanceLightPaint;
      case DimensionalDimension.AROUSAL:
        return arousalLightPaint;

        break;
      default:
    }
  }
}
