import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:timeseries_charts/models/MTSerie.dart';
import 'package:timeseries_charts/models/TSerie.dart';
import 'package:timeseries_charts/models/person_model.dart';
import 'dart:math';
import 'package:graphic/graphic.dart' as graphic;
import 'package:timeseries_charts/visualizations/overview/stacked_bar_chart.dart/stacked_bar_chart.dart';
import 'package:timeseries_charts/visualizations/temporal/linear_chart/linear_chart.dart';
import 'package:timeseries_charts/visualizations/temporal/stack_chart/stack_chart.dart';
import 'package:timeseries_charts/visualizations/temporal/temporal_glyph/temporal_glyph.dart';
import 'package:timeseries_charts/visualizations/vis_settings.dart';

class VisualizationTest extends StatefulWidget {
  VisualizationTest({Key key}) : super(key: key);

  @override
  _VisualizationTestState createState() => _VisualizationTestState();
}

class _VisualizationTestState extends State<VisualizationTest> {
  MTSerie meanValues;
  MTSerie maxValues;
  MTSerie minValues;
  List<PersonModel> persons;
  List<String> timeLabels;

  int timeLength = 200;
  int varLength = 3;
  int instanceLength = 5;
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
    Map<String, TSerie> meansMap = {};
    for (var i = 0; i < varLength; i++) {
      List<double> values = List.generate(timeLength, (index) => null);
      for (var j = 0; j < timeLength; j++) {
        values[j] = 0;
        for (var k = 0; k < instanceLength; k++) {
          values[j] = values[j] + persons[k].mtSerie.at(j, variablesNames[i]);
        }
        values[j] = values[j] / instanceLength;
      }
      meansMap[variablesNames[i]] = TSerie(values: values);
      // print(values);
    }
    meanValues = MTSerie(timeSeries: meansMap);

    Map<String, TSerie> maxMap = {};
    for (var i = 0; i < varLength; i++) {
      List<double> values = List.generate(timeLength, (index) => null);
      for (var j = 0; j < timeLength; j++) {
        values[j] = persons[0].mtSerie.at(j, variablesNames[i]);
        for (var k = 0; k < instanceLength; k++) {
          if (values[j] < persons[k].mtSerie.at(j, variablesNames[i]))
            values[j] = persons[k].mtSerie.at(j, variablesNames[i]);
        }
      }
      maxMap[variablesNames[i]] = TSerie(values: values);
    }
    maxValues = MTSerie(timeSeries: maxMap);

    Map<String, TSerie> minMap = {};
    for (var i = 0; i < varLength; i++) {
      List<double> values = List.generate(timeLength, (index) => null);
      for (var j = 0; j < timeLength; j++) {
        values[j] = persons[0].mtSerie.at(j, variablesNames[i]);
        for (var k = 0; k < instanceLength; k++) {
          if (values[j] > persons[k].mtSerie.at(j, variablesNames[i]))
            values[j] = persons[k].mtSerie.at(j, variablesNames[i]);
        }
      }
      minMap[variablesNames[i]] = TSerie(values: values);
      print(values);
    }
    minValues = MTSerie(timeSeries: minMap);
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
              updateData();
            });
          },
          label: Text("set state")),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: StackedBarChart(
                mtSerie: meanValues,
                visSettings: VisSettings(
                  colors: colors,
                  lowerLimit: 0,
                  upperLimit: maxValue * varLength,
                  variablesNames: variablesNames,
                  timeLabels: timeLabels,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      height: 280,
                      // child: TemporalGlyph(
                      //   personModel: persons[index],
                      //   visSettings: VisSettings(
                      //     colors: colors,
                      //     lowerLimit: minValue,
                      //     upperLimit: maxValue,
                      //     variablesNames: variablesNames,
                      //     timeLabels: timeLabels,
                      //   ),
                      // ),
                      child: StackChart(
                        personModel: persons[index],
                        visSettings: VisSettings(
                          colors: colors,
                          lowerLimit: minValue,
                          upperLimit: maxValue,
                          variablesNames: variablesNames,
                          timeLabels: timeLabels,
                        ),
                      ),
                      // child: TemporalLinearChart(
                      //   personModel: persons[index],
                      //   visSettings: VisSettings(
                      //     colors: colors,
                      //     lowerLimit: minValue,
                      //     upperLimit: maxValue,
                      //     variablesNames: variablesNames,
                      //     timeLabels: timeLabels,
                      //   ),
                      // ),
                    ),
                  );
                },
                itemCount: persons.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
