import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmotionDimension {
  String name;
  Color color;
  RxDouble _alpha = 1.0.obs;

  double get alpha => _alpha.value;
  set alpha(double value) => _alpha.value = value;
  RxBool _remove = false.obs;
  bool get remove => _remove.value;
  set remove(bool value) => _remove.value = value;

  DimensionalDimension dimensionalDimension;
  EmotionDimension(
      {this.name = "default",
      this.color = Colors.black,
      this.dimensionalDimension});
}

class CategoricalFeature {
  String name;
  CategoricalFeature({this.name = "default"});
}

class NumericalFeature {
  String name;
  NumericalFeature({this.name = "default"});
}

enum DimensionalDimension {
  NONE,
  AROUSAL,
  VALENCE,
  DOMINANCE,
}

enum EmotionModelType { DIMENSIONAL, DISCRETE }
