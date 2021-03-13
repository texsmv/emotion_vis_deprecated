import 'package:flutter/material.dart';
import 'package:timeseries_charts/models/MTSerie.dart';
import 'package:timeseries_charts/visualizations/vis_settings.dart';
import 'package:timeseries_charts/visualizations/vis_utils.dart';
import 'package:timeseries_charts/touchable/touchable.dart';

class StackedBarChartPainter extends CustomPainter {
  MTSerie mtSerie;
  VisSettings visSettings;
  BuildContext context;
  int segmentsNumber;
  StackedBarChartPainter({
    @required this.mtSerie,
    @required this.visSettings,
    @required this.context,
    this.segmentsNumber = 10,
  });

  int get varLength => mtSerie.variablesLength;
  int get timeLength => mtSerie.timeLength;

  double _width;
  double _height;
  double _leftOffset = 80;
  double _rightOffset = 100;
  double _topOffset = 30;
  double _bottomOffset = 80;
  double _minBarWidth = 30;
  double _horizontalBarSpace;
  double get _graphicWidth => (_width - _rightOffset - _leftOffset);
  double get _graphicHeight => (_height - _topOffset - _bottomOffset);

  TouchyCanvas touchyCanvas;

  Paint infoPaint;

  @override
  void paint(Canvas canvas, Size size) {
    touchyCanvas = TouchyCanvas(context, canvas);

    _width = size.width;
    _height = size.height;
    _horizontalBarSpace = _graphicWidth / (mtSerie.timeLength - 1);

    infoPaint = Paint()
      ..color = Color.fromARGB(255, 220, 220, 220)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    drawCanvasInfo(canvas);
    for (int i = 0; i < mtSerie.timeLength; i++) {
      drawBar(canvas, i);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
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
    for (int i = 0; i < mtSerie.timeLength; i++) {
      double textHeight = 14;
      double regionWidth = 40;
      touchyCanvas.drawRect(
        Offset(plotWidthFromValue(i.toDouble()) - regionWidth / 2,
                plotHeightFromValue(visSettings.upperLimit)) &
            Size(regionWidth, (_graphicHeight + textHeight)),
        Paint()..color = Colors.transparent,
        hitTestBehavior: HitTestBehavior.opaque,
        paintStyleForTouch: PaintingStyle.fill,
        onHover: (event) {
          print("Hover $i");
        },
        onTapDown: (_) {
          print("por fin");
        },
      );

      // TODO change this

      // String timeLabel = visSettings.timeLabels[i];
      // TextSpan span = new TextSpan(
      //     style: new TextStyle(color: Colors.grey[800], fontSize: 12),
      //     text: timeLabel);
      // TextPainter tp = new TextPainter(
      //     text: span,
      //     textAlign: TextAlign.left,
      //     textDirection: TextDirection.ltr);

      // // canvas.translate(0, i * _horizontalValuesSpace);
      // tp.layout();
      // tp.paint(
      //     canvas,
      //     new Offset(plotWidthFromValue(i.toDouble()),
      //         plotHeightFromValue(visSettings.lowerLimit)));
    }
  }

  void drawBar(Canvas canvas, int timePos) {
    double barWidth;
    if (_horizontalBarSpace < _minBarWidth)
      barWidth = _horizontalBarSpace;
    else
      barWidth = _minBarWidth;
    double currBarHeigth = 0;
    for (var i = 0; i < varLength; i++) {
      double barHeight = VisUtils.toNewRange(
        mtSerie.at(timePos, mtSerie.variablesNames[i]),
        0,
        visSettings.upperLimit,
        0,
        _graphicHeight,
      );
      double leftOffset = plotWidthFromValue(timePos.toDouble());

      double barGraphicHeigth = VisUtils.toNewRange(
        currBarHeigth,
        0,
        _graphicHeight,
        _topOffset,
        _height - _topOffset,
      );
      canvas.drawRect(
          Rect.fromPoints(
              Offset(leftOffset - barWidth / 2,
                  _graphicHeight - currBarHeigth + _topOffset),
              Offset(leftOffset + barWidth / 2,
                  _graphicHeight - (currBarHeigth + barHeight) + _topOffset)),
          Paint()
            ..color = visSettings.colors[mtSerie.variablesNames[i]]
            ..style = PaintingStyle.fill);
      currBarHeigth = currBarHeigth + barHeight;
    }
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
    return VisUtils.toNewRange(value, 0, mtSerie.timeLength.toDouble() - 1,
        _leftOffset, _leftOffset + _graphicWidth);
  }
}
