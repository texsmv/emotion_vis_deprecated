import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:emotion_vis/models/emotions_models.dart';
import 'package:get/state_manager.dart';
import 'package:flutter/material.dart';

class DataSettings extends GetxController {
  DataSettings();

  EmotionModelType modelType = EmotionModelType.DISCRETE;

  RxInt _emotionsNumber = 6.obs;

  RxDouble _emotionMaxValue = 5.0.obs;

  List<EmotionDimension> emotionDimensions = [
    EmotionDimension(name: "Joy", color: Colors.green),
    EmotionDimension(name: "Anger", color: Colors.red),
    EmotionDimension(name: "Trust", color: Colors.blue),
    EmotionDimension(name: "Fear", color: Colors.purple),
    EmotionDimension(name: "Surprise", color: Colors.blueGrey),
    EmotionDimension(name: "Sadness", color: Colors.pink),
  ];

  int get emotionsNumber => _emotionsNumber.value;

  double get emotionMaxValue => _emotionMaxValue.value;
}
