import 'dart:convert';

import 'package:emotion_vis/enums/app_enums.dart';
import 'package:http/http.dart';

class ProjectionsRepository {
  static String urlRoot = 'http://10.0.2.2:5000/';

  static Future<Map<String, dynamic>> getMDScoords(List<String> labels) async {
    var response =
        await post(urlRoot + "getMDS", body: {'labels': jsonEncode(labels)});
    Map<String, dynamic> coordsMap = jsonDecode(response.body);
    print(coordsMap);
    return coordsMap;
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
