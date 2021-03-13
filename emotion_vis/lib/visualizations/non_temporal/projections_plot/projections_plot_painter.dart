import 'dart:math';

import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/time_series/models/MTSerie.dart';
import 'package:emotion_vis/utils/utils.dart';
import 'package:emotion_vis/visualizations/non_temporal/projections_plot/projection_plot_ui_controller.dart';
import 'package:emotion_vis/visualizations/non_temporal/radar/radar_painter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:touchable/touchable.dart';

class ProjectionPlotPainter extends CustomPainter {
  bool paintSelectArea;
  Offset selectedAreaStart;
  Offset selectedAreaEnd;
  List<Offset> positions;
  List<PersonModel> personsModels;
  ProjectionPlotUiController controller = Get.find();

  Offset xlim;
  Offset ylim;
  List<Function> onTap;
  BuildContext context;
  ProjectionPlotPainter({
    @required this.personsModels,
    @required this.positions,
    @required this.xlim,
    @required this.ylim,
    @required this.selectedAreaStart,
    @required this.selectedAreaEnd,
    @required this.paintSelectArea,
    @required this.context,
    this.onTap,
  }) {
    axisPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    bluePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;
    redPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    areaPaint = Paint()
      ..color = Color.fromARGB(128, 130, 130, 130)
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;
  }

  Offset center;
  double width;
  double height;
  double radius;

  Paint axisPaint;
  Paint bluePaint;
  Paint redPaint;
  Paint areaPaint;
  TouchyCanvas touchyCanvas;
  SeriesController _seriesController = Get.find();

  @override
  void paint(Canvas canvas, Size size) {
    touchyCanvas = TouchyCanvas(context, canvas);

    width = size.width;
    height = size.height;
    radius = min(size.width / 2, size.height / 2);
    center = Offset(size.width / 2, size.height / 2);
    controller.canvasWidth = width;
    controller.canvasHeight = height;

    drawAxis(canvas);
    drawPoint(canvas);

    if (paintSelectArea) {
      touchyCanvas.drawRect(
        Rect.fromLTRB(selectedAreaStart.dx, selectedAreaStart.dy,
            selectedAreaEnd.dx, selectedAreaEnd.dy),
        areaPaint,
      );
    }
  }

  void drawPoint(Canvas canvas) {
    for (var i = 0; i < personsModels.length; i++) {
      PersonModel person = personsModels[i];
      double x = rangeConverter(positions[i].dx, xlim.dx, xlim.dy, 0, width);
      double y = rangeConverter(positions[i].dy, ylim.dx, ylim.dy, 0, height);
      Paint paint = axisPaint;
      if (personsModels[i].clusterId == null)
        paint = axisPaint;
      else {
        paint = Paint()
          ..color = _seriesController.clustersColors[personsModels[i].clusterId]
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 3;
        // if (personsModels[i].clusterId == 0) {
        //   paint = bluePaint;
        // } else if (personsModels[i].clusterId == 1) {
        //   paint = redPaint;
        // }
      }

      touchyCanvas.drawCircle(
        Offset(x, y),
        6,
        paint,
        onLongPressStart: (details) {
          if (onTap != null) {
            onTap[i]();
          }
        },
        hitTestBehavior: HitTestBehavior.opaque,
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
