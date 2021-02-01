import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:timeseries_charts/models/MTSerie.dart';
import 'package:timeseries_charts/models/person_model.dart';
import 'dart:math';
import 'package:graphic/graphic.dart' as graphic;
import 'package:timeseries_charts/visualizations/non_temporal/dimensional_scatterplot/dimensional_scatterplot.dart';
import 'package:timeseries_charts/visualizations/non_temporal/polar_coord_line/polar_coord_line.dart';
import 'package:timeseries_charts/visualizations/temporal/linear_chart/linear_chart.dart';
import 'package:timeseries_charts/visualizations/temporal/stack_chart/stack_chart.dart';
import 'package:timeseries_charts/visualizations/temporal/temporal_glyph/temporal_glyph.dart';
import 'package:timeseries_charts/visualizations/vis_settings.dart';

class VisualizationNtTest extends StatefulWidget {
  VisualizationNtTest({Key key}) : super(key: key);

  @override
  _VisualizationNtTestState createState() => _VisualizationNtTestState();
}

class _VisualizationNtTestState extends State<VisualizationNtTest> {
  List<PersonModel> persons;
  List<String> timeLabels;

  int timeLength = 10;
  int varLength = 3;
  int instanceLength = 5;
  int timePoint = 0;
  Map<String, Color> colors;

  List<String> get variablesNames => colors.keys.toList();

  double maxValue = 15;
  double minValue = 5;

  void updateData() {
    Random random = new Random();
    persons = [];
    timeLabels = [];
    colors = {};

    for (var i = 0; i < instanceLength; i++) {
      String id = i.toString();
      Map<String, List<double>> valuesMap = {};
      for (var j = 0; j < varLength; j++) {
        List<double> values = List.generate(timeLength, (index) => 0);
        for (var k = 0; k < timeLength; k++) {
          values[k] = random.nextInt((maxValue - minValue).toInt()) + minValue;
        }
        valuesMap[j.toString() + " variable"] = values;
      }
      PersonModel personModel = PersonModel.fromMap(map: valuesMap, id: id);
      persons.add(personModel);
    }

    for (var i = 0; i < varLength; i++) {
      String varName = i.toString() + " variable";
      Color color = RandomColor().randomColor();
      colors[varName] = color;
    }

    for (var i = 0; i < timeLength; i++) {
      String label = i.toString() + " label";
      timeLabels.add(label);
    }
  }

  @override
  void initState() {
    updateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              timePoint = timePoint + 1;
              if (timePoint == timeLength) timePoint = 0;
            });
          },
          label: Text("set state")),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: ListView.builder(
          itemBuilder: (_, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Container(
                height: 350,
                // child: PolarCoordLine(
                //   personModel: persons[index],
                //   timePoint: timePoint,
                //   visSettings: VisSettings(
                //     colors: colors,
                //     lowerLimit: minValue,
                //     upperLimit: maxValue,
                //     variablesNames: variablesNames,
                //     timeLabels: timeLabels,
                //   ),
                // ),
                child: DimensionalScatterplot(
                  personModel: persons[index],
                  timePoint: timePoint,
                  visSettings: VisSettings(
                    colors: colors,
                    lowerLimit: minValue,
                    upperLimit: maxValue,
                    variablesNames: variablesNames,
                    timeLabels: timeLabels,
                  ),
                ),
              ),
            );
          },
          itemCount: persons.length,
        ),
      ),
    );
  }
}
