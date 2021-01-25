import 'dart:math';

import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/time_series/models/MTSerie.dart';
import 'package:emotion_vis/utils/utils.dart';
import 'package:emotion_vis/visualizations/non_temporal/radar/radar_painter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:touchable/touchable.dart';

class ScatterChartPainter extends CustomPainter {
  List<double> x_s;
  List<double> y_s;
  List<PersonModel> personsModels;
  // List<List<double>> positions;
  List<double> xlim;
  List<double> ylim;
  List<Function> onTap;
  BuildContext context;
  ScatterChartPainter({
    @required this.personsModels,
    @required this.x_s,
    @required this.y_s,
    @required this.xlim,
    @required this.ylim,
    @required this.context,
    this.onTap,
  }) {
    axisPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;
  }

  Offset center;
  double width;
  double height;
  double radius;

  Paint axisPaint;
  TouchyCanvas touchyCanvas;

  @override
  void paint(Canvas canvas, Size size) {
    touchyCanvas = TouchyCanvas(context, canvas);

    width = size.width;
    height = size.height;
    radius = min(size.width / 2, size.height / 2);
    center = Offset(size.width / 2, size.height / 2);

    drawAxis(canvas);
    drawPoint(canvas);
  }

  void drawPoint(Canvas canvas) {
    print("XS: $x_s");
    print("YS: $y_s");
    for (var i = 0; i < personsModels.length; i++) {
      PersonModel person = personsModels[i];
      double x = rangeConverter(x_s[i], xlim[0], xlim[1], 0, width);
      double y = rangeConverter(y_s[i], ylim[0], ylim[1], 0, height);
      touchyCanvas.drawCircle(
        Offset(x, y),
        4,
        axisPaint,
        onTapDown: (details) {
          if (onTap != null) {
            onTap[i]();
          }
        },
      );

      TextSpan span = new TextSpan(
        style: new TextStyle(color: Colors.grey[800], fontSize: 14),
        text: person.id,
      );
      TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, new Offset(x + 5, y - 15));
    }
  }

  void drawAxis(Canvas canvas) {
    canvas.drawLine(
        Offset(0, height / 2), Offset(width, height / 2), axisPaint);
    canvas.drawLine(Offset(width / 2, 0), Offset(width / 2, height), axisPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
