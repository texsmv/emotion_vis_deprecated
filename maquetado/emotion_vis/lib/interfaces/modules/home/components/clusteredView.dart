import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/interfaces/modules/home/components/projection_view/projection_view_ui_controller.dart';
import 'package:emotion_vis/interfaces/modules/home/home_ui_controller.dart';
import 'package:emotion_vis/interfaces/visualizations/single_temporal/cluster_linear_chart/cluster_linear_chart.dart';
import 'package:emotion_vis/interfaces/visualizations/vis_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menu_button/menu_button.dart';

class ClusteredView extends GetView<ProjectionViewUiController> {
  const ClusteredView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SeriesController _seriesController = Get.find();
    return Container(
      child: Column(
        children: [
          Text("Comparison"),
          Container(
            height: 50,
            child: GetBuilder<SeriesController>(
              builder: (_) => Row(
                children: [
                  Obx(
                    () => MenuButton<int>(
                      child: Container(
                        width: 120,
                        height: 30,
                        color: Get.theme.primaryColor,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          controller.clusterIdA.value.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                      items: controller.clusterIds,
                      topDivider: true,
                      scrollPhysics: AlwaysScrollableScrollPhysics(),
                      onItemSelected: (value) {
                        controller.clusterIdA.value = value;
                      },
                      onMenuButtonToggle: (isToggle) {},
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white.withAlpha(0)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.white.withAlpha(0),
                      ),
                      divider: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      toggledChild: Container(
                        height: 30,
                      ),
                      itemBuilder: (int value) => Container(
                        width: 80,
                        height: 30,
                        color: Colors.white,
                        alignment: Alignment.centerLeft,
                        child: Text(value.toString()),
                      ),
                    ),
                  ),
                  Obx(
                    () => MenuButton<int>(
                      child: Container(
                        width: 120,
                        height: 30,
                        color: Get.theme.primaryColor,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          controller.clusterIdB.value.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                      items: controller.clusterIds,
                      topDivider: true,
                      scrollPhysics: AlwaysScrollableScrollPhysics(),
                      onItemSelected: (value) {
                        controller.clusterIdB.value = value;
                      },
                      onMenuButtonToggle: (isToggle) {},
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white.withAlpha(0)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.white.withAlpha(0),
                      ),
                      divider: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      toggledChild: Container(
                        height: 30,
                      ),
                      itemBuilder: (int value) => Container(
                          width: 80,
                          height: 30,
                          color: Colors.white,
                          alignment: Alignment.centerLeft,
                          child: Text(value.toString())),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GetBuilder<SeriesController>(builder: (_) {
              return ListView.builder(
                itemCount: controller.variablesOrdered.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
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
                            visSettings: VisSettings(
                              upperLimits:
                                  _seriesController.datasetSettings.upperBounds,
                              lowerLimits:
                                  _seriesController.datasetSettings.lowerBounds,
                              variablesNames: _seriesController
                                  .datasetSettings.emotionsVariablesNames,
                            ),
                            blueCluster: controller.blueCluster,
                            redCluster: controller.redCluster,
                            variableName: controller.variablesOrdered[index],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
