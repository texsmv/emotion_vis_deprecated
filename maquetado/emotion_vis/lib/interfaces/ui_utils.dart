import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void uiUtilDialog(Widget content) {
  Get.dialog(
    AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      content: content,
    ),
  );
}

double uiUtilRandomDoubleInRange(Random source, num start, num end) =>
    source.nextDouble() * (end - start) + start;

double uiUtilRangeConverter(double oldValue, double oldMin, double oldMax,
    double newMin, double newMax) {
  return (((oldValue - oldMin) * (newMax - newMin)) / (oldMax - oldMin)) +
      newMin;
}

Offset uiUtilPolarToCartesian(double angle, double r) {
  return Offset(r * cos(angle), r * sin(angle));
}
