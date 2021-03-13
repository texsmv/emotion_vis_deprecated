import 'dart:math';

import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/enums/app_enums.dart';
import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:emotion_vis/models/visualization_levels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

import 'models/time_unit.dart';

class Utils {
  static String discTempVis2Str(DiscreteTemporalVisualization visualization) {
    switch (visualization) {
      case DiscreteTemporalVisualization.LINEAR:
        return "Linear";
      case DiscreteTemporalVisualization.STACK_CHART:
        return "Stack chart";
        break;
      default:
        return "";
    }
  }

  static String discInstVis2Str(DiscreteInstantVisualization visualization) {
    switch (visualization) {
      case DiscreteInstantVisualization.RADAR:
        return "Radar";

        break;
      default:
        return "";
    }
  }

  static String dimInstVis2Str(DimensionalInstantVisualization visualization) {
    switch (visualization) {
      case DimensionalInstantVisualization.DimensionalScatterplot:
        return "Scatterplot";

        break;
      default:
        return "";
    }
  }

  static String dimTempVis2Str(DimensionalTemporalVisualization visualization) {
    switch (visualization) {
      case DimensionalTemporalVisualization.GLYPH:
        return "Glyph";
      case DimensionalTemporalVisualization.STACK_CHART:
        return "Stack chart";
        break;
      default:
        return "";
    }
  }

  static String downsampleRule2Str(DownsampleRule rule) {
    switch (rule) {
      case DownsampleRule.YEARS:
        return "A";
      case DownsampleRule.MONTHS:
        return "M";
      case DownsampleRule.DAYS:
        return "D";
      case DownsampleRule.HOURS:
        return "H";
      case DownsampleRule.MINUTES:
        return "T";
      case DownsampleRule.SECONDS:
        return "S";
      case DownsampleRule.NONE:
        return "NONE";
      default:
        return "NONE";
    }
  }

  static DownsampleRule str2downsampleRule(String rule) {
    switch (rule) {
      case "A":
        return DownsampleRule.YEARS;
      case "M":
        return DownsampleRule.MONTHS;
      case "D":
        return DownsampleRule.DAYS;
      case "H":
        return DownsampleRule.HOURS;
      case "T":
        return DownsampleRule.MINUTES;
      case "S":
        return DownsampleRule.SECONDS;
        break;
      default:
        return DownsampleRule.SECONDS;
    }
  }
}

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
  Color pickedColor = Colors.black;
  await showDialog(
    context: Get.context,
    builder: (_) => AlertDialog(
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
      return "";
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
      return "";
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
      return const Duration();
  }
}

EmotionDimension emotionDimensionByname(String name) {
  SeriesController seriesController = Get.find();
  for (var i = 0; i < seriesController.emotionDimensionLength; i++) {
    if (name == seriesController.dimensions[i].name) {
      return seriesController.dimensions[i];
    }
  }
  return EmotionDimension();
}

double rangeConverter(double oldValue, double oldMin, double oldMax,
    double newMin, double newMax) {
  return (((oldValue - oldMin) * (newMax - newMin)) / (oldMax - oldMin)) +
      newMin;
}
