class TSerie {
  List<double> values;

  int get length => values.length;

  double at(int position) => values[position];

  TSerie({List<double> values}) {
    this.values = List.from(values);
  }
}
