import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeseries_charts/models/person_model.dart';
import 'package:timeseries_charts/visualizations/vis_settings.dart';
import 'package:timeseries_charts/visualizations/vis_utils.dart';
import 'package:timeseries_charts/touchable/touchable.dart';

class LinearChartPainter extends CustomPainter {
  PersonModel personModel;
  VisSettings visSettings;
  final BuildContext context;
  int segmentsNumber;

  LinearChartPainter({
    @required this.personModel,
    @required this.visSettings,
    @required this.context,
    this.segmentsNumber = 10,
  });

  Paint infoPaint;
  Paint rectPaint;

  double _width;
  double _height;
  double _horizontalValuesSpace;
  double _infoPointRadius = 6;
  double _leftOffset = 80;
  double _rightOffset = 100;
  double _topOffset = 30;
  double _bottomOffset = 80;

  double get _graphicWidth => (_width - _rightOffset - _leftOffset);
  double get _graphicHeight => (_height - _topOffset - _bottomOffset);

  Path linePath;
  TouchyCanvas touchyCanvas;

  @override
  void paint(Canvas canvas, Size size) {
    touchyCanvas = TouchyCanvas(context, canvas);

    _width = size.width;
    _height = size.height;
    _horizontalValuesSpace =
        _graphicWidth / (personModel.mtSerie.timeLength - 1);

    infoPaint = Paint()
      ..color = Color.fromARGB(255, 220, 220, 220)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    rectPaint = Paint()
      ..color = Colors.blue.withAlpha(120)
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    drawCanvasInfo(canvas);
    for (int i = 0; i < personModel.mtSerie.variablesLength; i++) {
      drawLines(canvas, personModel.mtSerie.variablesNames[i]);
    }
  }

  void drawCanvasInfo(Canvas canvas) {
    for (int i = 0; i <= segmentsNumber; i++) {
      // draw horizontal lines
      double lineHeight = plotHeightFromValue(
          (visSettings.limitSize / segmentsNumber * i) +
              visSettings.lowerLimit);
      canvas.drawLine(
        Offset(_leftOffset, lineHeight),
        Offset(_leftOffset + _graphicWidth, lineHeight),
        infoPaint,
      );

      // draw lines text
      double value =
          (visSettings.limitSize / segmentsNumber * i) + visSettings.lowerLimit;
      TextSpan span = new TextSpan(
          style: new TextStyle(color: Colors.grey[800], fontSize: 12),
          text: value.toStringAsFixed(1));
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.right,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(
        canvas,
        new Offset(5, lineHeight - 7),
      );
    }
    // canvas.translate(-10, plotHeightFromValue(0));
    // canvas.rotate(pi / 2);

    for (int i = 0; i < personModel.mtSerie.timeLength; i++) {
      double textHeight = 14;
      double regionWidth = 40;
      touchyCanvas.drawRect(
        Offset(plotWidthFromValue(i.toDouble()) - regionWidth / 2,
                plotHeightFromValue(visSettings.upperLimit)) &
            Size(regionWidth, (_graphicHeight + textHeight)),
        Paint()..color = Colors.transparent,
        // Paint(),
        hitTestBehavior: HitTestBehavior.opaque,
        paintStyleForTouch: PaintingStyle.fill,
        onTapDown: (_) {
          print("por fin");
        },
      );

      // TODO change this

      String timeLabel = visSettings.timeLabels[i];
      TextSpan span = new TextSpan(
          style: new TextStyle(color: Colors.grey[800], fontSize: 12),
          text: timeLabel);
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);

      // canvas.translate(0, i * _horizontalValuesSpace);
      tp.layout();
      tp.paint(
          canvas,
          new Offset(plotWidthFromValue(i.toDouble()),
              plotHeightFromValue(visSettings.lowerLimit)));
    }
  }

  void drawLines(Canvas canvas, String emotion) {
    Paint linePaint = Paint()
      ..color = visSettings.colors[emotion]
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;
    Paint circlePaint = Paint()
      ..color = visSettings.colors[emotion]
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    linePath = Path();

    canvas.save();

    for (int i = 0; i < personModel.mtSerie.timeLength - 1; i++) {
      Offset from = Offset(plotWidthFromValue(i.toDouble()),
          plotHeightFromValue(personModel.mtSerie.at(i, emotion)));
      Offset to = Offset(plotWidthFromValue((i + 1).toDouble()),
          plotHeightFromValue(personModel.mtSerie.at(i + 1, emotion)));
      canvas.drawLine(
        from,
        to,
        linePaint,
      );
      canvas.drawCircle(to, _infoPointRadius, circlePaint);
    }

    canvas.restore();
  }

  double plotHeightFromValue(double value) {
    return _height -
        VisUtils.toNewRange(
          value,
          visSettings.lowerLimit,
          visSettings.upperLimit,
          _bottomOffset,
          _bottomOffset + _graphicHeight,
        );
  }

  double plotWidthFromValue(double value) {
    return VisUtils.toNewRange(
        value,
        0,
        personModel.mtSerie.timeLength.toDouble() - 1,
        _leftOffset,
        _leftOffset + _graphicWidth);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
