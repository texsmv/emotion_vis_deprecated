import 'dart:convert';

import 'package:emotion_vis/app_constants.dart';
import 'package:emotion_vis/enums/app_enums.dart';
import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:emotion_vis/models/emotions_models.dart';
import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/models/visualization_levels.dart';
import 'package:emotion_vis/repositories/projections_repository.dart';
import 'package:emotion_vis/repositories/series_repository.dart';
import 'package:emotion_vis/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_color/random_color.dart';
import 'package:tuple/tuple.dart';

class SeriesController extends GetxController {
  Map<String, double> minValues;
  Map<String, double> maxValues;
  Map<String, double> upperBounds;
  Map<String, double> lowerBounds;

  List<double> alphas = [];

  List<String> variablesNames = [];
  List<String> emotionsVariablesNames = [];
  List<String> metadataVariablesNames = [];

  List<String> dates = [];
  List<String> allowedDownsampleRules = [];
  bool isDataDated = false;

  List<PersonModel> _persons = [];

  List<String> _ids = [];
  List<String> get ids => _ids;

  int _windowLength = 7;
  int _windowPosition = 0;

  int _instanceLength = 0;
  int _timeLength = 0;
  int _variablesLength = 0;
  int _emotionsVariablesLength = 0;
  int _metadataVariablesLength = 0;

  int get instanceLength => _instanceLength;
  int get temporalLength => _timeLength;
  int get timeLength => _timeLength;
  int get variablesLength => _variablesLength;
  int get emotionsVariablesLength => _emotionsVariablesLength;
  int get metadataVariablesLength => _metadataVariablesLength;

  int get emotionDimensionLength => dimensions.length;

  int get windowLength => _windowLength;
  int get windowPosition => _windowPosition;

  PersonModel _selectedPerson;
  PersonModel get selectedPerson => _selectedPerson;
  set selectedPerson(PersonModel personModel) {
    _selectedPerson = personModel;
    update();
  }

  List<PersonModel> get persons => _persons;

  List<String> clustersLabels = [];
  Map<String, List<String>> clusters = {};
  Map<String, Color> clustersColors = {};

  List<PersonModel> blueCluster = [];
  List<PersonModel> redCluster = [];
  // List<PersonModel> get clusteredPersons =>
  //     List.from(blueCluster)..addAll(redCluster);

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
    return Colors.black;
  }

  Color get dominanceColor {
    for (var i = 0; i < dimensions.length; i++) {
      if (dimensions[i].dimensionalDimension == DimensionalDimension.DOMINANCE)
        return dimensions[i].color;
    }
    return Colors.black;
  }

  Color get arousalColor {
    for (var i = 0; i < dimensions.length; i++) {
      if (dimensions[i].dimensionalDimension == DimensionalDimension.AROUSAL)
        return dimensions[i].color;
    }
    return Colors.black;
  }

  /// Temporal visualization choosed for emotion model type
  DiscreteTemporalVisualization _discreteTemporalVisualization =
      DiscreteTemporalVisualization.values[0];
  DimensionalTemporalVisualization _dimensionalTemporalVisualization =
      DimensionalTemporalVisualization.values[0];

  DiscreteTemporalVisualization get discreteTemporalVisualization =>
      _discreteTemporalVisualization;

  set discreteTemporalVisualization(DiscreteTemporalVisualization value) {
    _discreteTemporalVisualization = value;
    update();
  }

  DimensionalTemporalVisualization get dimensionalTemporalVisualization =>
      _dimensionalTemporalVisualization;

  set dimensionalTemporalVisualization(DimensionalTemporalVisualization value) {
    _dimensionalTemporalVisualization = value;
    update();
  }

  /// Instant visualization choosed for emotion model type
  DiscreteInstantVisualization _discreteInstantVisualization =
      DiscreteInstantVisualization.values[0];
  DimensionalInstantVisualization _dimensionalInstantVisualization =
      DimensionalInstantVisualization.values[0];

  DimensionalInstantVisualization get dimensionalInstantVisualization =>
      _dimensionalInstantVisualization;

  set dimensionalInstantVisualization(DimensionalInstantVisualization value) {
    _dimensionalInstantVisualization = value;
    update();
  }

  DiscreteInstantVisualization get discreteInstantVisualization =>
      _discreteInstantVisualization;

  set discreteInstantVisualization(DiscreteInstantVisualization value) {
    _discreteInstantVisualization = value;
    update();
  }

  EmotionModelType _modelType = EmotionModelType.DISCRETE;
  EmotionModelType get modelType => _modelType;
  set modelType(EmotionModelType value) {
    _modelType = value;
    update();
  }

  Future<NotifierState> loadMTSeriesInRange(int begin, int end) async {
    _persons = [];
    Map<String, dynamic> queryMap =
        await SeriesRepository.getMTSeriesInRange(begin, end);

    // Map<String, dynamic> metadataMap = await SeriesRepository.getAllMetadata();
    List<String> ids = queryMap.keys.toList();

    for (int i = 0; i < ids.length; i++) {
      Map dimensions = queryMap[ids[i]]["temporalVariables"];
      print(dimensions);
      PersonModel personModel =
          PersonModel.fromMap(map: dimensions, id: ids[i]);
      personModel.metadata = queryMap[ids[i]]['metadata'];
      personModel.categoricalValues =
          queryMap[ids[i]]['categoricalFeatures'].cast<String>();
      personModel.categoricalLabels =
          queryMap[ids[i]]['categoricalLabels'].cast<String>();
      print(personModel.categoricalLabels);
      print("Almonst!!");
      personModel.numericalValues =
          queryMap[ids[i]]['numericalFeatures'].cast<double>();
      personModel.numericalLabels =
          queryMap[ids[i]]['numericalLabels'].cast<String>();
      print("DONE!!");
      _persons.add(personModel);
    }
    update();
    return NotifierState.SUCCESS;
  }

  void updateLocalSettings({int windowPosition, int windowLength}) {
    if (windowPosition != null) _windowPosition = windowPosition;
    if (windowLength != null) _windowLength = windowLength;

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

  Future<NotifierState> initEmotionsVariables({
    @required List<String> names,
    @required List<Color> colors,
    List<DimensionalDimension> dimensionalDimensions,
  }) async {
    dimensions = List.generate(
      names.length,
      (index) => EmotionDimension(
          name: names[index],
          color: colors[index],
          dimensionalDimension: dimensionalDimensions != null
              ? dimensionalDimensions[index]
              : DimensionalDimension.NONE),
    );
    update();
    return NotifierState.SUCCESS;
  }

  @deprecated
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

  Future<NotifierState> removeMarkedVariables(List<String> names) async {
    await SeriesRepository.removeVariables(names);
    update();
    return NotifierState.SUCCESS;
  }

  void setVariablesNames({
    @required List<String> emotionsNames,
    @required List<String> metadataNames,
    bool notify = true,
  }) {
    metadataVariablesNames = metadataNames;
    emotionsVariablesNames = emotionsNames;
    _emotionsVariablesLength = emotionsNames.length;
    _metadataVariablesLength = metadataNames.length;
    if (notify) update();
  }

  Future<NotifierState> initDataInfo() async {
    Map<String, dynamic> info = await SeriesRepository.computeDataInfo();
    _timeLength = info[INFO_LEN_TIME];
    _instanceLength = info[INFO_LEN_INSTANCE];
    _variablesLength = info[INFO_LEN_VARIABLES];
    variablesNames = List<String>.from(info[INFO_SERIES_LABELS]);
    isDataDated = info[INFO_IS_DATED];
    if (isDataDated) {
      dates = List<String>.from(info[INFO_DATES]);
      allowedDownsampleRules = List<String>.from(info[INFO_DOWNSAMPLE_RULES]);
    }
    minValues = Map<String, double>.from(info[INFO_MIN_VALUES]);
    maxValues = Map<String, double>.from(info[INFO_MAX_VALUES]);
    update();
    return NotifierState.SUCCESS;
  }

  Future<NotifierState> initSettings() async {
    alphas = List.filled(emotionsVariablesLength, 1.0);
    lowerBounds = minValues;
    upperBounds = maxValues;
    await SeriesRepository.setSettings(
      alphas: alphas,
      emotionLabels: emotionsVariablesNames,
      lowerBounds: minValues,
      upperBounds: maxValues,
    );
    return NotifierState.SUCCESS;
  }

  Future<NotifierState> updateSettings({
    List<double> alphas,
    List<String> emotionLabels,
    Map<String, double> lowerBounds,
    Map<String, double> upperBounds,
  }) async {
    if (alphas != null) this.alphas = alphas;
    if (emotionLabels != null) this.emotionsVariablesNames = emotionLabels;
    if (lowerBounds != null) this.lowerBounds = lowerBounds;
    if (upperBounds != null) this.upperBounds = upperBounds;
    await SeriesRepository.setSettings(
      alphas: this.alphas,
      emotionLabels: this.emotionsVariablesNames,
      lowerBounds: this.lowerBounds,
      upperBounds: this.upperBounds,
    );
    return NotifierState.SUCCESS;
  }

  Future<NotifierState> downsampleData(DownsampleRule rule) async {
    await SeriesRepository.downsampleData(Utils.downsampleRule2Str(rule));
    return NotifierState.SUCCESS;
  }

  // * Projection stuff

  List<String> variablesNamesOrdered;
  double projectionMaxValue = -1;
  bool projectionLoaded = false;

  Future<NotifierState> calculateMdsCoordinates() async {
    Map<String, dynamic> coordsMap =
        await ProjectionsRepository.getMDScoords(emotionsVariablesNames);

    for (var i = 0; i < persons.length; i++) {
      var coord = coordsMap[persons[i].id];
      persons[i].x = coord[0];
      persons[i].y = coord[1];

      if (persons[i].x.abs() > projectionMaxValue)
        projectionMaxValue = persons[i].x.abs();
      if (persons[i].y.abs() > projectionMaxValue)
        projectionMaxValue = persons[i].y.abs();
    }
    projectionLoaded = true;
    update();

    print(coordsMap);
  }

  Future<NotifierState> orderSeriesByRank(
      String clusterA, String clusterB) async {
    List<String> blueClusterIds = clusters[clusterA];
    List<String> redClusterIds = clusters[clusterB];
    if (blueClusterIds.length == 0 || redClusterIds.length == 0)
      return NotifierState.ERROR;

    variablesNamesOrdered =
        await ProjectionsRepository.getSubsetsDimensionsRankings(
      blueClusterIds,
      redClusterIds,
    );
    this.blueCluster = List.generate(blueClusterIds.length,
        (index) => personModelById(blueClusterIds[index]));
    this.redCluster = List.generate(
        redClusterIds.length, (index) => personModelById(redClusterIds[index]));
    print(this.blueCluster);
    print(this.redCluster);
    update();
    return NotifierState.SUCCESS;
  }

  Future<NotifierState> doClustering({int k = 3}) async {
    Map<String, dynamic> result = await SeriesRepository.doClustering();
    List<String> clusterLabels = result.keys.map((e) => e).toList();
    this.clustersLabels = clusterLabels;
    clustersColors = {};
    clusters = {};
    for (var i = 0; i < clusterLabels.length; i++) {
      print(clusterLabels[i]);
      List<String> clusterIds = List<String>.from(result[clusterLabels[i]]);
      clusters[clusterLabels[i]] = clusterIds;
      clustersColors[clusterLabels[i]] = RandomColor().randomColor();
      for (var j = 0; j < clusterIds.length; j++) {
        PersonModel personModel = personModelById(clusterIds[j]);
        personModel.clusterId = clusterLabels[i];
      }
    }

    update();
  }

  PersonModel personModelById(String id) {
    for (var i = 0; i < persons.length; i++) {
      if (persons[i].id == id) {
        return persons[i];
      }
    }
  }
}
