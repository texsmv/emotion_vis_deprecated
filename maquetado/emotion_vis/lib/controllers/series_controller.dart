import 'dart:convert';

import 'package:emotion_vis/app_constants.dart';
import 'package:emotion_vis/enums/app_enums.dart';
import 'package:emotion_vis/models/MTSerie.dart';
import 'package:emotion_vis/models/dataset_info_model.dart';
import 'package:emotion_vis/models/dataset_settings_model.dart';
import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/models/visualization_levels.dart';
import 'package:emotion_vis/repositories/series_repository.dart';
import 'package:emotion_vis/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_color/random_color.dart';

class SeriesController extends GetxController {
  List<String> loadedDatasetsIds = [];
  List<String> localDatasetsIds = [];

  List<PersonModel> _persons = [];

  int _windowLength = 7;
  int _windowPosition = 0;
  int get windowLength => _windowLength;
  int get windowPosition => _windowPosition;

  int get emotionDimensionLength => dimensions.length;

  PersonModel _selectedPerson;
  PersonModel get selectedPerson => _selectedPerson;
  set selectedPerson(PersonModel personModel) {
    _selectedPerson = personModel;
    update();
  }

  List<PersonModel> get persons => _persons;

  List<int> clusterIds = [];
  Map<int, List<String>> clusters = {};
  Map<int, Color> clustersColors = {};

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

  void updateLocalSettings({int windowPosition = 0, int windowLength = 1}) {
    if (windowPosition != null) _windowPosition = windowPosition;
    if (windowLength != null) _windowLength = windowLength;

    update();
  }

  // Future<NotifierState> initializeDataset() async {
  //   return await repositoryInitializeDataset();
  // }

  Future<void> updateIds() async {
    //  TODO fix this
    // _ids = await repositoryGetIds();
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

  // @deprecated
  // Future<void> loadFeatures() async {
  //   List<String> numericalLabels = await repositoryGetNumericalLabels();
  //   print(numericalLabels);
  //   for (var i = 0; i < numericalLabels.length; i++) {
  //     numericalFeatures.add(NumericalFeature(name: numericalLabels[i]));
  //   }

  //   List<String> categoricalLabels = await repositorygetCategoricalLabels();
  //   print(categoricalLabels);
  //   for (var i = 0; i < categoricalLabels.length; i++) {
  //     categoricalFeatures.add(CategoricalFeature(name: categoricalLabels[i]));
  //   }
  //   update();
  // }

  // Future<NotifierState> setEmotionAlphas(List<double> alphas) async {
  //   assert(alphas.length == dimensions.length);
  //   NotifierState state = await repositorySetEmotionAlphas(alphas);
  //   for (var i = 0; i < dimensions.length; i++) {
  //     dimensions[i].alpha = alphas[i];
  //   }
  //   update();
  //   return state;
  // }

  // Future<NotifierState> removeMarkedVariables(List<String> names) async {
  //   await repositoryRemoveVariables(names);
  //   update();
  //   return NotifierState.SUCCESS;
  // }

  void setVariablesNames({
    @required List<String> emotionsNames = const [],
    @required List<String> metadataNames = const [],
    bool notify = true,
  }) {
    datasetSettings.metadataVariablesNames = metadataNames;
    datasetSettings.emotionsVariablesNames = emotionsNames;
    if (notify) update();
  }

  Future<NotifierState> initSettings() async {
    datasetSettings.lowerBounds =
        Map<String, double>.from(originalDatasetInfo.minValues);
    datasetSettings.upperBounds =
        Map<String, double>.from(originalDatasetInfo.maxValues);
    datasetSettings.alphas = {};
    for (var i = 0; i < datasetSettings.emotionsVariablesLength; i++) {
      datasetSettings.alphas[datasetSettings.emotionsVariablesNames[i]] = 1;
    }

    return NotifierState.SUCCESS;
  }

  void updateSettings({
    Map<String, double> alphas,
    List<String> emotionLabels,
    Map<String, double> lowerBounds,
    Map<String, double> upperBounds,
  }) {
    if (alphas != null) this.datasetSettings.alphas = alphas;
    if (emotionLabels != null)
      this.datasetSettings.emotionsVariablesNames = emotionLabels;
    if (lowerBounds != null) this.datasetSettings.lowerBounds = lowerBounds;
    if (upperBounds != null) this.datasetSettings.upperBounds = upperBounds;
  }

  Future<NotifierState> downsampleData(DownsampleRule rule) async {
    await repositoryDownsampleData(Utils.downsampleRule2Str(rule));
    return NotifierState.SUCCESS;
  }

  // * Projection stuff

  List<String> variablesNamesOrdered = [];
  double projectionMaxValue = -1;
  bool projectionLoaded = false;

  Future<NotifierState> calculateMdsCoordinates() async {
    Map<String, dynamic> coordsMap =
        await repositoryGetMDScoords(datasetSettings.emotionsVariablesNames);

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
    return NotifierState.SUCCESS;
    print(coordsMap);
  }

  Future<NotifierState> getFishersDiscriminantRanking(
      int clusterA, int clusterB) async {
    List<String> blueClusterIds = clusters[clusterA];
    List<String> redClusterIds = clusters[clusterB];
    if (blueClusterIds.length == 0 || redClusterIds.length == 0)
      return NotifierState.ERROR;

    variablesNamesOrdered = await repositoryGetFishersDiscriminantRanking(
      selectedDatasetId,
      d_k,
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

  PersonModel personModelById(String id) {
    for (var i = 0; i < persons.length; i++) {
      if (persons[i].id == id) {
        return persons[i];
      }
    }
    return PersonModel(mtSerie: MTSerie(dateTimes: [], timeSeries: {}));
  }
  // -------------------------- NEW STUFF-------------------------

  String selectedDatasetId;
  DatasetInfoModel originalDatasetInfo;
  DatasetInfoModel procesedDatasetInfo;
  DatasetSettingsModel datasetSettings = DatasetSettingsModel();
  Map<String, dynamic> d_k;
  Map<String, dynamic> coords;

  Future<NotifierState> getDatasetsInfo() async {
    final Map<String, List<String>> data = await repositoryGetDatasetsInfo();
    loadedDatasetsIds = data["loadedDatasetsIds"];
    localDatasetsIds = data["localDatasetsIds"];
    update();
    return NotifierState.SUCCESS;
  }

  Future<NotifierState> loadLocalDataset(String datasetId) async {
    final NotifierState state = await repositoryLoadLocalDataset(datasetId);
    return state;
  }

  Future<NotifierState> removeDataset(String datasetId) async {
    final NotifierState state = await repositoryRemoveDataset(datasetId);
    return state;
  }

  Future<NotifierState> initializeDataset(String datasetId) async {
    final NotifierState state = await repositoryInitializeDataset(datasetId);
    return state;
  }

  Future<NotifierState> addEml(String datasetId, String eml) async {
    return repositoryAddEml(datasetId, eml);
  }

  Future<void> getDatasetInfo(bool procesed) async {
    Map<String, dynamic> infoMap =
        await repositoryGetDatasetInfo(selectedDatasetId, procesed);
    if (procesed) {
      procesedDatasetInfo = DatasetInfoModel.fromMap(info: infoMap);
    } else {
      originalDatasetInfo = DatasetInfoModel.fromMap(info: infoMap);
    }
  }

  Future<NotifierState> getMTSeries(
    List<String> ids,
    int begin,
    int end, {
    bool procesed = true,
  }) async {
    _persons = [];
    Map<String, dynamic> queryMap = await repositoryGetMTSeries(
        selectedDatasetId, begin, end, ids,
        procesed: procesed);

    for (int i = 0; i < ids.length; i++) {
      Map dimensions = queryMap[ids[i]]["temporalVariables"];
      PersonModel personModel =
          PersonModel.fromMap(map: dimensions, id: ids[i]);
      personModel.metadata = queryMap[ids[i]]['metadata'];
      personModel.categoricalValues =
          queryMap[ids[i]]['categoricalFeatures'].cast<String>();
      personModel.categoricalLabels =
          queryMap[ids[i]]['categoricalLabels'].cast<String>();
      personModel.numericalValues =
          queryMap[ids[i]]['numericalFeatures'].cast<double>();
      personModel.numericalLabels =
          queryMap[ids[i]]['numericalLabels'].cast<String>();
      _persons.add(personModel);
    }
    update();
    return NotifierState.SUCCESS;
  }

  Future<NotifierState> compute_d_k(
    bool procesed,
  ) async {
    Map<String, dynamic> queryMap = await repositoryCompute_d_k(
        selectedDatasetId, datasetSettings.emotionsVariablesNames,
        procesed: procesed);
    d_k = queryMap;
    print(queryMap);
    return NotifierState.SUCCESS;
  }

  Future<NotifierState> getDatasetProjection() async {
    Map<String, dynamic> coordsMap = await repositoryGetDatasetProjection(
        selectedDatasetId, d_k, datasetSettings.alphas);
    coords = coordsMap;
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
    return NotifierState.SUCCESS;
  }

  Future<NotifierState> doClustering({int k = 3}) async {
    Map<String, dynamic> result =
        await repositoryDoClustering(selectedDatasetId, coords, k);

    final List<String> keys = result.keys.toList();
    final List<int> clusterIds =
        List.generate(keys.length, (index) => int.parse(keys[index]));
    this.clusterIds = clusterIds;
    clustersColors = {};
    clusters = {};
    for (var i = 0; i < clusterIds.length; i++) {
      List<String> clusterElements = List<String>.from(result[keys[i]]);
      clusters[clusterIds[i]] = clusterElements;
      clustersColors[clusterIds[i]] = RandomColor().randomColor();
      for (var j = 0; j < clusterElements.length; j++) {
        PersonModel personModel = personModelById(clusterElements[j]);
        personModel.clusterId = clusterIds[i];
      }
    }

    update();
    return NotifierState.SUCCESS;
  }
}
