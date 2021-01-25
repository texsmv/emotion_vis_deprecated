import 'dart:math';

import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:emotion_vis/models/time_unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

Offset polarToCartesian(double angle, double r) {
  return Offset(r * cos(angle), r * sin(angle));
}

String dateTimeHour2Str(DateTime date) {
  String minutes = timeDigit2Str(date.minute);
  String seconds = timeDigit2Str(date.second);

  return minutes + ":" + seconds;
}

String timeDigit2Str(int value) {
  if (value >= 10)
    return value.toString();
  else
    return "0" + value.toString();
}

Future<Color> pickColor(Color pickerColor) async {
  Color pickedColor;
  await showDialog(
    context: Get.context,
    child: AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickerColor,
          onColorChanged: (Color newColor) {
            pickedColor = newColor;
          },
          showLabel: true,
          pickerAreaHeightPercent: 0.8,
        ),
        // Use Material color picker:
        //
        // child: MaterialPicker(
        //   pickerColor: pickerColor,
        //   onColorChanged: changeColor,
        //   showLabel: true, // only on portrait mode
        // ),
        //
        // Use Block color picker:
        //
        // child: BlockPicker(
        //   pickerColor: currentColor,
        //   onColorChanged: changeColor,
        // ),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('Got it'),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    ),
  );
  return pickedColor;
}

String dimension2Str(DimensionalDimension discreteDimension) {
  switch (discreteDimension) {
    case DimensionalDimension.NONE:
      return "Ninguna";
    case DimensionalDimension.AROUSAL:
      return "Arousal";
    case DimensionalDimension.VALENCE:
      return "Valence";
    case DimensionalDimension.DOMINANCE:
      return "Dominance";
      break;
    default:
  }
}

String timeUnit2Str(TimeUnit timeUnit) {
  switch (timeUnit) {
    case TimeUnit.DAY:
      return "dias";
    case TimeUnit.HOUR:
      return "horas";
    case TimeUnit.MINUTE:
      return "minutos";
    case TimeUnit.MONTH:
      return "meses";
    case TimeUnit.WEEK:
      return "semanas";
    case TimeUnit.YEAR:
      return "años";
      break;
    default:
  }
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

Duration durationFromTimeUnits(TimeUnit timeUnit, int timeQuantity) {
  switch (timeUnit) {
    case TimeUnit.MINUTE:
      return Duration(minutes: timeQuantity);
    case TimeUnit.HOUR:
      return Duration(hours: timeQuantity);
    case TimeUnit.DAY:
      return Duration(days: timeQuantity);
    case TimeUnit.WEEK:
      return Duration(days: timeQuantity * 7);
    case TimeUnit.MONTH:
      return Duration(days: timeQuantity * 30);
    case TimeUnit.YEAR:
      return Duration(days: timeQuantity * 365);

      break;
    default:
  }
}

EmotionDimension emotionDimensionByname(String name) {
  SeriesController seriesController = Get.find();
  for (var i = 0; i < seriesController.emotionDimensionLength; i++) {
    if (name == seriesController.dimensions[i].name) {
      return seriesController.dimensions[i];
    }
  }
}

double rangeConverter(double oldValue, double oldMin, double oldMax,
    double newMin, double newMax) {
  return (((oldValue - oldMin) * (newMax - newMin)) / (oldMax - oldMin)) +
      newMin;
}
