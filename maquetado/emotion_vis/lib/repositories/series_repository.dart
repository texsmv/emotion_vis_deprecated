import 'dart:convert';

import 'package:emotion_vis/app_constants.dart';
import 'package:emotion_vis/enums/app_enums.dart';
import 'package:http/http.dart';

Future<Map<String, List<String>>> repositoryGetDatasetsInfo() async {
  final response = await post(hostUrl + "routeGetDatasetsInfo");
  final data = jsonDecode(response.body);
  return {
    "loadedDatasetsIds": List<String>.from(data["loadedDatasetsIds"]),
    "localDatasetsIds": List<String>.from(data["localDatasetsIds"]),
  };
}

Future<NotifierState> repositoryLoadLocalDataset(String datasetId) async {
  final response =
      await post(hostUrl + "loadLocalDataset", body: {"datasetId": datasetId});
  final data = jsonDecode(response.body);
  if (data["state"] == "success") {
    return NotifierState.SUCCESS;
  } else {
    return NotifierState.ERROR;
  }
}

Future<NotifierState> repositoryRemoveDataset(String datasetId) async {
  final response =
      await post(hostUrl + "removeDataset", body: {"datasetId": datasetId});
  final data = jsonDecode(response.body);
  if (data["state"] == "success") {
    return NotifierState.SUCCESS;
  } else {
    return NotifierState.ERROR;
  }
}

Future<NotifierState> repositoryInitializeDataset(String datasetId) async {
  final response =
      await post(hostUrl + "initializeDataset", body: {"datasetId": datasetId});
  final data = jsonDecode(response.body);
  if (data["state"] == "success") {
    return NotifierState.SUCCESS;
  } else {
    return NotifierState.ERROR;
  }
}

Future<NotifierState> repositoryAddEml(String datasetId, String eml) async {
  final response = await post(hostUrl + "addEmlToDataset", body: {
    "datasetId": datasetId,
    'eml': eml,
  });
  final data = jsonDecode(response.body);

  if (data["state"] == "success") {
    return NotifierState.SUCCESS;
  } else {
    return NotifierState.ERROR;
  }
}

Future<Map<String, dynamic>> repositoryGetDatasetInfo(
    String datasetId, bool procesed) async {
  final response = await post(hostUrl + "getDatasetInfo", body: {
    "datasetId": datasetId,
    "procesed": procesed ? "True" : "False",
  });
  Map<String, dynamic> infoMap = jsonDecode(response.body);
  return infoMap;
}

Future<Map<String, dynamic>> repositoryGetMTSeries(
    String datasetId, int begin, int end, List<String> ids,
    {bool procesed = true}) async {
  var response = await post(hostUrl + "getMTSeries", body: {
    "datasetId": datasetId,
    'end': jsonEncode(end),
    'begin': jsonEncode(begin),
    'ids': jsonEncode(ids),
    "procesed": procesed ? "True" : "False",
  });
  Map<String, dynamic> queryMap = jsonDecode(response.body);
  return queryMap;
}

Future<Map<String, dynamic>> repositoryCompute_d_k(
    String datasetId, List<String> variables,
    {bool procesed = true}) async {
  var response = await post(hostUrl + "computeDk", body: {
    "datasetId": datasetId,
    'variables': jsonEncode(variables),
    "procesed": procesed ? "True" : "False",
  });
  Map<String, dynamic> queryMap = jsonDecode(response.body);
  print(queryMap);
  return queryMap;
}

Future<Map<String, dynamic>> repositoryGetDatasetProjection(
  String datasetId,
  Map<String, dynamic> d_k,
  Map<String, double> alphas,
) async {
  var response = await post(hostUrl + "getDatasetProjection", body: {
    "datasetId": datasetId,
    'D_k': jsonEncode(d_k),
    "alphas": jsonEncode(alphas),
  });
  Map<String, dynamic> queryMap = jsonDecode(response.body);
  return queryMap;
}

Future<Map<String, dynamic>> repositoryDoClustering(
    String datasetId, Map<String, dynamic> coords, int k) async {
  var response = await post(hostUrl + "doClustering", body: {
    "datasetId": datasetId,
    'coords': jsonEncode(coords),
    'k': jsonEncode(k),
  });
  Map<String, dynamic> clusters = jsonDecode(response.body);
  print(clusters);
  return clusters;
}

Future<List<String>> repositoryGetFishersDiscriminantRanking(
  String datasetId,
  Map<String, dynamic> d_k,
  List<String> clusterAIds,
  List<String> clusterBIds,
) async {
  var response = await post(hostUrl + "getFishersDiscriminantRanking", body: {
    "datasetId": datasetId,
    'D_k': jsonEncode(d_k),
    'blueCluster': jsonEncode(clusterAIds),
    'redCluster': jsonEncode(clusterBIds)
  });

  Map<String, dynamic> ranks = jsonDecode(response.body);
  ranks = Map<String, double>.from(ranks);
  Map<double, String> reversedMap = {};

  for (var varName in ranks.keys) {
    reversedMap[ranks[varName]] = varName;
  }

  List<double> rankList = List.from(ranks.values.toList());
  rankList.sort((b, a) => a.compareTo(b));

  List<String> orderedVariablesNames = [];
  for (var i = 0; i < rankList.length; i++) {
    orderedVariablesNames.add(reversedMap[rankList[i]]);
  }
  return orderedVariablesNames;
}

// Future<NotifierState> repositoryInitializeDataset() async {
//   var response = await post(hostUrl + "initialize");
//   return NotifierState.SUCCESS;
// }

// Future<Map<String, dynamic>> repositoryComputeDataInfo() async {
//   var response = await post(hostUrl + "computeDataInfo");
//   Map<String, dynamic> infoMap = jsonDecode(response.body);
//   return infoMap;
// }

Future<NotifierState> repositorySetSettings({
  List<double> alphas,
  List<String> emotionLabels,
  Map<String, double> lowerBounds,
  Map<String, double> upperBounds,
}) async {
  var response = await post(hostUrl + "setSettings", body: {
    SETTINGS_ALPHAS: jsonEncode(alphas),
    SETTINGS_EMOTIONS_LABELS: jsonEncode(emotionLabels),
    SETTINGS_LOWER_BOUNDS: jsonEncode(lowerBounds),
    SETTINGS_UPPER_BOUNDS: jsonEncode(upperBounds),
    // 'startPosition': jsonEncode(startPosition),
    // 'windowSize': jsonEncode(windowSize),
  });
  return NotifierState.SUCCESS;
}

Future<NotifierState> repositoryDownsampleData(String rule) async {
  var response =
      await post(hostUrl + "downsampleData", body: {'rule': jsonEncode(rule)});
  return NotifierState.SUCCESS;
}

// * projections stuff

Future<Map<String, dynamic>> repositoryGetMDScoords(List<String> labels) async {
  var response =
      await post(hostUrl + "getMDS", body: {'labels': jsonEncode(labels)});
  Map<String, dynamic> coordsMap = jsonDecode(response.body);
  print(coordsMap);
  return coordsMap;
}

// Future<Map<String, dynamic>> repositoryDoClustering({int k = 3}) async {
//   var response =
//       await post(hostUrl + "doClustering", body: {'k': jsonEncode(k)});
//   Map<String, dynamic> clusters = jsonDecode(response.body);
//   print(clusters);
//   return clusters;
// }

Future<List<String>> repositoryGetSubsetsDimensionsRankings(
    List<String> clusterAIds, List<String> clusterBIds) async {
  var response = await post(hostUrl + "getSubsetsDimensionsRankings", body: {
    'blueCluster': jsonEncode(clusterAIds),
    'redCluster': jsonEncode(clusterBIds)
  });

  Map<String, dynamic> ranks = jsonDecode(response.body);
  ranks = Map<String, double>.from(ranks);
  Map<double, String> reversedMap = {};

  for (var varName in ranks.keys) {
    reversedMap[ranks[varName]] = varName;
  }

  List<double> rankList = List.from(ranks.values.toList());
  rankList.sort((b, a) => a.compareTo(b));

  List<String> orderedVariablesNames = [];
  for (var i = 0; i < rankList.length; i++) {
    orderedVariablesNames.add(reversedMap[rankList[i]]);
  }
  return orderedVariablesNames;
}

// @deprecated
// Future<List<String>> getIds() async {
//   var response = await post(hostUrl + "getIds");
//   return List<String>.from(jsonDecode(response.body));
// }

// @deprecated
// Future<List<double>> getBounds() async {
//   var response = await post(hostUrl + "getBounds");
//   return List<double>.from(jsonDecode(response.body));
// }

// @deprecated
// Future<NotifierState> setBounds(double minValue, double maxValue) async {
//   var response = await post(hostUrl + "setBounds",
//       body: {'min': minValue.toString(), 'max': maxValue.toString()});
//   return NotifierState.SUCCESS;
// }

// @deprecated
// Future<NotifierState> calculateBounds() async {
//   var response = await post(hostUrl + "calculateBounds");
//   return NotifierState.SUCCESS;
// }

// @deprecated
// Future<int> getInstanceLength() async {
//   var response = await post(hostUrl + "getInstanceLength");
//   int length = int.parse(response.body);
//   return length;
// }

// @deprecated
// Future<int> getTimeLength() async {
//   var response = await post(hostUrl + "getTimeLength");
//   int seriesLength = int.parse(response.body);
//   return seriesLength;
// }

// @deprecated
// Future<List<String>> getDimensionsLabels() async {
//   var response = await post(hostUrl + "getDimensionsLabels");
//   return List<String>.from(jsonDecode(response.body));
// }

// @deprecated
// Future<Map<String, dynamic>> getAllValuesInRange(int begin, int end) async {
//   var response = await post(hostUrl + "getValuesInRange",
//       body: {'end': end.toString(), 'begin': begin.toString()});
//   Map<String, dynamic> queryMap = jsonDecode(response.body);

//   return queryMap;
// }

// @deprecated
// Future<Map<String, dynamic>> getAllMetadata() async {
//   var response = await post(hostUrl + "getAllMetadata");
//   Map<String, dynamic> queryMap = jsonDecode(response.body);

//   return queryMap;
// }

// @deprecated
// Future<List<String>> getNumericalLabels() async {
//   var response = await post(hostUrl + "getNumericalLabels");
//   List<String> labels = List<String>.from(jsonDecode(response.body));
//   return labels;
// }

// @deprecated
// Future<List<String>> getCategoricalLabels() async {
//   var response = await post(hostUrl + "getCategoricalLabels");
//   List<String> labels = List<String>.from(jsonDecode(response.body));
//   return labels;
// }

// @deprecated
// Future<NotifierState> setEmotionAlphas(List<double> alphas) async {
//   var response = await post(hostUrl + "setEmotionAlphas",
//       body: {'alphas': jsonEncode(alphas)});
//   return NotifierState.SUCCESS;
// }

// @deprecated
// Future<NotifierState> setNumericalAlphas(List<double> alphas) async {
//   var response = await post(hostUrl + "setNumericalAlphas",
//       body: {'alphas': jsonEncode(alphas)});
//   return NotifierState.SUCCESS;
// }

// @deprecated
// Future<NotifierState> setCategoricalAlphas(List<double> alphas) async {
//   var response = await post(hostUrl + "setCategoricalAlphas",
//       body: {'alphas': jsonEncode(alphas)});
//   return NotifierState.SUCCESS;
// }
