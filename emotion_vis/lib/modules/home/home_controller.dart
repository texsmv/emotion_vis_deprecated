import 'package:emotion_vis/controllers/dimension_reduction_controller.dart';
import 'package:emotion_vis/controllers/projection_controller.dart';
import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/models/emotions_models.dart';
import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/models/time_unit.dart';
import 'package:emotion_vis/models/visualization_levels.dart';
import 'package:emotion_vis/repositories/projections_repository.dart';
import 'package:emotion_vis/time_series/models/MTSerie.dart';
import 'package:emotion_vis/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  SeriesController _seriesController = Get.find();
  ProjectionController _projectionController = Get.find();

  List<PersonModel> get blueCluster => _seriesController.blueCluster;
  List<PersonModel> get redCluster => _seriesController.redCluster;

  List<String> get variablesNames => List.generate(
      _seriesController.dimensions.length,
      (index) => _seriesController.dimensions[index].name);

  List<String> get variablesOrdered =>
      _projectionController.variablesNamesOrdered ?? variablesNames;

  EmotionModelType get emotionModelType => _seriesController.modelType;

  DiscreteTemporalVisualization get discreteTemporalVisualization =>
      _seriesController.discreteTemporalVisualization;

  DimensionalTemporalVisualization get dimensionalTemporalVisualization =>
      _seriesController.dimensionalTemporalVisualization;

  DiscreteInstantVisualization get discreteInstantVisualization =>
      _seriesController.discreteInstantVisualization;
  DimensionalInstantVisualization get dimensionalInstantVisualization =>
      _seriesController.dimensionalInstantVisualization;

  PersonModel get queriedPersonData => _seriesController.selectedPerson;
  List<PersonModel> get queriedPersonsData => _seriesController.persons;

  RxBool showReducedView = false.obs;

  // List<String> get temporalVisualizationNames {
  //   if (emotionModelType == EmotionModelType.DIMENSIONAL) {
  //     return List.generate(
  //         DimensionalTemporalVisualization.values.length,
  //         (index) => Utils.dimTempVis2Str(
  //             DimensionalTemporalVisualization.values[index]));
  //   } else {
  //     return List.generate(
  //         DiscreteTemporalVisualization.values.length,
  //         (index) => Utils.discTempVis2Str(
  //             DiscreteTemporalVisualization.values[index]));
  //   }
  // }

  // List<String> get instantVisualizationNames {
  //   if (emotionModelType == EmotionModelType.DIMENSIONAL) {
  //     return List.generate(
  //         DimensionalInstantVisualization.values.length,
  //         (index) => Utils.dimInstVis2Str(
  //             DimensionalInstantVisualization.values[index]));
  //   } else {
  //     return List.generate(
  //         DiscreteInstantVisualization.values.length,
  //         (index) => Utils.discInstVis2Str(
  //             DiscreteInstantVisualization.values[index]));
  //   }
  // }

  String currTemporalVisualization() {
    if (emotionModelType == EmotionModelType.DIMENSIONAL) {
      return Utils.dimTempVis2Str(dimensionalTemporalVisualization);
    } else {
      return Utils.discTempVis2Str(discreteTemporalVisualization);
    }
  }

  String currInstantVisualization() {
    if (emotionModelType == EmotionModelType.DIMENSIONAL) {
      return Utils.dimInstVis2Str(dimensionalInstantVisualization);
    } else {
      return Utils.discInstVis2Str(discreteInstantVisualization);
    }
  }

  void chooseTemporalVisualization(String visualizationStr) {}

  @override
  void onInit() {
    super.onInit();
  }

  void calculateMds() async {
    await _seriesController.setEmotionAlphas(
      List.generate(_seriesController.dimensions.length,
          (index) => _seriesController.dimensions[index].alpha),
    );
    _projectionController.calculateMdsCoordinates();
  }

  void orderSeriesByRank() {
    _projectionController.orderSeriesByRank(blueCluster, redCluster);
  }

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
