import 'dart:math';
import 'package:flutter/material.dart';

class VisSettings {
  Map<String, Color> colors;
  Map<String, double> upperLimits;
  Map<String, double> lowerLimits;
  // double lowerLimit;
  // double upperLimit;
  List<String> timeLabels;
  List<String> variablesNames;

  double get upperLimit {
    return upperLimits.values.map((e) => e).toList().reduce(max);
  }

  double get lowerLimit {
    return lowerLimits.values.map((e) => e).toList().reduce(min);
  }

  double get limitSize => upperLimit - lowerLimit;

  VisSettings({
    this.colors,
    this.variablesNames,
    // this.lowerLimit,
    // this.upperLimit,
    this.lowerLimits,
    this.upperLimits,
    this.timeLabels,
  });
}
