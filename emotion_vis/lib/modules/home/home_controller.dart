import 'package:emotion_vis/controllers/dimension_reduction_controller.dart';
import 'package:emotion_vis/controllers/projection_controller.dart';
import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/controllers/visualization_controller.dart';
import 'package:emotion_vis/models/emotions_models.dart';
import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/models/time_unit.dart';
import 'package:emotion_vis/models/visualization_levels.dart';
import 'package:emotion_vis/repositories/projections_repository.dart';
import 'package:emotion_vis/time_series/models/MTSerie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // DimensionReductionController dimensionReductionController = Get.find();
  SeriesController _seriesController = Get.find();
  ProjectionController _projectionController = Get.find();
  List<PersonModel> get clusteredPersons => _seriesController.clusteredPersons;
  List<String> get variablesNames => List.generate(
      _seriesController.dimensions.length,
      (index) => _seriesController.dimensions[index].name);

  EmotionModelType get emotionModelType => _seriesController.modelType;

  DiscreteTemporalVisualization get discreteTemporalVisualization =>
      _seriesController.discreteTemporalVisualization.value;
  DimensionalTemporalVisualization get dimensionalTemporalVisualization =>
      _seriesController.dimensionalTemporalVisualization.value;

  DiscreteInstantVisualization get discreteInstantVisualization =>
      _seriesController.discreteInstantVisualization.value;
  DimensionalInstantVisualization get dimensionalInstantVisualization =>
      _seriesController.dimensionalInstantVisualization.value;

  PersonModel get queriedPersonData => _seriesController.selectedPerson;

  // MTPoint get queriedPersonPointData => visualizationSettings.personMTPoint;

  List<PersonModel> get queriedPersonsData => _seriesController.persons;

  RxBool showReducedView = false.obs;

  // List<PersonDataPoint> get personDataPoints =>
  //     dimensionReductionController.personDataPoints;

  void calculateMds() async {
    // dimensionReductionController.calculate_D();
    await _seriesController.setEmotionAlphas(
      List.generate(_seriesController.dimensions.length,
          (index) => _seriesController.dimensions[index].alpha),
    );
    await _seriesController.setNumericalAlphas(
      List.generate(_seriesController.numericalFeatures.length,
          (index) => _seriesController.numericalFeatures[index].alpha),
    );
    await _seriesController.setCategoricalAlphas(
      List.generate(_seriesController.categoricalFeatures.length,
          (index) => _seriesController.categoricalFeatures[index].alpha),
    );
    _projectionController.calculateMdsCoordinates();
  }

  @override
  void onInit() {
    print("Starting");
    // _seriesController.loadValuesInRange(0, _seriesController.windowSize);
    print(_seriesController.lowerBound);
    print(_seriesController.upperBound);

    // visualizationSettings.initializeSelectedPerson();
    // visualizationSettings.nextWindow();
    print("Finished");
    super.onInit();
  }

  void nextWindow() {
    // visualizationSettings.nextWindow();
  }

  // * Visualization settings

  int get windowSize => _seriesController.windowSize;

  set windowSize(int value) {
    // visualizationSettings.windowTimeUnitQuantity.value = value;
  }

  // ------------ Window step size stuff -----------------------

  int get windowStepSize => _seriesController.windowStep;

  set windowStepSize(int value) {
    // visualizationSettings.windowBiasTimeUnitQuantity.value = value;
  }

  // ------------ Play button stuff -----------------------
  AnimationController playController;

  RxBool _play = false.obs;

  bool get play => _play.value;

  set play(bool value) {
    _play.value = value;
    if (_play.value) {
      playController.forward();
      reproduceController.reset();
      reproduceController.forward();
    } else
      playController.reverse();
  }

  // ------------ Reproduce loop stuff -----------------------

  AnimationController reproduceController;
}
