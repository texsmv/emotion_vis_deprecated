import 'package:emotion_vis/time_series/models/TPoint.dart';
import 'package:emotion_vis/time_series/models/TSerie.dart';

class MTSerie {
  Map<String, TSerie> timeSeries;

  MTSerie({this.timeSeries}) {
    // dateTimes.sort();
  }

  MTSerie dateTimeQuery(DateTime begin, DateTime end) {
    Map<String, TSerie> queryTimeSeries = {};
    List<DateTime> queryDateTimes;

    List<String> mtSdimensions = dimensions;
    for (var i = 0; i < mtSdimensions.length; i++) {
      queryTimeSeries[mtSdimensions[i]] =
          timeSeries[mtSdimensions[i]].dateTimeQuery(begin, end);
    }

    return MTSerie(timeSeries: queryTimeSeries);
  }

  List<int> get lengths => List.generate(timeSeries.length,
      (index) => timeSeries[dimensions[index]].tpoints.length);

  int get length => lengths[0];

  double at(int position, String dimension) =>
      timeSeries[dimension].tpoints[position].value;

  List<String> get dimensions => timeSeries.keys.toList();

  DateTime get firstDateTime => timeSeries[dimensions[0]].tpoints[0].dateTime;
  DateTime get lastDateTime => timeSeries[dimensions[0]]
      .tpoints[timeSeries[dimensions[0]].tpoints.length - 1]
      .dateTime;

  int get n_dimensions => timeSeries.length;

  MTPoint getDataAtPos(int i) {
    MTPoint mtPoint = MTPoint();
    List<double> values = List.filled(n_dimensions, 0);
    List<String> names = List.filled(n_dimensions, "");
    DateTime dateTime;
    for (var i = 0; i < n_dimensions; i++) {
      values[i] = timeSeries[dimensions[i]].tpoints[lengths[i] - 1].value;
      names[i] = timeSeries[dimensions[i]].name;
    }
    dateTime = timeSeries[dimensions[0]].tpoints[lengths[0] - 1].dateTime;
    return MTPoint(values: values, names: names, dateTime: dateTime);
  }
}

class MTPoint {
  List<double> values;
  List<String> names;
  DateTime dateTime;

  MTPoint({this.values, this.names, this.dateTime});
}
