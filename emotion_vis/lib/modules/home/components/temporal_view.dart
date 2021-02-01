import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/models/emotions_models.dart';
import 'package:emotion_vis/models/visualization_levels.dart';
import 'package:emotion_vis/modules/home/home_controller.dart';
import 'package:emotion_vis/visualizations/single_temporal/linear_chart/linear_chart.dart';
import 'package:emotion_vis/visualizations/single_temporal/stack_chart/stack_chart.dart';
import 'package:emotion_vis/visualizations/single_temporal/temporal_glyph/temporal_glyph.dart';
import 'package:emotion_vis/visualizations/vis_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TemporalView extends GetView<HomeController> {
  const TemporalView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SeriesController _seriesController = Get.find();
    Widget temporalWidget;
    if (controller.emotionModelType == EmotionModelType.DIMENSIONAL) {
      switch (controller.dimensionalTemporalVisualization) {
        case DimensionalTemporalVisualization.GLYPH:
          temporalWidget = TemporalGlyph(
            personModel: controller.queriedPersonData,
            visSettings: VisSettings(
              colors: Map.fromIterable(_seriesController.dimensions,
                  key: (dimension) => dimension.name,
                  value: (dimension) => dimension.color),
              lowerLimit: _seriesController.lowerBound,
              upperLimit: _seriesController.upperBound,
              variablesNames: controller.variablesNames,
              timeLabels: List.generate(_seriesController.temporalLength,
                  (index) => index.toString()),
            ),
          );
          break;
        case DimensionalTemporalVisualization.STACK_CHART:
          temporalWidget = StackChart(
            personModel: controller.queriedPersonData,
            visSettings: VisSettings(
              colors: Map.fromIterable(_seriesController.dimensions,
                  key: (dimension) => dimension.name,
                  value: (dimension) => dimension.color),
              lowerLimit: _seriesController.lowerBound,
              upperLimit: _seriesController.upperBound,
              variablesNames: controller.variablesNames,
              timeLabels: List.generate(_seriesController.temporalLength,
                  (index) => index.toString()),
            ),
          );
          break;

        default:
      }
    } else if (controller.emotionModelType == EmotionModelType.DISCRETE) {
      switch (controller.discreteTemporalVisualization) {
        case DiscreteTemporalVisualization.LINEAR:
          temporalWidget = TemporalLinearChart(
            personModel: controller.queriedPersonData,
            visSettings: VisSettings(
              colors: Map.fromIterable(_seriesController.dimensions,
                  key: (dimension) => dimension.name,
                  value: (dimension) => dimension.color),
              lowerLimit: _seriesController.lowerBound,
              upperLimit: _seriesController.upperBound,
              variablesNames: controller.variablesNames,
              timeLabels: List.generate(_seriesController.temporalLength,
                  (index) => index.toString()),
            ),
          );
          break;
        case DiscreteTemporalVisualization.STACK_CHART:
          temporalWidget = StackChart(
            personModel: controller.queriedPersonData,
            visSettings: VisSettings(
              colors: Map.fromIterable(_seriesController.dimensions,
                  key: (dimension) => dimension.name,
                  value: (dimension) => dimension.color),
              lowerLimit: _seriesController.lowerBound,
              upperLimit: _seriesController.upperBound,
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
        child: temporalWidget,
      ),
    );
  }
}
