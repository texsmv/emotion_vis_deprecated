import 'dart:convert';

import 'package:emotion_vis/app_constants.dart';
import 'package:emotion_vis/enums/app_enums.dart';
import 'package:http/http.dart';

class SeriesRepository {
  static String urlRoot = 'http://10.0.2.2:5000/';

  static Future<Map<String, List<String>>> getDatasetsInfo() async {
    var response = await post(urlRoot + "routeGetDatasetsInfo");
    var data = jsonDecode(response.body);
    return {
      "loadedDatasetsIds": data["loadedDatasetsIds"],
      "localDatasetsIds": data["localDatasetsIds"],
    };
  }

  static Future<NotifierState> addEml(
      String xmlString, bool isCategorical) async {
    String isCategoricalStr = isCategorical ? 'True' : 'False';
    var response = await post(urlRoot + "openEml",
        body: {'eml': xmlString, 'isCategorical': isCategoricalStr});

    if (response.body.contains("Error")) return NotifierState.ERROR;
    return NotifierState.SUCCESS;
  }

  @deprecated
  static Future<List<String>> getIds() async {
    var response = await post(urlRoot + "getIds");
    return List<String>.from(jsonDecode(response.body));
  }

  @deprecated
  static Future<List<double>> getBounds() async {
    var response = await post(urlRoot + "getBounds");
    return List<double>.from(jsonDecode(response.body));
  }

  @deprecated
  static Future<NotifierState> setBounds(
      double minValue, double maxValue) async {
    var response = await post(urlRoot + "setBounds",
        body: {'min': minValue.toString(), 'max': maxValue.toString()});
    return NotifierState.SUCCESS;
  }

  @deprecated
  static Future<NotifierState> calculateBounds() async {
    var response = await post(urlRoot + "calculateBounds");
    return NotifierState.SUCCESS;
  }

  @deprecated
  static Future<int> getInstanceLength() async {
    var response = await post(urlRoot + "getInstanceLength");
    int length = int.parse(response.body);
    return length;
  }

  @deprecated
  static Future<int> getTimeLength() async {
    var response = await post(urlRoot + "getTimeLength");
    int seriesLength = int.parse(response.body);
    return seriesLength;
  }

  @deprecated
  static Future<List<String>> getDimensionsLabels() async {
    var response = await post(urlRoot + "getDimensionsLabels");
    return List<String>.from(jsonDecode(response.body));
  }

  @deprecated
  static Future<Map<String, dynamic>> getAllValuesInRange(
      int begin, int end) async {
    var response = await post(urlRoot + "getValuesInRange",
        body: {'end': end.toString(), 'begin': begin.toString()});
    Map<String, dynamic> queryMap = jsonDecode(response.body);

    return queryMap;
  }

  static Future<Map<String, dynamic>> getMTSeriesInRange(
      int begin, int end) async {
    var response = await post(urlRoot + "getMTSeriesInRange",
        body: {'end': end.toString(), 'begin': begin.toString()});
    Map<String, dynamic> queryMap = jsonDecode(response.body);
    print("queryMap");
    print(queryMap);

    return queryMap;
  }

  @deprecated
  static Future<Map<String, dynamic>> getAllMetadata() async {
    var response = await post(urlRoot + "getAllMetadata");
    Map<String, dynamic> queryMap = jsonDecode(response.body);

    return queryMap;
  }

  static Future<NotifierState> initializeDataset() async {
    var response = await post(urlRoot + "initialize");
    return NotifierState.SUCCESS;
  }

  @deprecated
  static Future<List<String>> getNumericalLabels() async {
    var response = await post(urlRoot + "getNumericalLabels");
    List<String> labels = List<String>.from(jsonDecode(response.body));
    return labels;
  }

  @deprecated
  static Future<List<String>> getCategoricalLabels() async {
    var response = await post(urlRoot + "getCategoricalLabels");
    List<String> labels = List<String>.from(jsonDecode(response.body));
    return labels;
  }

  @deprecated
  static Future<NotifierState> setEmotionAlphas(List<double> alphas) async {
    var response = await post(urlRoot + "setEmotionAlphas",
        body: {'alphas': jsonEncode(alphas)});
    return NotifierState.SUCCESS;
  }

  @deprecated
  static Future<NotifierState> setNumericalAlphas(List<double> alphas) async {
    var response = await post(urlRoot + "setNumericalAlphas",
        body: {'alphas': jsonEncode(alphas)});
    return NotifierState.SUCCESS;
  }

  @deprecated
  static Future<NotifierState> setCategoricalAlphas(List<double> alphas) async {
    var response = await post(urlRoot + "setCategoricalAlphas",
        body: {'alphas': jsonEncode(alphas)});
    return NotifierState.SUCCESS;
  }

  static Future<NotifierState> removeVariables(
      List<String> variablesNames) async {
    var response = await post(urlRoot + "removeVariables",
        body: {'names': jsonEncode(variablesNames)});
    return NotifierState.SUCCESS;
  }

  static Future<Map<String, dynamic>> computeDataInfo() async {
    var response = await post(urlRoot + "computeDataInfo");
    Map<String, dynamic> infoMap = jsonDecode(response.body);
    return infoMap;
  }

  static Future<NotifierState> setSettings({
    List<double> alphas,
    List<String> emotionLabels,
    Map<String, double> lowerBounds,
    Map<String, double> upperBounds,
  }) async {
    var response = await post(urlRoot + "setSettings", body: {
      SETTINGS_ALPHAS: jsonEncode(alphas),
      SETTINGS_EMOTIONS_LABELS: jsonEncode(emotionLabels),
      SETTINGS_LOWER_BOUNDS: jsonEncode(lowerBounds),
      SETTINGS_UPPER_BOUNDS: jsonEncode(upperBounds),
      // 'startPosition': jsonEncode(startPosition),
      // 'windowSize': jsonEncode(windowSize),
    });
    return NotifierState.SUCCESS;
  }

  static Future<NotifierState> downsampleData(String rule) async {
    var response = await post(urlRoot + "downsampleData",
        body: {'rule': jsonEncode(rule)});
    return NotifierState.SUCCESS;
  }

  // * projections stuff

  static Future<Map<String, dynamic>> getMDScoords(List<String> labels) async {
    var response =
        await post(urlRoot + "getMDS", body: {'labels': jsonEncode(labels)});
    Map<String, dynamic> coordsMap = jsonDecode(response.body);
    print(coordsMap);
    return coordsMap;
  }

  static Future<Map<String, dynamic>> doClustering({int k = 3}) async {
    var response =
        await post(urlRoot + "doClustering", body: {'k': jsonEncode(k)});
    Map<String, dynamic> clusters = jsonDecode(response.body);
    print(clusters);
    return clusters;
  }

  static Future<List<String>> getSubsetsDimensionsRankings(
      List<String> clusterAIds, List<String> clusterBIds) async {
    var response = await post(urlRoot + "getSubsetsDimensionsRankings", body: {
      'blueCluster': jsonEncode(clusterAIds),
      'redCluster': jsonEncode(clusterBIds)
    });

    Map<String, dynamic> ranks = jsonDecode(response.body);
    ranks = Map<String, double>.from(ranks);
    Map<double, String> reversedMap = {};

    for (var varName in ranks.keys) {
      reversedMap[ranks[varName]] = varName;
    }

    List<double> rankList = ranks.values.toList();
    rankList.sort((b, a) => a.compareTo(b));

    List<String> orderedVariablesNames = [];
    for (var i = 0; i < rankList.length; i++) {
      orderedVariablesNames.add(reversedMap[rankList[i]]);
    }
    return orderedVariablesNames;
  }
}
