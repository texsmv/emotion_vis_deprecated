import 'dart:math';

import 'package:emotion_vis/models/temporal_edata.dart';
import 'package:flutter/material.dart';

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
