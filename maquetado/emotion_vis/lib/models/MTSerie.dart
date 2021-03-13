import 'TSerie.dart';

class MTSerie {
  List<DateTime> dateTimes;
  Map<String, TSerie> timeSeries;

  MTSerie({this.timeSeries, this.dateTimes});

  int get timeLength => timeSeries[variablesNames[0]].length;

  int get variablesLength => timeSeries.length;

  double at(int position, String dimension) =>
      timeSeries[dimension].at(position);

  TSerie getSerie(String dimension) => timeSeries[dimension];

  List<String> get variablesNames => timeSeries.keys.toList();
}
