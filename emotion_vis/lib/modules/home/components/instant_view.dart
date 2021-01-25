import 'package:emotion_vis/models/emotions_models.dart';
import 'package:emotion_vis/models/visualization_levels.dart';
import 'package:emotion_vis/visualizations/non_temporal/dimensional_scatterplot/dimensional_scatterplot.dart';
import 'package:emotion_vis/visualizations/non_temporal/radar/radar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home_controller.dart';

class InstantView extends GetView<HomeController> {
  const InstantView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget instantWidget;
    // if (controller.emotionModelType == EmotionModelType.DIMENSIONAL) {
    //   switch (controller.dimensionalInstantVisualization) {
    //     case DimensionalInstantVisualization.DimensionalScatterplot:
    //       instantWidget = DimensionalScatterplot(
    //         mtPoint: controller.queriedPersonPointData,
    //       );
    //       break;

    //     default:
    //   }
    // } else if (controller.emotionModelType == EmotionModelType.DISCRETE) {
    //   switch (controller.discreteInstantVisualization) {
    //     case DiscreteInstantVisualization.RADAR:
    //       instantWidget = InstantRadar(
    //         mtPoint: controller.queriedPersonPointData,
    //       );
    //       break;

    //     default:
    //   }
    // }
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
