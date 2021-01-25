import 'dart:convert';

import 'package:emotion_vis/enums/app_enums.dart';
import 'package:http/http.dart';

class SeriesRepository {
  static String urlRoot = 'http://127.0.0.1:5000/';

  static Future<NotifierState> addEml(
      String xmlString, bool isCategorical) async {
    String isCategoricalStr = isCategorical ? 'True' : 'False';
    var response = await post(urlRoot + "openEml",
        body: {'eml': xmlString, 'isCategorical': isCategoricalStr});

    if (response.body.contains("Error")) return NotifierState.ERROR;
    return NotifierState.SUCCESS;
  }

  static Future<List<String>> getIds() async {
    var response = await post(urlRoot + "getIds");
    return List<String>.from(jsonDecode(response.body));
  }

  static Future<List<double>> getBounds() async {
    var response = await post(urlRoot + "getBounds");
    return List<double>.from(jsonDecode(response.body));
  }

  static Future<NotifierState> setBounds(
      double minValue, double maxValue) async {
    var response = await post(urlRoot + "setBounds",
        body: {'min': minValue.toString(), 'max': maxValue.toString()});
    return NotifierState.SUCCESS;
  }

  static Future<NotifierState> calculateBounds() async {
    var response = await post(urlRoot + "calculateBounds");
    return NotifierState.SUCCESS;
  }

  static Future<int> getInstanceLength() async {
    var response = await post(urlRoot + "getInstanceLength");
    int length = int.parse(response.body);
    return length;
  }

  static Future<int> getTimeLength() async {
    var response = await post(urlRoot + "getTimeLength");
    int seriesLength = int.parse(response.body);
    return seriesLength;
  }

  static Future<List<String>> getDimensionsLabels() async {
    var response = await post(urlRoot + "getDimensionsLabels");
    return List<String>.from(jsonDecode(response.body));
  }

  static Future<Map<String, dynamic>> getAllValuesInRange(
      int begin, int end) async {
    var response = await post(urlRoot + "getValuesInRange",
        body: {'end': end.toString(), 'begin': begin.toString()});
    Map<String, dynamic> queryMap = jsonDecode(response.body);

    return queryMap;
  }

  static Future<NotifierState> initializeDataset() async {
    var response = await post(urlRoot + "initialize");
    return NotifierState.SUCCESS;
  }

  static Future<List<String>> getNumericalLabels() async {
    var response = await post(urlRoot + "getNumericalLabels");
    List<String> labels = List<String>.from(jsonDecode(response.body));
    return labels;
  }

  static Future<List<String>> getCategoricalLabels() async {
    var response = await post(urlRoot + "getCategoricalLabels");
    List<String> labels = List<String>.from(jsonDecode(response.body));
    return labels;
  }

  static Future<NotifierState> setEmotionAlphas(List<double> alphas) async {
    var response = await post(urlRoot + "setEmotionAlphas",
        body: {'alphas': jsonEncode(alphas)});
    return NotifierState.SUCCESS;
  }

  static Future<NotifierState> setNumericalAlphas(List<double> alphas) async {
    var response = await post(urlRoot + "setNumericalAlphas",
        body: {'alphas': jsonEncode(alphas)});
    return NotifierState.SUCCESS;
  }

  static Future<NotifierState> setCategoricalAlphas(List<double> alphas) async {
    var response = await post(urlRoot + "setCategoricalAlphas",
        body: {'alphas': jsonEncode(alphas)});
    return NotifierState.SUCCESS;
  }
}
