import 'package:emotion_vis/controllers/projection_controller.dart';
import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/modules/home/home_controller.dart';
import 'package:emotion_vis/visualizations/single_temporal/cluster_linear_chart/cluster_linear_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClusteredView extends GetView<HomeController> {
  const ClusteredView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetBuilder<ProjectionController>(
        builder: (_) => GetBuilder<SeriesController>(
          builder: (_) => ListView.builder(
            itemCount: controller.variablesOrdered.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    Container(
                      height: 30,
                      child: Text(controller.variablesOrdered[index]),
                    ),
                    Container(
                      height: 200,
                      width: 600,
                      child: ClusterLinearChart(
                        blueCluster: controller.blueCluster,
                        redCluster: controller.redCluster,
                        variableName: controller.variablesOrdered[index],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
