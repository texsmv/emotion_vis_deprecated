import 'package:emotion_vis/controllers/data_settings.dart';
import 'package:emotion_vis/models/temporal_edata.dart';
import 'package:emotion_vis/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:touchable/touchable.dart';

class LinearChartPainter extends CustomPainter {
  TemporalEData emotions;
  BuildContext context;

  DataSettings dataSettings = Get.find();

  LinearChartPainter({@required this.emotions, @required this.context});

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

  @override
  void paint(Canvas canvas, Size size) {
    myCanvas = TouchyCanvas(context, canvas);

    _width = size.width;
    _height = size.height;
    _dateHorizontalSpace = graphicWidth / (emotions.data.length - 1);

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

    for (int i = 0; i < dataSettings.emotionDimensions.length; i++) {
      drawLines(canvas, dataSettings.emotionDimensions[i].name,
          dataSettings.emotionDimensions[i].color);
    }
  }

  void drawCanvasInfo(Canvas canvas) {
    for (int i = 0; i <= 10; i++) {
      canvas.drawLine(
          Offset(
              0, emotionValue2Heigh(dataSettings.emotionMaxValue / 10.0 * i)),
          Offset(graphicWidth,
              emotionValue2Heigh(dataSettings.emotionMaxValue / 10.0 * i)),
          valuesPaint);
    }
    for (int i = 0; i <= 10; i++) {
      canvas.drawLine(
          Offset(
              -40, emotionValue2Heigh(dataSettings.emotionMaxValue / 10.0 * i)),
          Offset(graphicWidth + _leftOffset,
              emotionValue2Heigh(dataSettings.emotionMaxValue / 10.0 * i)),
          valuesPaint);

      double value = (dataSettings.emotionMaxValue / 10.0 * i);
      TextSpan span = new TextSpan(
          style: new TextStyle(color: Colors.grey[800], fontSize: 12),
          text: value.toString());
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(
          canvas,
          new Offset(-60,
              emotionValue2Heigh(dataSettings.emotionMaxValue / 10.0 * i) - 8));
    }

    for (int i = 0; i < emotions.data.length; i++) {
      // todo: fix ontap
      // myCanvas.drawRect(
      //   Offset(i * _dateHorizontalSpace - 10, emotionValue2Heigh(0)) &
      //       Size(40, 15),
      //   Paint(),
      //   onTapDown: (_) {
      //     print("hiiiiiiioi");
      //     print(emotions.data[i].date);
      //   },
      // );

      String dateStr = dateTimeHour2Str(emotions.data[i].date);
      TextSpan span = new TextSpan(
          style: new TextStyle(color: Colors.grey[800], fontSize: 12),
          text: dateStr);
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas,
          new Offset(i * _dateHorizontalSpace - 10, emotionValue2Heigh(0)));
    }
  }

  void drawLines(Canvas canvas, String emotion, Color lineColor) {
    Paint linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    linePath = Path();

    canvas.save();
    canvas.translate(_rightOffset, _topOffset);

    drawCanvasInfo(canvas);

    for (int i = 0; i < emotions.data.length - 1; i++) {
      canvas.drawLine(
        Offset(i * _dateHorizontalSpace,
            emotionValue2Heigh(emotions.data[i].data[emotion])),
        Offset((i + 1) * _dateHorizontalSpace,
            emotionValue2Heigh(emotions.data[i + 1].data[emotion])),
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
        (value / dataSettings.emotionMaxValue * graphicHeight);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
