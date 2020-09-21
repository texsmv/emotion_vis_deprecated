import 'dart:math';
import 'dart:ui';
import 'package:emotion_vis/controllers/data_settings.dart';
import 'package:emotion_vis/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstantRadarPainter extends CustomPainter {
  DataSettings dataSettings = Get.find();
  double width;
  final List<String> emotionsLabels;
  final List<double> emotionsValues;

  double _numberRings = 3;
  double _sweepAngle;
  Offset _center;
  double _radius;

  int _emotionsNumber = 4;

  Paint circlePaint;
  Paint valuesPaint;

  InstantRadarPainter({
    this.width = 5,
    @required this.emotionsLabels,
    @required this.emotionsValues,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _emotionsNumber = emotionsLabels.length;
    _sweepAngle = 2 * pi / _emotionsNumber;
    _center = Offset(size.width / 2, size.height / 2);
    _radius = min(size.width / 2, size.height / 2) * 0.8;
    width = _radius * 0.05;

    circlePaint = Paint()
      ..color = Color.fromARGB(255, 140, 140, 140)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width * 0.7;

    valuesPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width;

    drawRings(canvas);
    drawScales(canvas);
    drawLabels(canvas);
    drawValues(canvas);
  }

  void drawRings(Canvas canvas) {
    double segmentSize = _radius / _numberRings;
    for (int i = 1; i < _numberRings + 1; i++) {
      canvas.drawCircle(_center, segmentSize * i, circlePaint);
    }
  }

  void drawScales(Canvas canvas) {
    canvas.save();
    canvas.translate(_center.dx, _center.dy);
    for (int i = 0; i < _emotionsNumber; i++) {
      canvas.rotate(_sweepAngle);
      Offset offset = polarToCartesian(0, _radius);
      canvas.drawLine(Offset(0, 0), Offset(_radius, 0), circlePaint);
    }
    canvas.restore();
  }

  void drawLabels(Canvas canvas) {
    double segmentSize = _radius / _numberRings;
    canvas.save();
    canvas.translate(_center.dx, _center.dy);
    for (int i = 0; i < _emotionsNumber; i++) {
      TextSpan span = new TextSpan(
          style: new TextStyle(color: Colors.black, fontSize: _radius * 0.1),
          text: emotionsLabels[i]);
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl);
      tp.layout();

      Offset offset = polarToCartesian(0, _radius * 1);

      tp.paint(canvas, offset);
      canvas.rotate(_sweepAngle);
    }
    canvas.restore();
  }

  void drawValues(Canvas canvas) {
    Path emotionsPath = Path();

    canvas.save();
    canvas.translate(_center.dx, _center.dy);

    Offset offset;

    offset = polarToCartesian(
        _sweepAngle * (_emotionsNumber - 1),
        emotionsValues[_emotionsNumber - 1] /
            dataSettings.emotionMaxValue *
            _radius);
    emotionsPath.moveTo(offset.dx, offset.dy);

    for (int i = 0; i < _emotionsNumber; i++) {
      offset = polarToCartesian(_sweepAngle * i,
          ((emotionsValues[i] / dataSettings.emotionMaxValue)) * _radius);
      emotionsPath.lineTo(offset.dx, offset.dy);
    }

    emotionsPath.close();
    canvas.drawPath(emotionsPath, valuesPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
