import 'package:get/get.dart';
import 'dart:convert';

import 'MTSerie.dart';
import 'TSerie.dart';

class PersonModel {
  String id;
  MTSerie mtSerie;
  double x;
  double y;
  Map<String, dynamic> metadata;
  List<String> numericalLabels;
  List<double> numericalValues;
  List<String> categoricalLabels;
  List<String> categoricalValues;

  RxInt _clusterId = RxInt();
  int get clusterId => _clusterId.value;
  set clusterId(int value) => _clusterId.value = value;

  PersonModel({this.id, this.mtSerie});

  PersonModel.fromMap({Map<String, dynamic> map, String id}) {
    this.id = id;
    Map<String, TSerie> values = {};
    List<String> dimensions = map.keys.toList();
    for (int i = 0; i < dimensions.length; i++) {
      List<double> doubleList = map[dimensions[i]].cast<double>();
      values[dimensions[i]] = TSerie(values: doubleList);
    }
    mtSerie = MTSerie(timeSeries: values);
  }
}
