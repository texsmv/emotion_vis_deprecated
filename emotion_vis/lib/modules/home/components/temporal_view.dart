import 'package:emotion_vis/controllers/visualization_controller.dart';
import 'package:emotion_vis/models/emotions_models.dart';
import 'package:emotion_vis/models/visualization_levels.dart';
import 'package:emotion_vis/modules/home/home_controller.dart';
import 'package:emotion_vis/visualizations/single_temporal/linear_chart/linear_chart.dart';
import 'package:emotion_vis/visualizations/single_temporal/temporal_glyph/temporal_glyph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TemporalView extends GetView<HomeController> {
  const TemporalView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget temporalWidget;
    if (controller.emotionModelType == EmotionModelType.DIMENSIONAL) {
      switch (controller.dimensionalTemporalVisualization) {
        case DimensionalTemporalVisualization.GLYPH:
          temporalWidget = TemporalGlyph(
            personModel: controller.queriedPersonData,
          );
          break;

        default:
      }
    } else if (controller.emotionModelType == EmotionModelType.DISCRETE) {
      switch (controller.discreteTemporalVisualization) {
        case DiscreteTemporalVisualization.LINEAR:
          temporalWidget = TemporalLinearChart(
            personModel: controller.queriedPersonData,
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
