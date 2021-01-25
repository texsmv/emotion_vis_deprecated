import 'package:emotion_vis/time_series/models/MTSerie.dart';
import 'package:get/get.dart';

class PersonModel {
  String id;
  MTSerie mtSerie;

  Map<String, List<double>> values;
  double x;
  double y;

  RxInt _clusterId = RxInt();
  int get clusterId => _clusterId.value;
  set clusterId(int value) => _clusterId.value = value;

  PersonModel({this.id, this.mtSerie});

  PersonModel.fromMap({Map map, String id}) {
    this.id = id;
    this.values = {};
    List<String> dimensions = map.keys.toList();
    for (int i = 0; i < dimensions.length; i++) {
      values[dimensions[i]] = List<double>.from(map[dimensions[i]]);
    }
  }

  int get temporalLength => values.values.toList()[0].length;
  int get dimensionsLength => values.keys.toList().length;
}
