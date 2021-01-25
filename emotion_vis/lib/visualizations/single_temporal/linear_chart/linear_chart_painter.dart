import 'dart:math';

import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/time_series/models/MTSerie.dart';
import 'package:emotion_vis/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:touchable/touchable.dart';

class LinearChartPainter extends CustomPainter {
  // TemporalEData emotions;
  PersonModel personModel;
  BuildContext context;

  // DataSettings dataSettings = Get.find();

  LinearChartPainter({@required this.personModel, @required this.context});

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

    // print(
    //     "Lenght: ${mtserie.timeSeries[dataProcesor.dimensions[0].value.name].tpoints.length}");

    _width = size.width;
    _height = size.height;
    _dateHorizontalSpace = graphicWidth / (personModel.temporalLength - 1);

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

    for (int i = 0; i < _seriesController.dimensions.length; i++) {
      drawLines(canvas, _seriesController.dimensions[i].name);
    }
  }

  void drawCanvasInfo(Canvas canvas) {
    for (int i = 0; i <= 10; i++) {
      canvas.drawLine(
          Offset(
              0, emotionValue2Heigh(_seriesController.upperBound / 10.0 * i)),
          Offset(graphicWidth,
              emotionValue2Heigh(_seriesController.upperBound / 10.0 * i)),
          valuesPaint);
    }
    for (int i = 0; i <= 10; i++) {
      canvas.drawLine(
          Offset(
              -40, emotionValue2Heigh(_seriesController.upperBound / 10.0 * i)),
          Offset(graphicWidth + _leftOffset,
              emotionValue2Heigh(_seriesController.upperBound / 10.0 * i)),
          valuesPaint);

      double value = (_seriesController.upperBound / 10.0 * i);
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
          new Offset(-60,
              emotionValue2Heigh(_seriesController.upperBound / 10.0 * i) - 8));
    }
    canvas.save();
    canvas.translate(-10, emotionValue2Heigh(0));
    canvas.rotate(pi / 2);

    // for (int i = 0; i < personModel.length; i++) {
    //   // todo: fix ontap
    //   // myCanvas.drawRect(
    //   //   Offset(i * _dateHorizontalSpace - 10, emotionValue2Heigh(0)) &
    //   //       Size(40, 15),
    //   //   Paint(),
    //   //   onTapDown: (_) {
    //   //     print("hiiiiiiioi");
    //   //     print(emotions.data[i].date);
    //   //   },
    //   // );

    //   // TODO change this

    //   String dateStr = dateTimeHour2Str(mtserie
    //       .timeSeries[dataProcesor.dimensions[0].value.name]
    //       .tpoints[i]
    //       .dateTime);
    //   TextSpan span = new TextSpan(
    //       style: new TextStyle(color: Colors.grey[800], fontSize: 12),
    //       text: dateStr);
    //   TextPainter tp = new TextPainter(
    //       text: span,
    //       textAlign: TextAlign.left,
    //       textDirection: TextDirection.ltr);

    //   canvas.translate(0, i * _dateHorizontalSpace);
    //   // tp.layout();
    //   // tp.paint(canvas,
    //   //     new Offset(i * _dateHorizontalSpace - 10, emotionValue2Heigh(0)));
    //   // tp.paint(canvas, new Offset(0, 0));
    // }
    canvas.restore();
  }

  void drawLines(Canvas canvas, String emotion) {
    EmotionDimension emotionDimension = emotionDimensionByname(emotion);

    Paint linePaint = Paint()
      ..color = emotionDimension.color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    linePath = Path();

    canvas.save();
    canvas.translate(_rightOffset, _topOffset);

    drawCanvasInfo(canvas);

    for (int i = 0; i < personModel.values[emotion].length - 1; i++) {
      canvas.drawLine(
        Offset(i * _dateHorizontalSpace,
            emotionValue2Heigh(personModel.values[emotion][i])),
        Offset((i + 1) * _dateHorizontalSpace,
            emotionValue2Heigh(personModel.values[emotion][i + 1])),
        linePaint,
        //     onTapDown: (tapDownDetails) {
        //   print("hiii");
        // }, hitTestBehavior: HitTestBehavior.translucent
      );
    }
    canvas.restore();
  }

  double emotionValue2Heigh(double value) {
    return graphicHeight -
        (value / _seriesController.upperBound * graphicHeight);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
