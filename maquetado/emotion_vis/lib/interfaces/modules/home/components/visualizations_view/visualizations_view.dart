import 'package:emotion_vis/interfaces/constants/colors.dart';
import 'package:emotion_vis/interfaces/modules/home/components/visualizations_view/visualization_view_ui_controller.dart';
import 'package:emotion_vis/interfaces/visualizations/temporal/linear_chart/linear_chart.dart';
import 'package:emotion_vis/interfaces/visualizations/temporal/stack_chart/stack_chart.dart';
import 'package:emotion_vis/interfaces/visualizations/temporal/temporal_glyph/temporal_glyph.dart';
import 'package:emotion_vis/interfaces/visualizations/vis_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VisualizationsView extends GetView<VisualizationsViewUiController> {
  const VisualizationsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: pColorBackground,
      child: ListView.builder(
        itemBuilder: (_, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Container(
              height: 280,
              // child: TemporalGlyph(
              //   personModel: controller.persons[index],
              //   visSettings: VisSettings(
              //     colors: controller.colors,
              //     lowerLimits: controller.lowerLimits,
              //     upperLimits: controller.upperLimits,
              //     variablesNames:
              //         controller.datasetSettings.emotionsVariablesNames,
              //     timeLabels: controller.datasetInfoModel.dates,
              //   ),
              // ),
              // child: StackChart(
              //   personModel: controller.persons[index],
              //   visSettings: VisSettings(
              //     colors: controller.colors,
              //     lowerLimits: controller.lowerLimits,
              //     upperLimits: controller.upperLimits,
              //     variablesNames:
              //         controller.datasetSettings.emotionsVariablesNames,
              //     timeLabels: controller.datasetInfoModel.dates,
              //   ),
              // ),
              child: TemporalLinearChart(
                personModel: controller.persons[index],
                visSettings: VisSettings(
                  colors: controller.colors,
                  lowerLimits: controller.lowerLimits,
                  upperLimits: controller.upperLimits,
                  variablesNames:
                      controller.datasetSettings.emotionsVariablesNames,
                  timeLabels: controller.datasetInfoModel.dates,
                ),
              ),
            ),
          );
        },
        itemCount: controller.persons.length,
      ),
    );
  }
}
