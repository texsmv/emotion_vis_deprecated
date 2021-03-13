import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:emotion_vis/models/emotions_models.dart';
import 'package:emotion_vis/models/visualization_levels.dart';
import 'package:emotion_vis/visualizations/non_temporal/dimensional_scatterplot/dimensional_scatterplot.dart';
import 'package:emotion_vis/visualizations/non_temporal/polar_coord_line/polar_coord_line.dart';
import 'package:emotion_vis/visualizations/non_temporal/radar/radar.dart';
import 'package:emotion_vis/visualizations/vis_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home_controller.dart';

class InstantView extends GetView<HomeController> {
  const InstantView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SeriesController _seriesController = Get.find();
    Widget instantWidget;
    if (controller.emotionModelType == EmotionModelType.DIMENSIONAL) {
      switch (controller.dimensionalInstantVisualization) {
        case DimensionalInstantVisualization.DimensionalScatterplot:
          instantWidget = DimensionalScatterplot(
            timePoint: 0,
            personModel: controller.queriedPersonData,
            visSettings: VisSettings(
              colors: Map.fromIterable(_seriesController.dimensions,
                  key: (dimension) => dimension.name,
                  value: (dimension) => dimension.color),
              lowerLimits: _seriesController.lowerBounds,
              upperLimits: _seriesController.upperBounds,
              variablesNames: controller.variablesNames,
              timeLabels: List.generate(_seriesController.temporalLength,
                  (index) => index.toString()),
            ),
          );
          break;

        default:
      }
    } else if (controller.emotionModelType == EmotionModelType.DISCRETE) {
      switch (controller.discreteInstantVisualization) {
        case DiscreteInstantVisualization.RADAR:
          instantWidget = PolarCoordLine(
            personModel: controller.queriedPersonData,
            timePoint: 0,
            visSettings: VisSettings(
              colors: Map.fromIterable(_seriesController.dimensions,
                  key: (dimension) => dimension.name,
                  value: (dimension) => dimension.color),
              lowerLimits: _seriesController.lowerBounds,
              upperLimits: _seriesController.upperBounds,
              variablesNames: controller.variablesNames,
              timeLabels: List.generate(_seriesController.temporalLength,
                  (index) => index.toString()),
            ),
          );
          break;

        default:
      }
    }
    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(10),
        child: instantWidget,
      ),
    );
  }
}
