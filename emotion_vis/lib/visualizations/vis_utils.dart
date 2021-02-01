import 'package:flutter/material.dart';
import 'dart:math';

class VisUtils {
  static double toNewRange(double oldValue, double oldMin, double oldMax,
      double newMin, double newMax) {
    return (((oldValue - oldMin) * (newMax - newMin)) / (oldMax - oldMin)) +
        newMin;
  }

  static Offset polarToCartesian(double angle, double r) {
    return Offset(r * cos(angle), r * sin(angle));
  }
}
