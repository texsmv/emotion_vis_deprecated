import 'package:emotion_vis/controllers/dimension_reduction_controller.dart';
import 'package:emotion_vis/controllers/projection_controller.dart';
import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/controllers/visualization_controller.dart';
import 'package:emotion_vis/models/emotions_models.dart';
import 'package:emotion_vis/models/visualization_levels.dart';
import 'package:emotion_vis/modules/home/components/serie_card.dart';
import 'package:emotion_vis/modules/home/home_controller.dart';
import 'package:emotion_vis/visualizations/non_temporal/projections_plot/projections_plot.dart';
import 'package:emotion_vis/visualizations/non_temporal/scatter_chart/scatter_chart.dart';
import 'package:emotion_vis/visualizations/single_temporal/linear_chart/linear_chart.dart';
import 'package:emotion_vis/visualizations/single_temporal/temporal_glyph/temporal_glyph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TemporalMultiView extends GetView<HomeController> {
  bool showReducedView;
  TemporalMultiView({Key key, this.showReducedView = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showReducedView)
      return Container(
        width: double.infinity,
        height: double.infinity,
        child: GetBuilder<ProjectionController>(
          builder: (projectionController) {
            if (!projectionController.projectionLoaded)
              return Center(
                child: Text("Empty"),
              );

            return ProjectionPlot(
              onTap: List.generate(
                controller.queriedPersonsData.length,
                (index) => () {
                  // Get.find<VisualizationController>().selectedPersonId =
                  //     controller.personDataPoints[index].personModel.id;
                },
              ),
              xlim: Offset(-3, 3),
              ylim: Offset(-3, 3),
              personModels: controller.queriedPersonsData,
            );
          },
        ),
      );
    else
      return Container(
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10,
              crossAxisCount: 1,
              childAspectRatio: Get.width * 2 / Get.height,
            ),
            itemCount: controller.queriedPersonsData.length,
            itemBuilder: (context, index) {
              return SerieCard(
                  personModel: controller.queriedPersonsData[index]);
            }),
      );
  }
}
