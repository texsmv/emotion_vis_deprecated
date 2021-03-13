import 'dart:math';

import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/models/MTSerie.dart';
import 'package:emotion_vis/models/TSerie.dart';
import 'package:emotion_vis/models/dataset_info_model.dart';
import 'package:emotion_vis/models/dataset_settings_model.dart';
import 'package:emotion_vis/models/person_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_color/random_color.dart';

class VisualizationsViewUiController extends GetxController {
  SeriesController _seriesController = Get.find();
  List<PersonModel> get persons => _seriesController.persons;
  Map<String, Color> get colors =>
      Map.fromIterable(_seriesController.dimensions,
          key: (dimension) => dimension.name,
          value: (dimension) => dimension.color);
  Map<String, double> get lowerLimits =>
      _seriesController.datasetSettings.lowerBounds;
  Map<String, double> get upperLimits =>
      _seriesController.datasetSettings.upperBounds;

  DatasetSettingsModel get datasetSettings => _seriesController.datasetSettings;
  DatasetInfoModel get datasetInfoModel =>
      _seriesController.procesedDatasetInfo;
  // // ------------------------ test stuff -------------------------
  // MTSerie meanValues;
  // MTSerie maxValues;
  // MTSerie minValues;
  // List<PersonModel> persons;
  // List<String> timeLabels;

  // int timeLength = 200;
  // int varLength = 3;
  // int instanceLength = 5;
  // Map<String, Color> colors;

  // List<String> get variablesNames => colors.keys.toList();

  // double maxValue = 15;
  // double minValue = 5;

  // @override
  // void onInit() {
  //   updateData();
  //   super.onInit();
  // }

  // void updateData() {
  //   Random random = new Random();
  //   persons = [];
  //   timeLabels = [];
  //   colors = {};

  //   for (var i = 0; i < instanceLength; i++) {
  //     String id = i.toString();
  //     Map<String, List<double>> valuesMap = {};
  //     for (var j = 0; j < varLength; j++) {
  //       List<double> values = List.generate(timeLength, (index) => 0);
  //       for (var k = 0; k < timeLength; k++) {
  //         values[k] = random.nextInt((maxValue - minValue).toInt()) + minValue;
  //       }
  //       valuesMap[j.toString() + " variable"] = values;
  //     }
  //     PersonModel personModel = PersonModel.fromMap(map: valuesMap, id: id);
  //     persons.add(personModel);
  //   }

  //   for (var i = 0; i < varLength; i++) {
  //     String varName = i.toString() + " variable";
  //     Color color = RandomColor().randomColor();
  //     colors[varName] = color;
  //   }

  //   for (var i = 0; i < timeLength; i++) {
  //     String label = i.toString() + " label";
  //     timeLabels.add(label);
  //   }
  //   Map<String, TSerie> meansMap = {};
  //   for (var i = 0; i < varLength; i++) {
  //     List<double> values = List.generate(timeLength, (index) => null);
  //     for (var j = 0; j < timeLength; j++) {
  //       values[j] = 0;
  //       for (var k = 0; k < instanceLength; k++) {
  //         values[j] = values[j] + persons[k].mtSerie.at(j, variablesNames[i]);
  //       }
  //       values[j] = values[j] / instanceLength;
  //     }
  //     meansMap[variablesNames[i]] = TSerie(values: values);
  //     // print(values);
  //   }
  //   meanValues = MTSerie(timeSeries: meansMap);

  //   Map<String, TSerie> maxMap = {};
  //   for (var i = 0; i < varLength; i++) {
  //     List<double> values = List.generate(timeLength, (index) => null);
  //     for (var j = 0; j < timeLength; j++) {
  //       values[j] = persons[0].mtSerie.at(j, variablesNames[i]);
  //       for (var k = 0; k < instanceLength; k++) {
  //         if (values[j] < persons[k].mtSerie.at(j, variablesNames[i]))
  //           values[j] = persons[k].mtSerie.at(j, variablesNames[i]);
  //       }
  //     }
  //     maxMap[variablesNames[i]] = TSerie(values: values);
  //   }
  //   maxValues = MTSerie(timeSeries: maxMap);

  //   Map<String, TSerie> minMap = {};
  //   for (var i = 0; i < varLength; i++) {
  //     List<double> values = List.generate(timeLength, (index) => null);
  //     for (var j = 0; j < timeLength; j++) {
  //       values[j] = persons[0].mtSerie.at(j, variablesNames[i]);
  //       for (var k = 0; k < instanceLength; k++) {
  //         if (values[j] > persons[k].mtSerie.at(j, variablesNames[i]))
  //           values[j] = persons[k].mtSerie.at(j, variablesNames[i]);
  //       }
  //     }
  //     minMap[variablesNames[i]] = TSerie(values: values);
  //     print(values);
  //   }
  //   minValues = MTSerie(timeSeries: minMap);
  // }

  // ---------------------------------------------------------------
}
