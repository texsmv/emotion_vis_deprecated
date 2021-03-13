import 'package:get/get.dart';
import 'dart:convert';

import 'MTSerie.dart';
import 'TSerie.dart';

class PersonModel {
  String id = "";
  MTSerie mtSerie = MTSerie(timeSeries: {}, dateTimes: []);
  double x = 0;
  double y = 0;
  Map<String, dynamic> metadata = {};
  List<String> numericalLabels = [];
  List<double> numericalValues = [];
  List<String> categoricalLabels = [];
  List<String> categoricalValues = [];

  RxInt _clusterId = RxInt();
  int get clusterId => _clusterId.value;
  set clusterId(int value) => _clusterId.value = value;

  PersonModel({this.id = "", this.mtSerie});

  PersonModel.fromMap({Map<dynamic, dynamic> map = const {}, this.id = ""}) {
    this.id = id;
    Map<String, TSerie> values = {};
    List<String> dimensions = List.from(map.keys.toList());
    for (int i = 0; i < dimensions.length; i++) {
      List<double> doubleList = map[dimensions[i]].cast<double>();
      values[dimensions[i]] = TSerie(values: doubleList);
    }
    // todo check this datetimes parameter
    this.mtSerie = MTSerie(timeSeries: values, dateTimes: []);
  }
}
