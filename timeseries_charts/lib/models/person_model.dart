import 'package:get/get.dart';
import 'package:timeseries_charts/models/MTSerie.dart';

import 'TSerie.dart';

class PersonModel {
  String id;
  MTSerie mtSerie;
  double x;
  double y;

  RxInt _clusterId = RxInt();
  int get clusterId => _clusterId.value;
  set clusterId(int value) => _clusterId.value = value;

  PersonModel({this.id, this.mtSerie});

  PersonModel.fromMap({Map map, String id}) {
    this.id = id;
    Map<String, TSerie> values = {};
    List<String> dimensions = map.keys.toList();
    for (int i = 0; i < dimensions.length; i++) {
      values[dimensions[i]] = TSerie(values: map[dimensions[i]]);
    }
    mtSerie = MTSerie(timeSeries: values);
  }
}
