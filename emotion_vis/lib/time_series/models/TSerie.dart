import 'package:emotion_vis/time_series/models/TPoint.dart';

class TSerie {
  String name;
  List<TPoint> tpoints;

  TSerie({List<double> values, List<DateTime> dates, this.name}) {
    assert(values.length == dates.length);
    tpoints = List.filled(values.length, null);
    for (int i = 0; i < values.length; i++) {
      tpoints[i] = TPoint(dateTime: dates[i], value: values[i]);
    }
  }

  TSerie dateTimeQuery(DateTime begin, DateTime end) {
    List<double> queryValues = [];
    List<DateTime> queryDates = [];
    for (int i = 0; i < tpoints.length; i++) {
      if (tpoints[i].dateTime.isBefore(end) &&
          tpoints[i].dateTime.isAfter(begin)) {
        queryDates.add(tpoints[i].dateTime);
        queryValues.add(tpoints[i].value);
      }
    }
    return TSerie(values: queryValues, dates: queryDates, name: name);
  }
}
