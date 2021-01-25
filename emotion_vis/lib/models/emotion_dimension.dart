import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmotionDimension {
  String name;
  Color color;
  RxDouble _alpha = 1.0.obs;
  double get alpha => _alpha.value;
  set alpha(double value) => _alpha.value = value;
  DimensionalDimension dimensionalDimension;
  EmotionDimension({this.name, this.color, this.dimensionalDimension});
}

class CategoricalFeature {
  String name;
  RxDouble _alpha = 1.0.obs;
  double get alpha => _alpha.value;
  set alpha(double value) => _alpha.value = value;
  CategoricalFeature({this.name});
}

class NumericalFeature {
  String name;
  RxDouble _alpha = 1.0.obs;
  double get alpha => _alpha.value;
  set alpha(double value) => _alpha.value = value;
  NumericalFeature({this.name});
}

enum DimensionalDimension {
  NONE,
  AROUSAL,
  VALENCE,
  DOMINANCE,
}
