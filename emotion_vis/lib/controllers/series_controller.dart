import 'dart:convert';

import 'package:emotion_vis/enums/app_enums.dart';
import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:emotion_vis/models/emotions_models.dart';
import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/models/visualization_levels.dart';
import 'package:emotion_vis/repositories/series_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_color/random_color.dart';

class SeriesController extends GetxController {
  double lowerBound;
  double upperBound;

  List<PersonModel> _persons = [];

  List<String> _ids = [];

  List<String> get ids => _ids;

  int _windowSize = 7;
  int _windowStep = 1;
  int _windowPosition = 0;
  int _instanceLength = 0;
  int _temporalLength = 0;
  int _emotionDimensionLength = 0;

  int get instanceLength => _instanceLength;
  int get temporalLength => _temporalLength;
  int get emotionDimensionLength => _emotionDimensionLength;

  int get windowSize => _windowSize;
  int get windowStep => _windowStep;

  PersonModel selectedPerson;
  List<PersonModel> get persons => _persons;

  List<PersonModel> blueCluster = [];
  List<PersonModel> redCluster = [];
  List<PersonModel> get clusteredPersons =>
      List.from(blueCluster)..addAll(redCluster);

  List<EmotionDimension> dimensions = [];
  List<CategoricalFeature> categoricalFeatures = [];
  List<NumericalFeature> numericalFeatures = [];

  bool _useAllData = false;

  void notify() {
    update();
  }

  Color get valenceColor {
    for (var i = 0; i < dimensions.length; i++) {
      if (dimensions[i].dimensionalDimension == DimensionalDimension.VALENCE)
        return dimensions[i].color;
    }
  }

  Color get dominanceColor {
    for (var i = 0; i < dimensions.length; i++) {
      if (dimensions[i].dimensionalDimension == DimensionalDimension.DOMINANCE)
        return dimensions[i].color;
    }
  }

  Color get arousalColor {
    for (var i = 0; i < dimensions.length; i++) {
      if (dimensions[i].dimensionalDimension == DimensionalDimension.AROUSAL)
        return dimensions[i].color;
    }
  }

  /// Temporal visualization choosed for emotion model type
  Rx<DiscreteTemporalVisualization> discreteTemporalVisualization =
      DiscreteTemporalVisualization.values[0].obs;
  Rx<DimensionalTemporalVisualization> dimensionalTemporalVisualization =
      DimensionalTemporalVisualization.values[0].obs;

  /// Instant visualization choosed for emotion model type
  Rx<DiscreteInstantVisualization> discreteInstantVisualization =
      DiscreteInstantVisualization.values[0].obs;
  Rx<DimensionalInstantVisualization> dimensionalInstantVisualization =
      DimensionalInstantVisualization.values[0].obs;

  EmotionModelType _modelType = EmotionModelType.DISCRETE;
  EmotionModelType get modelType => _modelType;
  set modelType(EmotionModelType value) {
    _modelType = value;
    update();
  }

  Future<NotifierState> loadValuesInRange(int begin, int end) async {
    _persons = [];
    Map<String, dynamic> queryMap =
        await SeriesRepository.getAllValuesInRange(begin, end);
    List<String> ids = queryMap.keys.toList();
    for (int i = 0; i < ids.length; i++) {
      Map dimensions = queryMap[ids[i]];
      _persons.add(PersonModel.fromMap(map: dimensions, id: ids[i]));
    }
    update();
    return NotifierState.SUCCESS;
  }

  void updateLocalSettings({int newWindowSize, int newWindowStep}) {
    if (newWindowSize != null) _windowSize = newWindowSize;
    if (newWindowStep != null) _windowStep = newWindowStep;

    update();
  }

  Future<NotifierState> initializeDataset() async {
    return await SeriesRepository.initializeDataset();
  }

  Future<NotifierState> addEml(String xmlString, bool isCategorical) async {
    return await SeriesRepository.addEml(xmlString, isCategorical);
  }

  Future<void> updateIds() async {
    _ids = await SeriesRepository.getIds();
    update();
    return;
  }

  Future<NotifierState> setBounds(double minValue, double maxValue) async {
    NotifierState state = await SeriesRepository.setBounds(minValue, maxValue);
    lowerBound = minValue;
    upperBound = maxValue;
    update();
    return NotifierState.SUCCESS;
  }

  Future<NotifierState> initBounds() async {
    await SeriesRepository.calculateBounds();
    List<double> values = await SeriesRepository.getBounds();
    print(values);
    lowerBound = values[0];
    upperBound = values[1];
    update();
    return NotifierState.SUCCESS;
  }

  Future<NotifierState> initLengths() async {
    _instanceLength = await SeriesRepository.getInstanceLength();
    _temporalLength = await SeriesRepository.getTimeLength();
    _emotionDimensionLength = dimensions.length;

    update();
    return NotifierState.SUCCESS;
  }

  Future<NotifierState> initDimensions() async {
    List<String> dimensionsNames = await SeriesRepository.getDimensionsLabels();
    dimensions = List.generate(
        dimensionsNames.length,
        (index) => EmotionDimension(
            name: dimensionsNames[index],
            color: RandomColor().randomColor(),
            dimensionalDimension: DimensionalDimension.NONE));
    update();
    return NotifierState.SUCCESS;
  }

  Future<NotifierState> updateBounds(double minValue, double maxValue) async {
    List<double> values = await SeriesRepository.getBounds();
    lowerBound = values[0];
    upperBound = values[1];
    update();
    return NotifierState.SUCCESS;
  }

  Future<void> loadFeatures() async {
    List<String> numericalLabels = await SeriesRepository.getNumericalLabels();
    print(numericalLabels);
    for (var i = 0; i < numericalLabels.length; i++) {
      numericalFeatures.add(NumericalFeature(name: numericalLabels[i]));
    }

    List<String> categoricalLabels =
        await SeriesRepository.getCategoricalLabels();
    print(categoricalLabels);
    for (var i = 0; i < categoricalLabels.length; i++) {
      categoricalFeatures.add(CategoricalFeature(name: categoricalLabels[i]));
    }
    update();
  }

  Future<NotifierState> setEmotionAlphas(List<double> alphas) async {
    assert(alphas.length == dimensions.length);
    NotifierState state = await SeriesRepository.setEmotionAlphas(alphas);
    for (var i = 0; i < dimensions.length; i++) {
      dimensions[i].alpha = alphas[i];
    }
    update();
    return state;
  }

  Future<NotifierState> setCategoricalAlphas(List<double> alphas) async {
    assert(categoricalFeatures.length == alphas.length);
    NotifierState state = await SeriesRepository.setCategoricalAlphas(alphas);
    for (var i = 0; i < categoricalFeatures.length; i++) {
      categoricalFeatures[i].alpha = alphas[i];
    }
    update();
    return state;
  }

  Future<NotifierState> setNumericalAlphas(List<double> alphas) async {
    assert(numericalFeatures.length == alphas.length);
    NotifierState state = await SeriesRepository.setNumericalAlphas(alphas);
    for (var i = 0; i < numericalFeatures.length; i++) {
      numericalFeatures[i].alpha = alphas[i];
    }
    update();
    return state;
  }
}
