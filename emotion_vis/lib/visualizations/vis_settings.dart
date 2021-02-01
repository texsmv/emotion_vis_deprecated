import 'package:flutter/material.dart';

class VisSettings {
  Map<String, Color> colors;
  double upperLimit;
  double lowerLimit;
  List<String> timeLabels;
  List<String> variablesNames;

  double get limitSize => upperLimit - lowerLimit;

  VisSettings({
    this.colors,
    this.variablesNames,
    this.lowerLimit,
    this.upperLimit,
    this.timeLabels,
  });
}
